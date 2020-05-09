#!/bin/bash

cd ~/PROJECTS/diversity_panel_2.0
  export BOL="DATA/GBS/DATASETS/BOL/"
  export SWEED="OUTPUT/DIVERSITY/SWEED/"
  mkdir OUTPUT/DIVERSITY/SWEED/CHROM
  mkdir OUTPUT/DIVERSITY/SWEED/REPORT
  mkdir OUTPUT/DIVERSITY/SWEED/OUTPUT
  
### make VCF of individual chromosomes for Sweed
  
  for i in {1..9}
  do
  run_pipeline.pl  -importGuess $BOL"Calabrese_F11.hmp.txt" -FilterSiteBuilderPlugin -startChr "C"$i -endChr "C"$i -endPlugin  -export $SWEED"CHROM/C"$i -exportType VCF 

  run_pipeline.pl  -importGuess $BOL"Calabrese_F11.hmp.txt" -FilterSiteBuilderPlugin -startChr "C"$i -endChr "C"$i -endPlugin -GetPositionListPlugin  -endPlugin -export $SWEED"CHROM/C"$i"_position" -exportType Table 
  done

R 

# Set best appromiate grid size in bp
grid <- 1e3

library("dplyr")
library("data.table")
positions <-  list(
  C1 = read.delim("OUTPUT/DIVERSITY/SWEED/CHROM/C1_position.txt", sep ="\t"),
  C2 = read.delim("OUTPUT/DIVERSITY/SWEED/CHROM/C2_position.txt", sep ="\t"),
  C3 = read.delim("OUTPUT/DIVERSITY/SWEED/CHROM/C3_position.txt", sep ="\t"),
  C4 = read.delim("OUTPUT/DIVERSITY/SWEED/CHROM/C4_position.txt", sep ="\t"),
  C5 = read.delim("OUTPUT/DIVERSITY/SWEED/CHROM/C5_position.txt", sep ="\t"),
  C6 = read.delim("OUTPUT/DIVERSITY/SWEED/CHROM/C6_position.txt", sep ="\t"),
  C7 = read.delim("OUTPUT/DIVERSITY/SWEED/CHROM/C7_position.txt", sep ="\t"),
  C8 = read.delim("OUTPUT/DIVERSITY/SWEED/CHROM/C8_position.txt", sep ="\t"),
  C9 = read.delim("OUTPUT/DIVERSITY/SWEED/CHROM/C9_position.txt", sep ="\t")) %>%
  rbindlist(idcol = TRUE) %>% 
  rename(CHR = .id) 
  
chrLen <- tapply(positions$Position, positions$Chromosome, max) - tapply(positions$Position, positions$Chromosome, min)
chrLen <- ceiling(chrLen/grid)
#add a zero to fix the counting problem
chrLen <- c(0, chrLen)
write.csv(chrLen,"OUTPUT/DIVERSITY/SWEED/CHROM/chrLen.csv", row.names=FALSE)
quit()
n

cat $SWEED"CHROM/chrLen.csv" | tail -10 > $SWEED"CHROM/chrLen0.csv"

readarray -t array < $SWEED"CHROM/chrLen0.csv"

cd $SWEED"REPORT/"  

for i in {0..9}
do
~/PROGRAMS/sweed/SweeD -name "sweed_C"$i -input "../CHROM/C"$i"1.vcf" -grid  "${array[$i]}" 
done


cd ~/PROJECTS/diversity_panel_2.0  
rm $SWEED"CHROM/"*"json"* $SWEED"CHROM/"*"position"* $SWEED"CHROM/"*"chr"*
  