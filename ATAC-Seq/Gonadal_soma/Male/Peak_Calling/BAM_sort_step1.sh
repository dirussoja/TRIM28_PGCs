#!/bin/bash
#$ -N ATAC_soma_Samtools_sort
#$ -cwd
#$ -l h_data=5G,h_rt=3:00:00
#$ -t 1-4:1
#$ -pe shared 6

fqs=(
SRR7719555
SRR7719556
SRR7719557
SRR7719558
)


source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

align=/u/scratch/j/jadiruss/soma/male_soma/align
out=/u/scratch/j/jadiruss/soma/male_soma/peaks


threads=6

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then

samtools sort -@ $threads -n $align/$fq"_STAR_noMT_multin1_rmdup_sorted.bam" -o $out/$fq"_genrich_namesort.bam"

fi;
    COUNT=$[COUNT+1];
done;
