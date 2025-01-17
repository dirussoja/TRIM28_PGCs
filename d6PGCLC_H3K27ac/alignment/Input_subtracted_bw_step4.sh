#!/bin/bash
#$ -N H3K27ac_mm39_subtract
#$ -cwd
#$ -l h_data=5G,h_rt=6:00:00
#$ -t 1-1:1
#$ -pe shared 8

fqs=(
H3K27ac
)

source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

outdir=/u/scratch/j/jadiruss/H3K27ac_PGCLC/bw

threads=8

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then

bigwigCompare -b1 $outdir/$fq"_ChIP_RPGC_bs10.bw" -b2 $outdir/"Input_RPGC_bs10.bw" \
-o $outdir/$fq"_RPGC_bs10_subtract.bw" -bs 10 -p $threads --operation subtract

bigwigCompare -b1 $outdir/$fq"_ChIP_RPKM_bs10.bw" -b2 $outdir/"Input_RPKM_bs10.bw" \
-o $outdir/$fq"_RPKM_bs10_subtrack.bw" -bs 10 -p $threads --operation subtract

fi;
    COUNT=$[COUNT+1];
done;

#genome effective size is non-n bases from: http://genomewiki.ucsc.edu/index.php/Mm39_35-way_Genome_size_statistics
