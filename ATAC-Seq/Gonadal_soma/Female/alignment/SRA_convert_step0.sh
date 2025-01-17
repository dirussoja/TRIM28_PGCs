#!/bin/bash
#$ -N SRA_to_Fastq_atacsoma
#$ -cwd
#$ -l h_data=5G,h_rt=4:00:00
#$ -t 1-5:1
#$ -pe shared 4

fqs=(
SRR7719553
SRR7719554
SRR7719559
SRR7719560
SRR7719561
)

source ~/.bashrc

reads=/u/scratch/j/jadiruss/atac_soma/reads
sra=/u/scratch/j/jadiruss/atac_soma/SRA/

threads=16

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then

fastq-dump --gzip --split-3  -O $reads $sra/$fq".sra"

fi;
    COUNT=$[COUNT+1];
done;
