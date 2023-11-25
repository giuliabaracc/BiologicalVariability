####### Created by Giulia Baracchini #######
## Calculate subject-level inter-sample stability/reliability of local/global BOLD variability per network
# I am uploading just the local BOLD variability script, but this was adapted to run on global BOLD variability too
rm(list=ls())
library(tidyr)
library(dplyr)
library(matrixStats)
library(ggplot2)
library(R.matlab)
library(emmeans)
library(ggpubr)

################ 
#Import your variability sample 1 data
################ 
variability_sample1 <- readMat("./MyVariabData_Sample1.mat")
variability_sample1 <- variability_sample1$rearranged.subj.meancentrmssd
variability_sample1 <- as.data.frame(variability_sample1)

## Scale each subject (row) independently
variability_sample1_scaled <- apply(variability_sample1, 1, scale)
variability_sample1_scaled <- t(variability_sample1_scaled)
variability_sample1_scaled <- as.data.frame(variability_sample1_scaled)

## Now split whole brain into the 7 networks & long format (data are already organized by network)
variability_sample1_scaled_vis <- variability_sample1_scaled[,1:24]
variability_sample1_scaled_vis <- gather(variability_sample1_scaled_vis, ROI, variability, V1:V24, factor_key=TRUE)
variability_sample1_scaled_vis$ROI <- factor(variability_sample1_scaled_vis$ROI, levels=unique(variability_sample1_scaled_vis$ROI))

variability_sample1_scaled_som <- variability_sample1_scaled[,25:58]
variability_sample1_scaled_som <- gather(variability_sample1_scaled_som, ROI, variability, V25:V58, factor_key=TRUE)
variability_sample1_scaled_som$ROI <- factor(variability_sample1_scaled_som$ROI, levels=unique(variability_sample1_scaled_som$ROI))

variability_sample1_scaled_dan <- variability_sample1_scaled[,59:80]
variability_sample1_scaled_dan <- gather(variability_sample1_scaled_dan, ROI, variability, V59:V80, factor_key=TRUE)
variability_sample1_scaled_dan$ROI <- factor(variability_sample1_scaled_dan$ROI, levels=unique(variability_sample1_scaled_dan$ROI))

variability_sample1_scaled_van <- variability_sample1_scaled[,81:106]
variability_sample1_scaled_van <- gather(variability_sample1_scaled_van, ROI, variability, V81:V106, factor_key=TRUE)
variability_sample1_scaled_van$ROI <- factor(variability_sample1_scaled_van$ROI, levels=unique(variability_sample1_scaled_van$ROI))

variability_sample1_scaled_lim <- variability_sample1_scaled[,107:120]
variability_sample1_scaled_lim <- gather(variability_sample1_scaled_lim, ROI, variability, V107:V120, factor_key=TRUE)
variability_sample1_scaled_lim$ROI <- factor(variability_sample1_scaled_lim$ROI, levels=unique(variability_sample1_scaled_lim$ROI))

variability_sample1_scaled_cont <- variability_sample1_scaled[,121:157]
variability_sample1_scaled_cont <- gather(variability_sample1_scaled_cont, ROI, variability, V121:V157, factor_key=TRUE)
variability_sample1_scaled_cont$ROI <- factor(variability_sample1_scaled_cont$ROI, levels=unique(variability_sample1_scaled_cont$ROI))

variability_sample1_scaled_def <- variability_sample1_scaled[,158:200]
variability_sample1_scaled_def <- gather(variability_sample1_scaled_def, ROI, variability, V158:V200, factor_key=TRUE)
variability_sample1_scaled_def$ROI <- factor(variability_sample1_scaled_def$ROI, levels=unique(variability_sample1_scaled_def$ROI))

################ 
#Import your variability sample 2 data
################ 
variability_sample2 <- readMat("./MyVariabData_Sample2.mat")
variability_sample2 <- variability_sample2$rearranged.subj.meancentrmssd
variability_sample2 <- as.data.frame(variability_sample2)

## Scale each subject (row) independently
variability_sample2_scaled <- apply(variability_sample2, 1, scale)
variability_sample2_scaled <- t(variability_sample2_scaled)
variability_sample2_scaled <- as.data.frame(variability_sample2_scaled)

## Now split whole brain into the 7 networks & long format (data are already organized by network)
variability_sample2_scaled_vis <- variability_sample2_scaled[,1:24]
variability_sample2_scaled_vis <- gather(variability_sample2_scaled_vis, ROI, variability, V1:V24, factor_key=TRUE)
variability_sample2_scaled_vis$ROI <- factor(variability_sample2_scaled_vis$ROI, levels=unique(variability_sample2_scaled_vis$ROI))

variability_sample2_scaled_som <- variability_sample2_scaled[,25:58]
variability_sample2_scaled_som <- gather(variability_sample2_scaled_som, ROI, variability, V25:V58, factor_key=TRUE)
variability_sample2_scaled_som$ROI <- factor(variability_sample2_scaled_som$ROI, levels=unique(variability_sample2_scaled_som$ROI))

