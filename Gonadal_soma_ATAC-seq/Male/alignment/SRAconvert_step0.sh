#!/bin/bash
#$ -N SRA_to_Fastq_atacsoma
#$ -cwd
#$ -l h_data=5G,h_rt=4:00:00
#$ -t 1-4:1
#$ -pe shared 4

fqs=(
SRR7719555
SRR7719556
SRR7719557
SRR7719558
)

source ~/.bashrc

reads=/u/scratch/j/jadiruss/soma/male_soma/reads
sra=/u/scratch/j/jadiruss/soma/male_soma/SRA

threads=16

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then

fastq-dump --gzip --split-3  -O $reads $sra/$fq".sra"

fi;
    COUNT=$[COUNT+1];
done;
