#!/bin/bash
#$ -N E145_Samtools_sort
#$ -cwd
#$ -l h_data=5G,h_rt=3:00:00
#$ -t 1-14:1
#$ -pe shared 6

fqs=(
E145-F-MUT1
E145-F-MUT2
E145-F-MUT3
E145-F-WT1
E145-F-WT2
E145-F-WT3
E145-F-WT4
E145-M-MUT1
E145-M-MUT2
E145-M-MUT3
E145-M-WT1
E145-M-WT2
E145-M-WT3
E145-M-WT4)

source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

align=/u/scratch/j/jadiruss/ATAC_Alluvial_WTonly/align/E145
out=/u/scratch/j/jadiruss/ATAC_Alluvial_WTonly/align/E145_sort


threads=6

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then
    
samtools sort -@ $threads -n $align/$fq"_STAR_noMT_multin1_rmdup_sorted.bam" -o $out/$fq"_genrich_namesort.bam"

fi;
    COUNT=$[COUNT+1];
done;
