########### Created by Giulia Baracchini ###########
### Run covSTATIS to assess temporal stability in this script of rsFC across windows ###
rm(list=ls())

#Libraries we need to load
#install.packages("R.matlab")
library(R.matlab)
#install.packages("psych")
library(psych)
#install.packages("remotes")
#remotes::install_github("HerveAbdi/DistatisR")
library(DistatisR)
#install.packages("ExPosition")
library(ExPosition)
#install.packages("devtools")
#devtools::install_github("HerveAbdi/PTCA4CATA", dependencies = TRUE) 
library(PTCA4CATA)
#install.packages("factoextra")
library(factoextra)
#install.packages("Matrix")
library(Matrix)
#install.packages("sp")
library(sp)

#########################################
### 1. Read in the data
#########################################
setwd("") #set your working directory

fns <- list.files("Path/to/files", pattern="*slidwindrsFC.mat") #load all your sliding window correlation matrices obtained in step 1, eg here searching in a folder, files with that pattern

roi.names<- read.csv("Schaefer20017_orderlist.csv",header = TRUE, sep = ,) #read in your ROI atlas
demog.in <-read.csv("SubsIDs.csv",header = TRUE, sep = ,) #read in spredsheet with subject IDs
ids <- demog.in$id

### Generate clean participant*window labels from the file names
windows <- 1:N #substitute N with total number of windows
size_thirdim <- length(fns)*length(windows)
label_thirdim <- rep(NA, size_thirdim)
c=1 #initiate counter to fill label_thirdim otherwise it will overwrite and only spit out last cell

for (i in ids){
  for (j in windows){
    label_thirdim[c] <- paste0(i, "_window", j)
    c=c+1 #add one and move on
  }
}

### Create an empty 3D array that is N rois x N rois x (Participants*Windows) 
all.cor.mats <- array(NA,dim=c(nrow(roi.names),nrow(roi.names),size_thirdim))
rownames(all.cor.mats) <- colnames(all.cor.mats) <- roi.names$ROI_label
dimnames(all.cor.mats)[[3]] <- label_thirdim

### Fill in the empty the CUBE by looping through each file/connectivity matrix and adding it as a slice in the cube.
counter=1

for(f in 1:length(fns)){
  this.mat<-readMat(paste0('Same/path/to/files/as/above',fns[f]))
  this.mat<-this.mat$subdata
  for (z in windows){
    all.cor.mats[,,counter] <- this.mat[,,z]
    counter=counter+1
  }
}

### Save cube just in case
saveRDS(all.cor.mats, "Cube_pre-covSTATIS.rds")

### clear cache before moving to next step
gc()

#########################################
### 2. Run covSTATIS
#########################################
### No need to transform from Fisher Z to correlation cause they are already corr values + no need to set diag to 1 
### cause its already 1, no need to set matrices to distance cause turning distance to FALSE
resCovstatis<- distatis(all.cor.mats, Distance = F,nfact2keep = 5,compact = F)

###Save resCovstatis results so we can do everything else in a separate script
saveRDS(resCovstatis, "InsertName.rds")

