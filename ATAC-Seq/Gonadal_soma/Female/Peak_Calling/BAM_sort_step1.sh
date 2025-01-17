#!/bin/bash
#$ -N ATAC_soma_Samtools_sort
#$ -cwd
#$ -l h_data=5G,h_rt=3:00:00
#$ -t 1-5:1
#$ -pe shared 6

fqs=(
SRR7719553
SRR7719554
SRR7719559
SRR7719560
SRR7719561
)


source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

align=/u/scratch/j/jadiruss/soma/female_soma/align
out=/u/scratch/j/jadiruss/soma/female_soma/peaks


threads=6

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then

samtools sort -@ $threads -n $align/$fq"_STAR_noMT_multin1_rmdup_sorted.bam" -o $out/$fq"_genrich_namesort.bam"

fi;
    COUNT=$[COUNT+1];
done;
