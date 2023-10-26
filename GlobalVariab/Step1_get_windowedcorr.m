function [w_corr,variance_matrix,variance_vector] = get_windowed_correlation(time_courses,w,leonardi_filter,w_shape)

% This function outputs windowed correlation time series of fMRI time
% courses measured in different Regions of Interest (ROIs).

% Input variables
%%%%%%%%%%%%%%%%%

% time_courses          2-D matrix of size (N,T) where N is the number of ROIs
%                       and T is the number of observations.
% w                     Width of the window used to get windowed correlations, 
%                       default value is 30 (times TR).
% leonardi_filter       Boolean taking 'on' or 'off' (default) value and indicating whether 
%                       the highpass filtering suggested in [1] should be applied or not. 
% w_shape               Indicates the shape of the window used to compute
%                       the sliding correlation. Default values is
%                       'squared' but 'tapered', as suggested in [2] to
%                       reduce spurious correlations is also available.

% Output variable
%%%%%%%%%%%%%%%%% 

% w_corr                3-D matrix of size (N,N,T-w+1) containing T-w+1
%                       square correlation matrices of size (N,N).
% variance_matrix       2-D matrix of size (N,N) encoding the variance of
%                       the fluctuations of the correlation between each 
%                       pair of variables.
% variance_vector       Vector of size (1,N). Element i (0<i<N+1) encodes the 
%                       average level of variance of fluctuations in the 
%                       correlations between ROI i and all other ROIs.
%                       The advantage of this way of encoding variance is
%                       that its elements can be plotted on a brain surface. 

% References
%%%%%%%%%%%%

% [1] N. Leonardi and D. Van de Ville, 2015. On spurious and real fluctuations
%     of dynamic functional connectivity during rest. Neuroimage, Vol 104,
%     pp. 430-436.
% [2] F. Pozzi, T. Di Matteo and T. Aste, 2012. Exponential smoothing
%     weighted correlations, Eur Phys J B, Vol. 85, pp. 1-21.
% [3] A. Zalesky et al., 2014. Time-resolved resting-state brain networks.
%     PNAS, Vol. 111, pp. 10341-10346. 

% Author
%%%%%%%%

% RaphaÎl LiÈgeois - R.Liegeois@nus.edu.sg
% ©Copyright 2016


%% Setting default values, if needed

switch nargin
    case 3
        w_shape         = 'squared';
    case 2
        w_shape         = 'squared';
        leonardi_filter = 'off';
    case 1
        w_shape         = 'squared';
        leonardi_filter = 'off';
        w               = 30;
end

%% Get dimension of data

N = size(time_courses,1); % Number of ROIs
T = size(time_courses,2); % Number of observations


%% Display verification message

disp(['Computing sliding correlation from data containing ' num2str(T) ' observations in ' num2str(N) ' ROIs, using a ' w_shape ' window of width ' num2str(w) ' TRs and filtering set to ''' leonardi_filter '''.'])

%% Filtering data, if required


switch leonardi_filter
    
    case 'on' % Filtering at 1/w as suggested in [1]. Its implementation might be handwavy, it should be cross-checked.
        
        fft_tc      = (fft(time_courses'))';
        k_cut       = round(T/w); % cutoff frequency
        filtered_TC = zeros(N,T);
        
        for k=k_cut:round(T/2) % keep only high frequency components 
            add         = (2*(abs(fft_tc(:,k))*ones(1,T)).*cos(ones(N,1)*(2*pi*(k-1)*[0:(T-1)]/T)+angle(fft_tc(:,k))*ones(1,T)))/T;
            filtered_TC = filtered_TC + add;          
        end
        
        TC=filtered_TC;
        
    case 'off' % No filtering
        
        TC = time_courses;
        
    otherwise
        
        disp('Error: value of third input should be ''on'' or ''off'', verify value and/or order of inputs.')
        return
        
end

%% Build the window shape

switch w_shape
    case 'squared'
        shape = ones(w,N)/w;
    case 'tapered' % Implementation as in [3]
        theta = round(w/3);
        w0    = (1-exp(-1/theta))/(1-exp(-w/theta));
        shape = ((w0.*exp(([1:w] - w)/theta))')*ones(1,N);
    otherwise
        disp('Error: value of fourth input should be ''squared'' or ''tapered'', verify value and/or order of inputs.')
end

%% Computation of the sliding windows correlation
w_corr = zeros(N,N,T-w+1);

%%%% here he is shifting the window by 1 TR, so t is moving in increments
%%%% of 1
for t=1:T-w+1
            windowed_series = TC(:,t:(t+w-1))'.*shape;
            windowed_series = bsxfun(@minus, windowed_series, mean(windowed_series, 1));
            windowed_series = bsxfun(@times, windowed_series, 1./sqrt(sum(windowed_series.^2, 1)));
            w_corr(:, :, t) = windowed_series'*windowed_series;
            
end

%% Computation of variance of fluctuations in correlation

variance_matrix = var(w_corr,0,3);          % This has to be checked, perhaps w_corr should be Fischer-
                                            % transformed before computing
                                            % variance. => Perhaps check with Chris. 
variance_vector = sum(variance_matrix)./N ; % Again, this is perhaps not the proper way to do (eventhough it is informative) 
