#!/bin/bash
#$ -N TRIM28_ChIP_bamCompare
#$ -cwd
#$ -l h_data=5G,h_rt=12:00:00
#$ -t 1-2:1
#$ -pe shared 12

fqs=(
E125_F
E125_M
)


source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

reads=/u/scratch/j/jadiruss/TRIM28_ChIP/merge
out=/u/scratch/j/jadiruss/TRIM28_ChIP/bw

threads=12

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then

bamCompare -b1 $reads/$fq"_merge_sorted.bam" -b2 $reads/$fq"_Inp_merge_sorted.bam" \
-o $out/$fq"_readCount_subtract_bs10.bw" --scaleFactorsMethod readCount --operation subtract -bs 10 -e --smoothLength 20 -p $threads 

bamCompare -b1 $reads/$fq"_merge_sorted.bam" -b2 $reads/$fq"_Inp_merge_sorted.bam" \
-o $out/$fq"_readCount_log2_bs10.bw" --scaleFactorsMethod readCount --operation log2 --pseudocount 1 -bs 10 -e --smoothLength 20 -p $threads 

fi;
    COUNT=$[COUNT+1];
done;
