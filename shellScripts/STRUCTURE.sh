#!/bin/bash

cd ~/PROJECTS/diversity_panel_2.0/
export PLINK="DATA/GBS/DATASETS/BOL/PLINK/BOL"
### run fastSTRUCTURE
  for i in {2..20}
  do
  python2 ~/PROGRAMS/fastStructure/structure.py -K $i --input=$PLINK --output=OUTPUT/DIVERSITY/STRUCTURE/RUN/BOL --prior=simple --format=bed 
  done
  
  cp OUTPUT/DIVERSITY/STRUCTURE/RUN/*.meanQ OUTPUT/DIVERSITY/STRUCTURE/meanQ/
### choose K
  python2 ~/PROGRAMS/fastStructure/chooseK.py --input=OUTPUT/DIVERSITY/STRUCTURE/RUN/BOL > OUTPUT/DIVERSITY/STRUCTURE/K.txt