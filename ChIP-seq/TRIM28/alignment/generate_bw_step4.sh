#!/bin/bash
#$ -N TRIM28_ChIP_bw
#$ -cwd
#$ -l h_data=5G,h_rt=6:00:00
#$ -t 1-4:1
#$ -pe shared 6

fqs=(
E125_F
E125_F_Inp
E125_M
E125_M_Inp
)

source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

reads=/u/scratch/j/jadiruss/TRIM28_ChIP/merge
outdir=/u/scratch/j/jadiruss/TRIM28_ChIP/bw

threads=6

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then

bamCoverage -b $reads/$fq"_merge_sorted.bam" -o $outdir/$fq"_RPKM_bs10.bw" -bs 10 -p $threads \
--normalizeUsing RPKM -e

bamCoverage -b $reads/$fq"_merge_sorted.bam" -o $outdir/$fq"_RPGC_bs10.bw" -bs 10 -p $threads \
--normalizeUsing RPGC --effectiveGenomeSize 2654621783 -e


fi;
    COUNT=$[COUNT+1];
done;

#genome effective size is non-n bases from: http://genomewiki.ucsc.edu/index.php/Mm39_35-way_Genome_size_statistics
