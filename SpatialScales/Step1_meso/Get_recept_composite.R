##### Created by Giulia Baracchini #####
## Get composite score measures on neurotransmitter receptor maps 
rm(list=ls())
library("R.matlab")

receptors <- readMat("./../../PLS_dynamics_neuromaps_TA_ROIlevel/ForPLS_Neuromaps_Receptors.mat")
receptors <- receptors$receptors
receptors <- as.data.frame(receptors)
a4b2 <- receptors$V1
m1 <- receptors$V2
d1 <- receptors$V4
d2 <- receptors$V5
gabaa <- receptors$V8
gababz <- receptors$V9
mglur5 <- receptors$V10
nmda <- receptors$V11
cinqht1a <- receptors$V12
cinqht1b <- receptors$V13
cinqht2a <- receptors$V14
cinqht4 <- receptors$V15
cinqht6 <- receptors$V16

receptors <- cbind(a4b2,m1,d1,d2,gabaa,gababz,mglur5,nmda,cinqht1a,cinqht1b,cinqht2a,cinqht4,cinqht6)
final <- as.data.frame(receptors)
colnames(final)[1] <- "a4b2"
colnames(final)[2] <- "m1"
colnames(final)[3] <- "d1"
colnames(final)[4] <- "d2"
colnames(final)[5] <- "gaba"
colnames(final)[6] <- "gababz"
colnames(final)[7] <- "mglur5"
colnames(final)[8] <- "nmda"
colnames(final)[9] <- "cinqht1a"
colnames(final)[10] <- "cinqht1b"
colnames(final)[11] <- "cinqht2a"
colnames(final)[12] <- "cinqht4"
colnames(final)[13] <- "cinqht6"

#### Now estimate Shannon Entropy, but first normalize each entry by max receptor
## Get max of each column
max_col = rep(NA,13)
for (i in 1:13) {
  max_col[i] = max(final[,i])
}

## Now normalization
## Normalization 1: dividing each entry by max col --> normalizing per receptor type
normalized_col <- data.frame(matrix(ncol = 13, nrow = 200))
for (z in 1:13) {
  for (j in 1:200) {
    normalized_col[j,z] = final[j,z]/max_col[z]
  }
}

## Ok now calculate entropy but in there also
## normalization 2: dividing each entry by row mean --> normalizing per region across receptors
entropy <- rep(NA,200)

for (j in 1:200) {
  entropy[j] <- -sum((normalized_col[j,]/sum(normalized_col[j,]))*log((normalized_col[j,]/sum(normalized_col[j,]))))/log(length(colnames(final)))
}

write.csv(entropy,"NormShannonEntropy_perROI.csv")

####### Excitation/Inhibition ratio
### "E", "E", "E", "I", "I", "I", "E", "E", "I", "I", "E", "E", "E"
excitation <- final[,c(1,2,3,7,8,11,12,13)]
inhibition <- final[,c(4,5,6,9,10)]

ratio <- rep(NA,200)
for (g in 1:200){
  ratio[g] <- rowMeans(excitation[g,])/rowMeans(inhibition[g,])
}

write.csv(ratio,"ExcitInhibRatio_perROI.csv")

####### Ionotropic vs metabotropic
### "I", "M", "M", "M", "I", "I", "M", "I", "M", "M", "M", "M", "M", "M" 
ionotropic <- final[,c(1,5,6,8)]
metabotropic <- final[,c(2,3,4,7,9,10,11,12,13)]

ionotropic_density <- rep(NA,200)
for (gg in 1:200){
  ionotropic_density[gg] <- rowMeans(ionotropic[gg,])
}

metabotropic_density <- rep(NA,200)
for (gg in 1:200){
  metabotropic_density[gg] <- rowMeans(metabotropic[gg,])
}

write.csv(ionotropic_density,"Ionodensity_perROI.csv")
write.csv(metabotropic_density,"Metabdensity_perROI.csv")



