Here, you'll find code that I used to bridge across spatial scales.

####
Step 1: Fetch data from toolboxes and parcellate data to be 200 ROIs.
####
Microscale data:
  (1) Histological & microstructural data: 
      "Get_bbwVolumeMaps.sh" = fetch data
      "Parcellate_bbwSchaefer20017_1mm.sh" = parcellate data
Mesoscale data: 
  (1) Neurotransmitter receptor data:
      Fetched already parcellated from: https://github.com/netneurolab/hansen_receptors/tree/main/data/PET_parcellated/scale200
      "Get_recept_composite.R" = compute composite scores 
  (2) Transcriptomics parcellated: Abagen gene PC1 "gene_pc1.csv"
Macroscale data: 
  (1) PET metabolic data: parcellated in "Parcellate_PETmetabolic.py"
  (2) Temporal autocorrelation: "Get_TemporalAutocorrelation.m"
  (3) Static resting-state connectivity data: 
      "margulies2016_fcgradient01_Schaefer200_17Networks.csv"
      "sydnor2021_SAaxis_Schaefer200_17Networks.csv"

####
Step 2: Univariate correlations & spring embedding viz
####


####
Step 3: Cartographic analyses
####


####
Step 4: Dominance Analysis
####






