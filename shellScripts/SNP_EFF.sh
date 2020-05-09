#!/bin/bash

cd ~/PROJECTS/diversity_panel_2.0/
export BOL="DATA/GBS/DATASETS/BOL/"
export SNP="OUTPUT/GBS/snpEFF/"

java  -Xmx20g -jar /home/zachary/PROGRAMS/snpeff/snpEff/snpEff.jar  Brassica_oleracea  $BOL"VCF/BOL.vcf" > $SNP"BOL.ann.vcf" -stats $SNP"stats.html" 
