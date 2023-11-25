%%%%%% Created by Giulia Baracchini %%%%%%
%% Script to calculate temporal autocorrelation timeseries
clear all

load("TSDataSample1.mat"); %timeseries data sample 1
data = finalhikts;
clear finalhikts

for j=1:150 %looping through subject to get TA on everyone
    
    subj_timeseries = data{1,j};
    
    for i=1:200 %looping through regions to get TA on every ROI
        [acf, lags] = autocorr(subj_timeseries(i,:)); %acf gives you the AC value in order of lags
        subj_ta{i} = acf(2); %for lag2 I did 3, for lag1 I did 2 (as shown here)
    
    ta{j} = subj_ta; %%%%ps parcels are not rearranged
    
end

save("TemporalautocorrLAG1_perROI_Sample1.mat","ta")
