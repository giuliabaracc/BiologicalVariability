%%%%%%%%%%%%%
Adapted by Giulia Baracchini
% Author
% RaphaÎl LiÈgeois - R.Liegeois@nus.edu.sg
% ©Copyright 2016
%%%%%%%%%%%%%

% time_series           2-D matrix of size (N,T) where N is the number of regions
%                       and T is the number of timepoints.

%% Set parameters and options
% Width of the window to be used
w = 20; % Units are TRs and classical values are between 20 and 40 TRs, I rounded the number of TRs per window

% Filtering: default is off
Leonardi_filtering = 'on'; % I set it to on

% Shape of window
shape = 'squared'; % You may also try with a tapered window, but the difference should not be very significative.

% Run sliding window 
[w_corr{j},var_mat{j},var_vec{j}] = get_windowed_correlation(time_series,w,Leonardi_filtering,shape);

