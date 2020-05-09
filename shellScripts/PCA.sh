#!/bin/bash

cd ~/PROJECTS/diversity_panel_2.0/
#Use non-ld pruned data
export BOL="DATA/GBS/DATASETS/BOL/BOL.hmp.txt"
export MDS="OUTPUT/DIVERSITY/PCA/MDS"
export PCA="OUTPUT/DIVERSITY/PCA/PCA"

run_pipeline.pl -importGuess $BOL -DistanceMatrixPlugin -endPlugin -MultiDimensionalScalingPlugin -axes 3 -endPlugin -export $MDS
run_pipeline.pl -importGuess $BOL -PrincipalComponentsPlugin -covariance true -ncomponents 5 -endPlugin  -export $PCA 

### Rename Samples for easier analysis
#find $MDS'1.txt' -exec sed -f  DATA/rename_code.txt -i {} \;