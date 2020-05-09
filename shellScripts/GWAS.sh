#!/bin/bash

 cd ~/PROJECTS/diversity_panel_2.0/


export GENO="DATA/GBS/DATASETS/BOL/BOL.hmp.txt"
export PHENO="OUTPUT/GWAS/pheno_gwas_normalized_ALL.txt"
export PCA="OUTPUT/DIVERSITY/PCA/PCA1.txt"
export KINSHIP="DATA/GBS/DATASETS/STATS/KINSHIP.txt"
export Q="~OUTPUT/GWAS/population_structure.txt"

# GLM naive 
  run_pipeline.pl -Xmx25g -fork1 -importGuess $GENO  -fork2 -importGuess $PHENO -combine3 -input1 -input2 -intersect -FixedEffectLMPlugin -endPlugin -export ~/PROJECTS/diversity_panel_2.0/OUTPUT/GWAS/CLI/GLM_LR

# GLM + PCA 
run_pipeline.pl -Xmx25g -fork1 -importGuess $GENO  -FilterSiteBuilderPlugin -siteMinAlleleFreq 0.05 -endPlugin -fork2 -importGuess $PHENO -fork3 -importGuess $PCA -combine5 -input1 -input2 -input3 -intersect -FixedEffectLMPlugin -endPlugin -export ~/PROJECTS/diversity_panel_2.0/OUTPUT/GWAS/CLI/GLM_PCA_LR


# MLM PCA + K 
run_pipeline.pl -Xmx25g -fork1 -h $GENO -filterAlign -filterAlignMinFreq 0.05 -fork2 -r $PHENO  -fork3 -importGuess $PCA -fork4 -k $KINSHIP -combine5 -input1 -input2 -input3 -input4 -intersect -combine6 -input5 -input4 -mlm -mlmVarCompEst P3D -mlmCompressionLevel Optimum -export ~/PROJECTS/diversity_panel_2.0/OUTPUT/GWAS/CLI/MLM_PCA_K -runfork1 -runfork2 -runfork3 -runfork4

# MLM Q + K 
run_pipeline.pl -Xmx25g -fork1 -h $GENO -filterAlign -filterAlignMinFreq 0.05 -fork2 -r $PHENO  -fork3 -q  $Q -excludeLastTrait -fork4 -k $KINSHIP -combine5 -input1 -input2 -input3 -input4 -intersect -combine6 -input5 -input4 -mlm -mlmVarCompEst P3D -mlmCompressionLevel Optimum -export ~/PROJECTS/diversity_panel_2.0/OUTPUT/GWAS/CLI/MLM_Q_K -runfork1 -runfork2 -runfork3 -runfork4 