####### Created by Giulia Baracchini #######
## Calculate subject-level inter-sample stability/reliability of local/global BOLD variability per ROI
# I am uploading just the local BOLD variability script, but this was adapted to run on global BOLD variability too
rm(list=ls())
library(tidyr)
library(dplyr)
library(matrixStats)
library(ggplot2)
library(R.matlab)

################ 
#Import your variability sample 1 data
################ 
variability_sample1 <- readMat("./MyVariabData_Sample1.mat")
variability_sample1 <- variability_sample1$rearranged.subj.meancentrmssd
variability_sample1 <- as.data.frame(variability_sample1)

## Next, I rearranged the ROIs to be in standard 1-200 order (i.e., all L and then all R, instead of L-R-L-R) 
atlas <- read.csv("./Schaefer20017_orderlist.csv")
roi_number <- atlas[,1]
colnames(variability_sample1) <- roi_number
reordering_cols <- as.numeric(names(variability_sample1))
#ok now reorder ROIs
variability_sample1 <- variability_sample1[,c(order(reordering_cols))]

## Scale each subject (row) independently & make data in long format
variability_sample1_scaled <- apply(variability_sample1, 1, scale)
variability_sample1_scaled <- t(variability_sample1_scaled)
variability_sample1_scaled <- as.data.frame(variability_sample1_scaled)

variability_sample1_scaled_long <- gather(variability_sample1_scaled, ROI, variability, V1:V200, factor_key=TRUE)
variability_sample1_scaled_long$ROI <- factor(variability_sample1_scaled_long$ROI, levels=unique(variability_sample1_scaled_long$ROI))

################ 
#Import your variability sample 2 data
################ 
variability_sample2 <- readMat("./MyVariabData_Sample2.mat")
variability_sample2 <- variability_sample2$rearranged.subj.meancentrmssd
variability_sample2 <- as.data.frame(variability_sample2)

## Again reordering ROIs first
colnames(variability_sample2) <- roi_number
reordering_cols <- as.numeric(names(variability_sample2))
##ok now reorder ROIs
variability_sample2 <- variability_sample2[,c(order(reordering_cols))]

## Scale each subject (row) independently & making data long format
variability_sample2_scaled <- apply(variability_sample2, 1, scale)
variability_sample2_scaled <- t(variability_sample2_scaled)
variability_sample2_scaled <- as.data.frame(variability_sample2_scaled)

variability_sample2_scaled_long <- gather(variability_sample2_scaled, ROI, variability, V1:V200, factor_key=TRUE)
variability_sample2_scaled_long$ROI <- factor(variability_sample2_scaled_long$ROI, levels=unique(variability_sample2_scaled_long$ROI))

################ 
#Statistical tests
################ 
## Ok now add site and rbind the two dataframes
variability_sample1_scaled_long$site <- rep("0",30000)
variability_sample2_scaled_long$site <- rep("1",22400)

data <- rbind(variability_sample1_scaled_long, variability_sample2_scaled_long)

test_ROI <- rep(0,200) #200 cause that is how many ROIs we have

for (i in 1:200) {
  
  roi_df <- rep("NA",262) #262 is the two sample sizes added to one another, 150+112
  roi_df <- data[data$ROI==paste0("V",i),]

  test_ROI[i] <- t.test(variability ~ site, data=roi_df, var.equal=FALSE)$p.value
  
}

which(test_ROI > 0.05)
##we dont want to correct these p values cause that is going to inflate what I want to observe aka what is not significant

write.csv(test_ROI, "Pvalues_SubjlevelROI_IntersiteReliab_rMSSD.csv")

################ 
#Plot p values on brain
################ 
##### Clean up workspace
rm(list=ls())
library(ggplot2)
library("ggseg")
library(ggsegSchaefer)
library(dplyr)

data <- read.csv("Pvalues_SubjlevelROI_IntersiteReliab_rMSSD.csv")
colnames(data)[1] <- "region"

## Plot only regions that are not significant aka showing no site effect, so set to zero the significant ones
data$pvalues[data$pvalues < 0.05] <- 0

data <- data[data$pvalues != 0, ]
data$reg_col <- data$region
color <- c("#4680B3","#4680B3","#C43AFB","#C43AFB", "#DCF8A3","#E69421","#4680B3","#4680B3","#4680B3",
           "#007607","#007607","#007607","#C43AFB", "#DCF8A3","#E69421","#E69421","#CD3E48","#CD3E48")
data$region <- factor(data$region, levels=unique(data$region))
data$reg_col <- factor(data$reg_col, levels=unique(data$reg_col))

svg("Pvalues_SubjlevelROI_IntersiteReliab_rMSSD.svg",width = 7, height = 7)
ggplot(data) +
  geom_brain(atlas = schaefer17_200,
             position = position_brain(hemi ~ side),
             mapping = aes(fill=reg_col, geometry=geometry)) +
  scale_fill_brain2(color, na.value = "white") + guides(fill="none") + 
  theme_bw() +
  theme(axis.text = element_blank()) + theme(axis.ticks = element_blank()) 
dev.off()
