%%% Created by Giulia Baracchini %%%
clear all

%%% Read in covSTATIS results and demogs (age) for both samples
braindata_TO = readtable('PeeledHull_TempDiffROIScores_slidwindrsFC_TOlifespan_n154_20017.csv');
behavdata_TO = readtable('Final_N154_demogs.csv');
braindata_NKI = readtable('PeeledHull_TempDiffROIScores_slidwindrsFC_NKIlifespan_n154_20017.csv');
behavdata_NKI = readtable('NKI_age_N154.csv');

%%% Remove all first columns cause IDs
braindata_TO(:,1) = [];
behavdata_TO(:,1) = [];
braindata_NKI(:,1) = [];
behavdata_NKI(:,1) = [];
%%% Convert to array and get only age
braindata_TO = table2array(braindata_TO);
behavdata_TO = table2array(behavdata_TO(:,1));
braindata_NKI = table2array(braindata_NKI);
behavdata_NKI = table2array(behavdata_NKI);

%%% Coolio, now you can set up your Partial Least Squares analysis

%Data
subjs_group1 = 154; %tot n sample one
subjs_group2 = 154; %tot n sample two
%import data for our two samples
Group1_1Z = braindata_TO;
Group2_1Z = braindata_NKI;

% making input data for command line pls
datamat_list{1} = cat(1, Group1_1Z);
datamat_list{2} = cat(1, Group2_1Z);

%behavioural pls analysis
% import behavioral data
behav = vertcat(behavdata_TO, behavdata_NKI); %this is our two ages vectors that you are basically stacking, PS order of brain matches order of behav data
nsubj = 308; %cause its total number of subjs

%%%%% rotated PLS (no predefined contrast) %%%%%
num_subj_lst = [subjs_group1 subjs_group2];
num_cond = 1;
option.method = 3; %behavioral
option.num_perm = 1000; %permutations
option.num_boot = 1000; %bootstraps
option.stacked_behavdata = behav;
option.clim = 95; %confidence interval
addpath /usr/local/Pls/plscmd 
resultRotated_TONKI_Areahull_Age = pls_analysis(datamat_list, num_subj_lst, num_cond,option); &run PLS
save('resultRotated_TONKI154_Areahull_Age'); %save results

%For plotting: save your BSR
PLS_BSR_ROIs=resultRotated_TONKI_Areahull_Age.boot_result.compare_u(:,1); %1 cause you are looking at LV1
PLS_BSR_ROIs(abs(PLS_BSR_ROIs)<2)=0; %threshold BSR
save('BSR_ROIs_TONKI154_Areahull_Age.mat', 'PLS_BSR_ROIs')

%Get LV1 bootstrap: upper-lower confidence interval and orig_corr for plotting
upper_corr = resultRotated_TONKI_Areahull_Age.boot_result.ulcorr(:,1);
lower_corr = resultRotated_TONKI_Areahull_Age.boot_result.llcorr(:,1);
orig_corr = resultRotated_TONKI_Areahull_Age.boot_result.orig_corr(:,1);
tot_corr = horzcat(orig_corr, upper_corr, lower_corr);
save('Designscores_LV1_TONKI154_Areahull_Age.mat', 'tot_corr')

%%%Get %variance explained LV1
resultRotated_TONKI_Areahull_Age.s(1)^2/sum(resultRotated_TONKI_Areahull_Age.s.^2)%72

