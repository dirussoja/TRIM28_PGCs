#!/bin/bash
#$ -N E105_Samtools_sort
#$ -cwd
#$ -l h_data=5G,h_rt=3:00:00
#$ -t 1-17:1
#$ -pe shared 6

fqs=(
JAD-E105-ATAC-FWT1
JAD-E105-ATAC-FWT3
JAD-E105-ATAC-FWT4
JAD-E105-ATAC-MMUT2
JAD-E105-ATAC-MMUT3
JAD-E105-ATAC-MMUT4
JAD-E105-ATAC-MWT1
JAD-E105-ATAC-MWT2
JAD-E105-ATAC-MWT3
JAD-E105-ATAC-MWT4
JAD-E105-Female-Mut5
JAD-E105-Female-Mut6
JAD-E105-Female-WT5
JAD-E105-F-MUT1
JAD-E105-F-MUT4
JAD-E105-Male-Mut5
JAD-E105-Male-Mut7
)


source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

align=/u/scratch/j/jadiruss/ATAC_new/E105/align
out=/u/scratch/j/jadiruss/ATAC_new/E105/align


threads=6

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then

samtools sort -@ $threads -n $align/$fq"_STAR_noMT_multin1_rmdup_sorted.bam" -o $out/$fq"_genrich_namesort.bam"

fi;
    COUNT=$[COUNT+1];
done;
