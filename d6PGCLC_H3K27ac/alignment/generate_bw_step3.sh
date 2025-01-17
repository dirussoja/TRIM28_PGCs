#!/bin/bash
#$ -N H3K27ac_ChIP_bw
#$ -cwd
#$ -l h_data=5G,h_rt=6:00:00
#$ -t 1-2:1
#$ -pe shared 6

fqs=(
H3K27ac_ChIP
Input
)

source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

reads=/u/scratch/j/jadiruss/H3K27ac_PGCLC/merge
outdir=/u/scratch/j/jadiruss/H3K27ac_PGCLC/bw

threads=6

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then

bamCoverage -b $reads/"d6_PGCLC_"$fq"_sorted.bam" -o $outdir/$fq"_RPKM_bs10.bw" -bs 10 -p $threads \
--normalizeUsing RPKM

bamCoverage -b $reads/"d6_PGCLC_"$fq"_sorted.bam" -o $outdir/$fq"_RPGC_bs10.bw" -bs 10 -p $threads \
--normalizeUsing RPGC --effectiveGenomeSize 2654621783


fi;
    COUNT=$[COUNT+1];
done;

#genome effective size is non-n bases from: http://genomewiki.ucsc.edu/index.php/Mm39_35-way_Genome_size_statistics
