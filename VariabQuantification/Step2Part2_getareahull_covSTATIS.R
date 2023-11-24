##### Created by Giulia Baracchini #####
## Create areas of the hull per ROI instead of per network
rm(list=ls())
library(psych)
library(DistatisR)
library(ExPosition)
library(PTCA4CATA)
library(factoextra)
library(Matrix)
library(sp)

## Load covSTATIS results from Step1 script
resCovstatis <- readRDS("./Results_covSTATIS_slidwindrsFC20017_150subs.rds")

##this is a csv file where you have ROI labels & color per ROI/network (you can find the file in the repo)
roi.names<- read.csv("Schaefer20017_orderlist.csv",header = TRUE, sep = ,)
demog.in <-read.csv("CornellYA_finalsample_n150_age.csv",header = TRUE, sep = ,) ##this is csv file with demographics info
ids <- demog.in$id
age <- demog.in$age

## Create empty matrix to put results in, should be # participants (rows) by # networks (columns)
roi_labels<- unique(roi.names$ROI_label)

temporal_diff <-data.frame(matrix(0, length(ids),200)) #200 cause 200 ROIs
rownames(temporal_diff) <- ids
names(temporal_diff) <- roi_labels

partialF <- resCovstatis$res4Splu$PartialF

for(i in 1:length(ids)){
  
  ### Grab all the partialF values associated with this subject for LV1
  this_lv1 <- partialF[,1,grep(paste0(ids[i], "_*"),dimnames(partialF)[[3]])]
  
  ### Grab all the partialF values associated with this P for LV2
  this_lv2 <- partialF[,2,grep(paste0(ids[i], "_*"),dimnames(partialF)[[3]])]
  
  this_lv1 <- t(this_lv1)
  this_lv2 <- t(this_lv2)

  ## PEELED HULL
  for(n in 1:length(roi_labels)){
    hull_pts <- peelZeHull(cbind(this_lv1[,n], this_lv2[,n]), percentage=0.95)
    this_poly_area <- Polygon(hull_pts, hole=F)@area
    temporal_diff[i,n] <- this_poly_area
  }
  
}

write.csv(temporal_diff, file = "PeeledHull_TempDiffROIScores_slidwindrsFC_150subs.csv") #change to whatever filename you want :)

### Get group estimate and rearrange to ROI order 1-200 cause now it's LH-RH-LH-RH etc
rm(list=ls())
data <- read.csv("PeeledHull_TempDiffROIScores_slidwindrsFC_150subs.csv", sep=,)
data <- data[,-1] #cause first col is seq of numbers
group_covstatis_ROI <- colMeans(data[sapply(data, is.numeric)])
group_covstatis_ROI <- as.data.frame(group_covstatis_ROI)
write.csv(group_covstatis_ROI, file="Group_PeeledHull_TempDiffROIScores_slidwindrsFC_150subs.csv")