variability_sample2_scaled_dan <- variability_sample2_scaled[,59:80]
variability_sample2_scaled_dan <- gather(variability_sample2_scaled_dan, ROI, variability, V59:V80, factor_key=TRUE)
variability_sample2_scaled_dan$ROI <- factor(variability_sample2_scaled_dan$ROI, levels=unique(variability_sample2_scaled_dan$ROI))

variability_sample2_scaled_van <- variability_sample2_scaled[,81:106]
variability_sample2_scaled_van <- gather(variability_sample2_scaled_van, ROI, variability, V81:V106, factor_key=TRUE)
variability_sample2_scaled_van$ROI <- factor(variability_sample2_scaled_van$ROI, levels=unique(variability_sample2_scaled_van$ROI))

variability_sample2_scaled_lim <- variability_sample2_scaled[,107:120]
variability_sample2_scaled_lim <- gather(variability_sample2_scaled_lim, ROI, variability, V107:V120, factor_key=TRUE)
variability_sample2_scaled_lim$ROI <- factor(variability_sample2_scaled_lim$ROI, levels=unique(variability_sample2_scaled_lim$ROI))

variability_sample2_scaled_cont <- variability_sample2_scaled[,121:157]
variability_sample2_scaled_cont <- gather(variability_sample2_scaled_cont, ROI, variability, V121:V157, factor_key=TRUE)
variability_sample2_scaled_cont$ROI <- factor(variability_sample2_scaled_cont$ROI, levels=unique(variability_sample2_scaled_cont$ROI))

variability_sample2_scaled_def <- variability_sample2_scaled[,158:200]
variability_sample2_scaled_def <- gather(variability_sample2_scaled_def, ROI, variability, V158:V200, factor_key=TRUE)
variability_sample2_scaled_def$ROI <- factor(variability_sample2_scaled_def$ROI, levels=unique(variability_sample2_scaled_def$ROI))

################ 
#Statistical tests
################ 
## Ok now add site and rbind the two dataframes per network
sample1_ids <- read.csv("./IDs_Sample1.csv")
sample1_ids <- sample1_ids[,1]

sample2_ids <- read.csv("./IDs_Sample2.csv")
sample2_ids <- sample2_ids[,1]

variability_sample1_scaled_vis$site <- rep("0",3600)
variability_sample1_scaled_vis$SubjID <- rep(sample1_ids,24)
variability_sample1_scaled_vis$Network <- rep("Visual",3600)
variability_sample2_scaled_vis$site <- rep("1",2688)
variability_sample2_scaled_vis$SubjID <- rep(sample2_ids,24)
variability_sample2_scaled_vis$Network <- rep("Visual",2688)
data_vis <- rbind(variability_sample1_scaled_vis, variability_sample2_scaled_vis)
test_vis <- t.test(variability ~ site, data=data_vis, var.equal=FALSE)
print(test_vis)

variability_sample1_scaled_som$site <- rep("0",5100)
variability_sample1_scaled_som$SubjID <- rep(sample1_ids,34)
variability_sample1_scaled_som$Network <- rep("SomMot",5100)
variability_sample2_scaled_som$site <- rep("1",3808)
variability_sample2_scaled_som$SubjID <- rep(sample2_ids,34)
variability_sample2_scaled_som$Network <- rep("SomMot",3808)
data_som <- rbind(variability_sample1_scaled_som, variability_sample2_scaled_som)
test_som <- t.test(variability ~ site, data=data_som, var.equal=FALSE)
print(test_som)

variability_sample1_scaled_dan$site <- rep("0",3300)
variability_sample1_scaled_dan$SubjID <- rep(sample1_ids,22)
variability_sample1_scaled_dan$Network <- rep("DorsAttn",3300)
variability_sample2_scaled_dan$site <- rep("1",2464)
variability_sample2_scaled_dan$SubjID <- rep(sample2_ids,22)
variability_sample2_scaled_dan$Network <- rep("DorsAttn",2464)
data_dan <- rbind(variability_sample1_scaled_dan, variability_sample2_scaled_dan)
test_dan <- t.test(variability ~ site, data=data_dan, var.equal=FALSE)
print(test_dan)

variability_sample1_scaled_van$site <- rep("0",3900)
variability_sample1_scaled_van$SubjID <- rep(sample1_ids,26)
variability_sample1_scaled_van$Network <- rep("SalVentAttn",3900)
variability_sample2_scaled_van$site <- rep("1",2912)
variability_sample2_scaled_van$SubjID <- rep(sample2_ids,26)
variability_sample2_scaled_van$Network <- rep("SalVentAttn",2912)
data_van <- rbind(variability_sample1_scaled_van, variability_sample2_scaled_van)
test_van <- t.test(variability ~ site, data=data_van, var.equal=FALSE)
print(test_van)

variability_sample1_scaled_lim$site <- rep("0",2100)
variability_sample1_scaled_lim$SubjID <- rep(sample1_ids,14)
variability_sample1_scaled_lim$Network <- rep("Limbic",2100)
variability_sample2_scaled_lim$site <- rep("1",1568)
variability_sample2_scaled_lim$SubjID <- rep(sample2_ids,14)
variability_sample2_scaled_lim$Network <- rep("Limbic",1568)
data_lim <- rbind(variability_sample1_scaled_lim, variability_sample2_scaled_lim)
test_lim <- t.test(variability ~ site, data=data_lim, var.equal=FALSE)
print(test_lim)

