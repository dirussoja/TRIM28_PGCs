#!/bin/bash
#$ -N wget_H3K27ac
#$ -cwd
#$ -l h_data=5G,h_rt=00:45:00
#$ -t 1-12:1

fqs=(
DRX118927/DRR126183_1.fastq.bz2
DRX118927/DRR126183_2.fastq.bz2
DRX118928/DRR126184_1.fastq.bz2
DRX118928/DRR126184_2.fastq.bz2
DRX118941/DRR126197_1.fastq.bz2
DRX118941/DRR126197_2.fastq.bz2
DRX118942/DRR126198_1.fastq.bz2
DRX118942/DRR126198_2.fastq.bz2
DRX118943/DRR126199_1.fastq.bz2
DRX118943/DRR126199_2.fastq.bz2
DRX118992/DRR126248_1.fastq.bz2
DRX118992/DRR126248_2.fastq.bz2
)

source ~/.bashrc

reads=/u/scratch/j/jadiruss/E135_H3K27ac_try2/reads

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then

cd /u/scratch/j/jadiruss/reads
wget "https://ddbj.nig.ac.jp/public/ddbj_database/dra/fastq/DRA006/DRA006633"/$fq

fi;
    COUNT=$[COUNT+1];
done;
