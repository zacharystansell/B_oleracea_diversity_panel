#!/bin/bash

cd ~/PROJECTS/diversity_panel_2.0/
export MEM="-Xmx25g"
export BOL="DATA/GBS/DATASETS/BOL/"
export TAXA="DATA/GBS/DATASETS/FILTERS/"
export LD="OUTPUT/GBS/LD/"
export BPWIN=1000000
  
vcftools --vcf $BOL"VCF/BOL.vcf" --geno-r2 --ld-window-bp $BPWIN --min-r2 0.0 --out $LD"ALL"
  
for SUBPOP in  'Calabrese_F1' 'Calabrese_LR' 'Violet_Caul' 'Sprouting_Broccoli'
  
  do
  vcftools --vcf $BOL"VCF/"$SUBPOP".vcf" --geno-r2 --ld-window-bp $BPWIN --min-r2 0.0 --out $LD$SUBPOP
  done
  
rm  $LD*.log