variability_sample1_scaled_cont$site <- rep("0",5550)
variability_sample1_scaled_cont$SubjID <- rep(sample1_ids,37)
variability_sample1_scaled_cont$Network <- rep("Control",5550)
variability_sample2_scaled_cont$site <- rep("1",4144)
variability_sample2_scaled_cont$SubjID <- rep(sample2_ids,37)
variability_sample2_scaled_cont$Network <- rep("Control",4144)
data_cont <- rbind(variability_sample1_scaled_cont, variability_sample2_scaled_cont)
test_cont <- t.test(variability ~ site, data=data_cont, var.equal=FALSE)
print(test_cont)

variability_sample1_scaled_def$site <- rep("0",6450)
variability_sample1_scaled_def$SubjID <- rep(sample1_ids,43)
variability_sample1_scaled_def$Network <- rep("Default",6450)
variability_sample2_scaled_def$site <- rep("1",4816)
variability_sample2_scaled_def$SubjID <- rep(sample2_ids,43)
variability_sample2_scaled_def$Network <- rep("Default",4816)
data_def <- rbind(variability_sample1_scaled_def, variability_sample2_scaled_def)
test_def <- t.test(variability ~ site, data=data_def, var.equal=FALSE)
print(test_def)

pvalues_net <- cbind(test_vis$p.value, test_som$p.value, test_dan$p.value, test_van$p.value,
                     test_lim$p.value, test_cont$p.value, test_def$p.value)

##adjusting or not gives the same results
adj_test_net <- p.adjust(pvalues_net, method = "bonferroni", n = length(pvalues_net))
which(adj_test_net > 0.05)

adj_test_net <- t(adj_test_net)
colnames(adj_test_net) <- c("Visual", "Somato-Motor", "Dorsal Attention", "Ventral Attention", "Limbic", "Control", "Default")
  
adj_test_net %>%
  ggradar(grid.label.size = 6,  # Affects the grid annotations (0%, 50%, etc.)
          values.radar = c(".001", "", "1"),
          axis.label.size = 5, # Affects the names of the variables
          group.point.size = 3, group.colours = "black")  

################ 
#Plotting
################ 
### Create dataframe with pvalues, differences in mean and CIs t-test
# Import ggplot2 library
ttest <- c(42.976,-27.591, 0.94262, -11.163, 9.5072,-9.4684, 0.15246)
diffmeans <- c(1.08,-0.49,0.02,-0.20,0.15,-0.18,0.003)
lower_ci <- c(1.027364,-0.5229055,-0.02386261,-0.2327334,0.1181046,-0.2207786,-0.03027547)
upper_ci <- c(1.125570,-0.4535309,0.06806195,-0.1632032,0.1794787,-0.1450424,0.03538204)
pvalues <- c("p<0.001", "p<0.001", "p>0.05", "p<0.001", "p<0.001", "p<0.001", "p>0.05")
networks <- c("Visual", "Somato-Motor", "Dorsal Attention", "Ventral Attention", "Limbic", "Control", "Default")

data_plot <- rbind(ttest, diffmeans, lower_ci, upper_ci, pvalues, networks)
data_plot <- t(data_plot)
data_plot <- as.data.frame(data_plot)
data_plot$pvalues <- as.factor(data_plot$pvalues)
data_plot$ttest <- as.numeric(as.character(data_plot$ttest))
data_plot$diffmeans <- as.numeric(as.character(data_plot$diffmeans))
data_plot$lower_ci <- as.numeric(as.character(data_plot$lower_ci))
data_plot$upper_ci <- as.numeric(as.character(data_plot$upper_ci))
data_plot$networks <- factor(data_plot$networks, levels=unique(data_plot$networks))
data_plot$colors <- c("#781180", "#4680B3", "#007607", "#C43AFB", "#DCF8A3", "#E69421", "#CD3E48")

svg("IndepTtest_SubjlevelNetw_IntersiteReliab_rMSSD.svg",width = 10, height = 10)
ggplot(data_plot, aes(x=diffmeans, y=networks, fill=networks)) + geom_point(shape = 21, fill = data_plot$color, color = 'black', size = 4) + 
  geom_errorbar(aes(xmin = lower_ci, xmax = upper_ci), size=0.3) + xlim(-1.2,1.2) + geom_vline(xintercept = 0.0, linetype="dashed", 
                                                                                     color = "black", size=0.5) +
  annotate("text", x = -0.25, y = "Control", label = "*", size=9) +
  annotate("text", x = -0.55, y = "Somato-Motor", label = "*", size=9) +
  annotate("text", x = -0.27, y = "Ventral Attention", label = "*", size=9) +
  annotate("text", x = 0.23, y = "Limbic", label = "*", size=9) +
  annotate("text", x = 1.17, y = "Visual", label = "*", size=9) +
  theme_bw()
dev.off()


