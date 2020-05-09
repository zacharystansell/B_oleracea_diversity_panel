#!/bin/bash

cd ~/PROJECTS/diversity_panel_2.0
export PATH=~/PROGRAMS/plink:$PATH
export BOL="DATA/GBS/DATASETS/BOL/VCF/BOL.vcf"
export  DM="OUTPUT/DIVERSITY/DM/DM"
export  PLK="OUTPUT/DIVERSITY/DM/DM.plk"
export  OUT="OUTPUT/DIVERSITY/DM/OUT.plk"

### export data to plink
run_pipeline.pl $MEM -vcf $BOL  -export $DM -exportType Plink

plink --distance 'square' 'ibs'  --file $PLK   --allow-extra-chr --allow-no-sex  --out $OUT
### Rename Samples for easier analysis
find OUTPUT/DIVERSITY/DM/OUT.plk.mibs.id -exec sed -f  DATA/rename_code.txt -i {} \;


echo "I am D.O.N.E"