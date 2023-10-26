%%%%%%%%%%%%%
Created by Giulia Baracchini - October 2023
%%%%%%%%%%%%%

%% Get local/regional BOLD signal variability scores via rMSSD
%% make sure that your whole brain data is meancentered before calculating rMSSD

% Input
%%%%%%%%%%%%%
% time_series           2-D matrix of size (N,T) where N is the number of regions
%                       and T is the number of timepoints.

% Output
%%%%%%%%%%%%%
% rmssd                 vector of size (N,1) where N is the number of regions

%%%%%%%%%%%%%
rmssd = zeros(N,1);

for jj = 1:N
    
    ts_roi = time_series(jj,:);

    variab = [];
    for j = 1:length(ts_roi)-1
        variab(j) = (ts_roi(j+1)-ts_roi(j))^2;
    end
    
    rmssd(jj) = sqrt(nanmean(variab));
    
end
