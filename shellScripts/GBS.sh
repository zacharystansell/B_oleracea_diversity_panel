#!/bin/bash

#GBS Pipeline for broccoli diversity.

# WD
cd /home/zachary/PROJECTS/diversity_panel_2.0/
# Settings
export MEM="-Xmx25g"   

# data
export DIR="DATA/GBS/DATASETS/BOL/"
export ILLUMINA="DATA/GBS/ILLUMINA/"
export DB=$DIR"db"
export KEY="DATA/GBS/DATASETS/div2key.txt"
export REFGENOME="DATA/GBS/REFERENCE_GENOMES/BOL/Brassica_oleracea.BOL.dna.toplevel.fa.gz"

# Output results
export STATS=$DIR"outputStatsAll.txt"  
export ALL=$DIR"ALL.h5"


# Grab Data
### GBS plates
wget XXXX
wget XXXX

### ref genome
#wget ftp://ftp.ensemblgenomes.org/pub/plants/release-46/fasta/brassica_oleracea/dna/Brassica_oleracea.BOL.dna.toplevel.fa.gz | mv Brassica_oleracea.BOL.dna.toplevel.fa.gz > $REFGENOME

### GBSSeqToTagDBPlugin
run_pipeline.pl  $MEM -fork1  -GBSSeqToTagDBPlugin -e ApeKI -i $ILLUMINA -db $DB -k $KEY -minKmerL 10 -mnQS 20  -mxKmerNum 50000000 -endPlugin -runfork1

### TagExportToFastqPlugin
export TAGS=$DIR"tagsForAlign.fa.gz"
export SAI=$DIR"tagsForAlign.sai"
export SAM=$DIR"tagsForAlign.sam"

run_pipeline.pl $MEM -fork1 -TagExportToFastqPlugin  -db $DB -o $TAGS  -c 1 -endPlugin -runfork1

### Genome Alignments
bwa index -a bwtsw $REFGENOME
bwa aln -t 8 $REFGENOME $TAGS > $SAI  
bwa samse  $REFGENOME $SAI $TAGS> $SAM
### SAMtoGBS plugin...
run_pipeline.pl $MEM -fork1  -SAMToGBSdbPlugin -i $SAM -db $DB -runfork1

rm $SAI $SAM $TAGS
### DiscoverySNPCallerPluginV2
run_pipeline.pl  $MEM -fork1  -DiscoverySNPCallerPluginV2 -db $DB -sC "C1" -eC "C9" -mnLCov 0.1 -mnMAF 0.01 -ref $REFGENOME  -deleteOldData true -endPlugin -runfork1

### ProductionSNPCallerPluginV2
run_pipeline.pl $MEM -fork1  -ProductionSNPCallerPluginV2 -db $DB -e ApeKI -i $ILLUMINA -k $KEY  -o $ALL -endPlugin -runfork1

run_pipeline.pl $MEM -fork1 -SNPQualityProfilerPlugin -db $DB -statFile $STATS  -deleteOldData true -endPlugin -runfork1

### KNNi Imputation
run_pipeline.pl $MEM -importGuess $ALL -LDKNNiImputationPlugin -highLDSSites 30 -knnTaxa 10 -maxLDDistance 10000000 -endPlugin  -export $DIR"BOL_KNNI" -exportType Hapmap


