#!/bin/bash

cd ~/PROJECTS/diversity_panel_2.0/
### Settings
export MEM="-Xmx25g"

### Paths
mkdir DATA/GBS/DATASETS/BOL
mkdir DATA/GBS/DATASETS/BOL/PLINK
mkdir DATA/GBS/DATASETS/BOL/VCF

export PATH=~/PROGRAMS/plink:$PATH
export PATH=~/PROGRAMS/TASSEL5:$PATH

### Filtering data
export ALL="DATA/GBS/DATASETS/ALL.h5"
export TAXA="DATA/GBS/DATASETS/FILTERS/N109.txt"
### Paths
export BOL="DATA/GBS/DATASETS/BOL/"

# Main data
run_pipeline.pl $MEM -importGuess $ALL -includeTaxaInFile $TAXA  -FilterSiteBuilderPlugin -siteMinCount 98 -siteMinAlleleFreq 0.05 -maxHeterozygous 0.25 -removeSitesWithIndels true -removeMinorSNPStates true  -endPlugin  -export $BOL"BOL.hmp.txt" -exportType Hapmap

#### rename and save 31K data
mv $BOL"BOL1.hmp.txt"  $BOL"BOL.hmp.txt"
run_pipeline.pl $MEM -importGuess $BOL'BOL.hmp.txt' -export $BOL"VCF/BOL" -exportType VCF

### Thin sites for LD; export data to plink
run_pipeline.pl $MEM -importGuess $BOL"BOL.hmp.txt" -export $BOL"PLINK/BOL" -exportType Plink
# strip off leading "C" 
awk '{gsub(/^C/,""); print}'  $BOL"PLINK/BOL.plk.map" > $BOL"PLINK/BOL2.plk.map"
mv $BOL"PLINK/BOL2.plk.map" $BOL"PLINK/BOL.plk.map"

### Thin sites by R2 

plink --file $BOL"PLINK/BOL"  --update-ids $BOL"PLINK/family.txt" --out --out $BOL"PLINK/BOL" --allow-extra-chr

plink  --file $BOL"PLINK/BOL.plk" --indep-pairwise 50 'kb' 1 0.25 --out $BOL"PLINK/tmp1" --allow-extra-chr --make-founders

plink  --file $BOL"PLINK/BOL.plk" --extract $BOL"PLINK/tmp1.prune.in" --recode --out $BOL"PLINK/BOL" --allow-extra-chr 

plink -file $BOL"PLINK/BOL" --allow-extra-chr  --make-bed --out $BOL"PLINK/BOL"
rm  $BOL"PLINK/"*tmp1* $BOL"PLINK/"*plk* 

# assign subpopulation membership (family text is made in the cleaning_pheno script. )
plink --bfile $BOL"PLINK/BOL"  --update-ids $BOL"PLINK/family.txt" --make-bed --out $BOL"PLINK/BOL" --allow-extra-chr
plink --bfile $BOL"PLINK/BOL"  --recode --out $BOL"PLINK/BOL" 


### Make VCF file of 16K filtererd gentlemen
plink --bfile $BOL"PLINK/BOL" --recode vcf --out $BOL'VCF/BOL16K' --allow-extra-chr
sed -i 's/-9_//g' $BOL'VCF/BOL16K.vcf'
run_pipeline.pl $MEM -vcf $BOL'VCF/BOL16K.vcf' -export $BOL"BOL16K.hmp.txt" -exportType Hapmap

rm $BOL"VCF/"*.log  $BOL"VCF/"*.nosex  $BOL*json.gz