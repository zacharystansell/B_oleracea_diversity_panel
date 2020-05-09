#!/bin/bash
cd ~/PROJECTS/diversity_panel_2.0/

### Paths
export VCF="DATA/GBS/DATASETS/BOL/VCF/"
export FILTER="DATA/GBS/DATASETS/FILTERS/"
export OUT="OUTPUT/DIVERSITY/FST/OUT/"
export WINSIZE="1000000"
export WINSTEP="1000"

SUBPOP=(Calabrese_F1 Calabrese_LR Violet_Caul Sprouting_Broccoli LR)

cat $FILTER"Calabrese_LR.txt" $FILTER"Sprouting_Broccoli.txt" $FILTER"Violet_Caul.txt" > $FILTER"LR.txt"

#Make Calabrese_F1 vs LR (Calabrese_LR + Sprouting_Broccoli)
vcftools --vcf $VCF"BOL.vcf" --fst-window-size $WINSIZE --fst-window-step  $WINSTEP --weir-fst-pop $FILTER${SUBPOP[0]}".txt" --weir-fst-pop $FILTER${SUBPOP[4]}".txt" --out $OUT${SUBPOP[0]}"x"${SUBPOP[4]}

#Make Fst comparisons between all SUBPOPS
for i in 1 2 3
do
vcftools --vcf $VCF"BOL.vcf" --fst-window-size $WINSIZE --fst-window-step  $WINSTEP --weir-fst-pop $FILTER${SUBPOP[0]}".txt" --weir-fst-pop $FILTER${SUBPOP[$i]}".txt" --out $OUT${SUBPOP[0]}"x"${SUBPOP[$i]}
done


for i in  2 3
do
vcftools --vcf $VCF"BOL.vcf" --fst-window-size $WINSIZE --fst-window-step $WINSTEP --weir-fst-pop $FILTER${SUBPOP[1]}".txt" --weir-fst-pop $FILTER${SUBPOP[$i]}".txt" --out $OUT${SUBPOP[1]}"x"${SUBPOP[$i]}
done

for i in 3
do
vcftools --vcf $VCF"BOL.vcf" --fst-window-size $WINSIZE --fst-window-step $WINSTEP --weir-fst-pop $FILTER${SUBPOP[2]}".txt" --weir-fst-pop $FILTER${SUBPOP[$i]}".txt" --out $OUT${SUBPOP[2]}"x"${SUBPOP[$i]}
done