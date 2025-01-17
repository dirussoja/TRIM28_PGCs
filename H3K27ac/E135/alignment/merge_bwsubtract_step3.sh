#!/bin/bash
#$ -N E135_ChIP_Compare
#$ -cwd
#$ -l h_data=5G,h_rt=6:00:00
#$ -t 1-2:1
#$ -pe shared 12

fqs=(
E135_Female_
E135_Male_
)

source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

reads=/u/scratch/j/jadiruss/E135_H3K27ac/merge
outdir=/u/scratch/j/jadiruss/E135_H3K27ac/bw

threads=12

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then

bamCompare -b1 $reads/$fq"H3K27ac_ChIP_sorted.bam" -b2 $reads/$fq"Inp_sorted.bam" -bs 10 -p $threads \
--operation subtract --scaleFactorsMethod None --normalizeUsing RPKM --effectiveGenomeSize 2654621783 \
-o $outdir/$fq"_bamcompare_RPKM_bs10.bw"

fi;
    COUNT=$[COUNT+1];
done;

#genome effective size is non-n bases from: http://genomewiki.ucsc.edu/index.php/Mm39_35-way_Genome_size_statistics
