#!/bin/bash
#$ -N H3K9me3_ChIP_bamcompare
#$ -cwd
#$ -l h_data=5G,h_rt=6:00:00
#$ -t 1-3:1
#$ -pe shared 12

fqs=(
E105
E135_F
E135_M
)

source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

reads=/u/scratch/j/jadiruss/H3K9me3_update/merge
outdir=/u/scratch/j/jadiruss/H3K9me3_update/bw

threads=12

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then

bamCompare -b1 $reads/$fq"_H3K9me3_ChIP_rmdup_sorted.bam" -b2 $reads/$fq"_Input_ChIP_rmdup_sorted.bam" -bs 10 -p $threads \
--operation subtract --scaleFactorsMethod None --normalizeUsing RPKM -e --effectiveGenomeSize 2654621783 \
-o $outdir/$fq"_bamcompare_extend_RPKM_bs10.bw"

fi;
    COUNT=$[COUNT+1];
done;

#genome effective size is non-n bases from: http://genomewiki.ucsc.edu/index.php/Mm39_35-way_Genome_size_statistics
