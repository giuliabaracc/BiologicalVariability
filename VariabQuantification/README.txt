In this folder, you'll find scripts to derive local BOLD signal variability via rMSSD and global BOLD signal variability via covSTATIS. I also added the PLS analysis script I made to show how covSTATIS-derived area of the hull changes as a function of age + an example of atlas csv file.

Files and info:
- Local variability calculations to be found in:
  (1) "Get_localBOLDvariab.m"
- Global variability calculations to be found in:
  (1) "Get_windowed_correlation.m" & "masterscript_slidingwindow.m" --> these two scripts are for sliding window analyses
  (2) "Step2Part1_runcovSTATIS.R" --> this will run covSTATIS
  (3) "Step2Part2_getareahull_covSTATIS.R" --> this will take covSTATIS results and get the area of the hull scores
- Behavioral Partial Least Squares analysis to look at covSTATIS-age associations:
  (1) "Lifespan_PLS_Areahull_age.m"
- Example file of atlas used in R scripts to get regional labels:
  "Schaefer20017_orderlist.csv"
