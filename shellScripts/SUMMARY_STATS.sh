#!/bin/bash
cd ~/PROJECTS/diversity_panel_2.0/
export MEM="-Xmx25g"
export BOL="DATA/GBS/DATASETS/BOL/"
export STATS="DATA/GBS/DATASETS/STATS/"
export TAXA="DATA/GBS/DATASETS/FILTERS/"
export POSITIONS="OUTPUT/GBS/UNIQUE/"
export ROD="OUTPUT/DIVERSITY/ROD/"

export WINSIZE="10"
export WINSTEP="5"

#All Stats
run_pipeline.pl -importGuess $BOL"BOL.hmp.txt" -GenotypeSummaryPlugin -endPlugin -export $STATS"BOL"

run_pipeline.pl -importGuess $BOL"BOL.hmp.txt" -KinshipPlugin -method Centered_IBS -endPlugin -export  $STATS"KINSHIP" -exportType SqrMatrix

### Make landrace comparison groups; F1 = Calabrese_F1, LR = Calabrese_LR and Sprouting_Broccoli
run_pipeline.pl $MEM  -fork1 -h $BOL"Calabrese_LR1.hmp.txt"  -fork2 -h $BOL"Sprouting_Broccoli1.hmp.txt" -fork3 -h $BOL"Violet_Caul1.hmp.txt" -combine4 -input1 -input2 -input3  -mergeGenotypeTables -export $BOL"BOL_LR.hmp.txt" -runfork1 -runfork2  

# Make diversity Stats of LR
run_pipeline.pl $MEM -h $BOL"BOL_LR.hmp.txt" -diversity  -diversitySlidingWinStep $WINSTEP -diversitySlidingWinSize $WINSIZE -export $ROD"LR.txt" -exportType Text 


#Subpopulation Info
for SUBPOP in  'Calabrese_F1' 'Calabrese_LR' 'Violet_Caul' 'Sprouting_Broccoli'

do

# Filter  Subpopulations
run_pipeline.pl $MEM -h $BOL"BOL.hmp.txt"  -includeTaxaInFile $TAXA$SUBPOP".txt" -export $BOL$SUBPOP -exportType Hapmap 

# Make VCF for subpops
run_pipeline.pl $MEM -h  $BOL$SUBPOP"1.hmp.txt" -export  $BOL"/VCF/"$SUBPOP -exportType VCF

# Export Diversity Stats on subpops
run_pipeline.pl $MEM -h $BOL"BOL.hmp.txt"  -includeTaxaInFile $TAXA$SUBPOP".txt"  -diversity  -diversitySlidingWinStep $WINSTEP -diversitySlidingWinSize $WINSIZE -export $ROD$SUBPOP"/INPUT/" -exportType Text

# Genotype Summaries for Subpops
run_pipeline.pl $MEM -h $BOL$SUBPOP"1.hmp.txt" -GenotypeSummaryPlugin -endPlugin -export $STATS$SUBPOP

# Filter Subpops for unique alleles 
run_pipeline.pl $MEM -h $BOL"BOL.hmp.txt"  -includeTaxaInFile $TAXA$SUBPOP".txt"  -FilterSiteBuilderPlugin -siteMinAlleleFreq 0.05 -removeSitesWithIndels true -removeMinorSNPStates true -endPlugin -GetPositionListPlugin -endPlugin -ExportPlugin -saveAs $POSITIONS$SUBPOP".txt" -format Table -endPlugin 

done
rm $BOL*json.gz