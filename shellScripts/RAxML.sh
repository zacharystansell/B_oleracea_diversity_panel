#!/bin/bash

cd ~/PROJECTS/diversity_panel_2.0/
export RAxML="DATA/GBS/DATASETS/BOL/BOL31K"
export TREE="OUTPUT/DIVERSITY/RAxML/bestTree.txt"


# Make into phylip
~/PROGRAMS/vcf2phylip/vcf2phylip.py -i $RAxML'.vcf'
mv $RAxML.min4.phy OUTPUT/DIVERSITY/RAxML/BOL.phy
#download tree
find $TREE -exec sed -f  DATA/rename_code.txt -i {} \;
