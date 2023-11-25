#!/bin/sh
####  Created by Giulia Baracchini ####

### Now, there is a problem here cause the Parcellation and the cyto data despite both being in 1mm, they have different dimensions (if you do mri_info). So we need to resample the Parcellation to the data first, and then parcellate the data.
export AFNIDIR=/export01/local/afni

3dresample -inset Schaefer2018_200Parcels_17Networks_order_FSLMNI152_1mm.nii -master bigbrain2icbm152_1mm_merged_desc-Hist_G1.nii -prefix Parcellation_20017_1mm_resampled.nii

echo "Resampling done"

## Apply Schaefer onto each nii

export FSLDIR=/export01/local/fsl

fsl5.0-fslmeants -i bigbrain2icbm152_1mm_merged_desc-Hist_G1.nii -o Parcellated_bigbrain2icbm152_1mm_merged_desc-Hist_G1.csv --label=Parcellation_20017_1mm_resampled.nii
echo "Histg1 done"

fsl5.0-fslmeants -i bigbrain2icbm152_1mm_merged_desc-Hist_G2.nii -o Parcellated_bigbrain2icbm152_1mm_merged_desc-Hist_G2.csv --label=Parcellation_20017_1mm_resampled.nii
echo "Histg2 done"

fsl5.0-fslmeants -i bigbrain2icbm152_1mm_merged_desc-layer1.nii -o Parcellated_bigbrain2icbm152_1mm_merged_desc-layer1.csv --label=Parcellation_20017_1mm_resampled.nii
echo "layer1 done"

fsl5.0-fslmeants -i bigbrain2icbm152_1mm_merged_desc-layer2.nii -o Parcellated_bigbrain2icbm152_1mm_merged_desc-layer2.csv --label=Parcellation_20017_1mm_resampled.nii
echo "layer2 done"

fsl5.0-fslmeants -i bigbrain2icbm152_1mm_merged_desc-layer3.nii -o Parcellated_bigbrain2icbm152_1mm_merged_desc-layer3.csv --label=Parcellation_20017_1mm_resampled.nii
echo "layer3 done"

fsl5.0-fslmeants -i bigbrain2icbm152_1mm_merged_desc-layer4.nii -o Parcellated_bigbrain2icbm152_1mm_merged_desc-layer4.csv --label=Parcellation_20017_1mm_resampled.nii
echo "layer4 done"

fsl5.0-fslmeants -i bigbrain2icbm152_1mm_merged_desc-layer5.nii -o Parcellated_bigbrain2icbm152_1mm_merged_desc-layer5.csv --label=Parcellation_20017_1mm_resampled.nii
echo "layer5 done"

fsl5.0-fslmeants -i bigbrain2icbm152_1mm_merged_desc-layer6.nii -o Parcellated_bigbrain2icbm152_1mm_merged_desc-layer6.csv --label=Parcellation_20017_1mm_resampled.nii
echo "layer6 done"

fsl5.0-fslmeants -i bigbrain2icbm152_1mm_merged_desc-Micro_G1.nii -o Parcellated_bigbrain2icbm152_1mm_merged_desc-Micro_G1.csv --label=Parcellation_20017_1mm_resampled.nii
echo "Microg1 done"

fsl5.0-fslmeants -i bigbrain2icbm152_1mm_merged_desc-Micro_G2.nii -o Parcellated_bigbrain2icbm152_1mm_merged_desc-Micro_G2.csv --label=Parcellation_20017_1mm_resampled.nii
echo "Microg2 done"

echo "FINITOOOO"



