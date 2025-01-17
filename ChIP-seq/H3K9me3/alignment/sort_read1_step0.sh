#!/bin/bash
#$ -N sort_r1_PGCLC_H3K9_mm39
#$ -cwd
#$ -l h_data=10G,h_rt=8:00:00
#$ -t 1-16:1

source ~/.bashrc

module load java/jre-1.8.0_281
module load samtools/1.11
module load picard_tools/2.25.0
module load python/3.9.6
module load star/2.7.9a

fqs=(
SRR10560100
SRR10560101
SRR10560104
SRR10560105
SRR10560106
SRR10560108
SRR10560109
SRR10560111
SRR10560112
SRR10560114
SRR10560115
SRR10560117
SRR13296474
SRR13296479
SRR13296476
SRR13296481)

threads=1

genome=/u/scratch/j/jadiruss/Genomes/mm39_STAR
reads=/u/scratch/j/jadiruss/H3K9me3_new/reads
sorted=/u/scratch/j/jadiruss/H3K9me3_new/reads/sorted
outdir=/u/scratch/j/jadiruss/H3K9me3_new/reads/summaries

readsout=/u/scratch/j/jadiruss/H3K9me3_new/align
peaks=/u/scratch/j/jadiruss/H3K9me3_new/peaks

#first, align using STAR. Here, I have set the paramaters for single-end reads, as this is how I have processed them using SRAtoolkit.
COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then
    
source ~/.bashrc

zcat $reads/$fq"_1.fastq.gz" \
  | paste - - - - \
  | sort -k1,1 -S 3G \
  | tr '\t' '\n' \
  | gzip > $sorted/$fq"_1_sorted.fastq.gz"


fi;
    COUNT=$[COUNT+1];
done;
