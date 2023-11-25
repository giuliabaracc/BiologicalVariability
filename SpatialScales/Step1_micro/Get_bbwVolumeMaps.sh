#!/bin/bash
#yg
### This script fetches data from BigBrainWarp

source /opt/minc/1.9.18/minc-toolkit-config.sh

export FREESURFER_HOME=/Applications/freesurfer/7.2.0
export FREESURFER_LICENSE=$FREESURFER_HOME/license.txt
source $FREESURFER_HOME/SetUpFreeSurfer.sh

cd /Applications/BigBrainWarp
chmod u+x ./scripts/init.sh
sh ./scripts/init.sh

cd /Applications/BigBrainWarp
mkdir bbwdata

sh bigbrainwarp --in_space bigbrain --out_space icbm --wd bbwdata --in_lh spaces/tpl-bigbrain/tpl-bigbrain_hemi-L_desc-Hist_G1.txt --in_rh spaces/tpl-bigbrain/tpl-bigbrain_hemi-R_desc-Hist_G1.txt --desc Hist_G1 --interp linear --out_res 1 --out_type volume

sh bigbrainwarp --in_space bigbrain --out_space icbm --wd bbwdata --in_lh spaces/tpl-bigbrain/tpl-bigbrain_hemi-L_desc-Hist_G2.txt --in_rh spaces/tpl-bigbrain/tpl-bigbrain_hemi-R_desc-Hist_G2.txt --desc Hist_G2 --interp linear --out_res 1 --out_type volume

sh bigbrainwarp --in_space bigbrain --out_space icbm --wd bbwdata --in_lh spaces/tpl-bigbrain/tpl-bigbrain_hemi-L_desc-Micro_G1.gii --in_rh spaces/tpl-bigbrain/tpl-bigbrain_hemi-R_desc-Micro_G1.gii --desc Micro_G1 --interp linear --out_res 1 --out_type volume

sh bigbrainwarp --in_space bigbrain --out_space icbm --wd bbwdata --in_lh spaces/tpl-bigbrain/tpl-bigbrain_hemi-L_desc-Micro_G2.gii --in_rh spaces/tpl-bigbrain/tpl-bigbrain_hemi-R_desc-Micro_G2.gii --desc Micro_G2 --interp linear --out_res 1 --out_type volume

for i in {1..6}
do
  sh bigbrainwarp --in_space bigbrain --out_space icbm --wd bbwdata --in_lh spaces/tpl-bigbrain/tpl-bigbrain_hemi-L_desc-layer${i}_thickness.txt --in_rh spaces/tpl-bigbrain/tpl-bigbrain_hemi-R_desc-layer${i}_thickness.txt --desc layer${i} --interp linear --out_res 1 --out_type volume
done

# renaming files
for file in *.nii; do mv "$file" "${file/tpl-icbm/bigbrain2icbm152}"; done

# merging left and right hemispheres

for i in {1..6}
do
  c3d bigbrain2icbm152_1mm_hemi-L_desc-layer${i}.nii bigbrain2icbm152_1mm_hemi-R_desc-layer${i}.nii -add -o bigbrain2icbm152_1mm_merged_desc-layer${i}.nii 
done

for i in 1 2
do
c3d bigbrain2icbm152_1mm_hemi-L_desc-Hist_G${i}.nii bigbrain2icbm152_1mm_hemi-R_desc-Hist_G${i}.nii -add -o bigbrain2icbm152_1mm_merged_desc-Hist_G${i}.nii
c3d bigbrain2icbm152_1mm_hemi-L_desc-Micro_G${i}.nii bigbrain2icbm152_1mm_hemi-R_desc-Micro_G${i}.nii -add -o bigbrain2icbm152_1mm_merged_desc-Micro_G${i}.nii
done

say 'finished'
