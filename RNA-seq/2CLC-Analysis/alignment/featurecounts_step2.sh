#!/bin/bash
#$ -N fc_2C
#$ -cwd
#$ -l h_data=5G,h_rt=2:00:00
#$ -pe shared 8

source ~/.bashrc

module load java/jre-1.8.0_281
module load samtools/1.11
module load picard_tools/2.25.0
module load python/3.9.6
module load star/2.7.9a

threads=8

genome=/u/home/j/jadiruss/project-clarka/Genomes/mm39_STAR
genome_te=/u/home/j/jadiruss/project-clarka/Genomes/mm39_STAR_noGTF
reads=/u/scratch/j/jadiruss/2C_RNA/fastq
readsout=/u/scratch/j/jadiruss/2C_RNA/align
counts=/u/scratch/j/jadiruss/2C_RNA/counts

featureCounts -g gene_id -s 0 -p -P -B -T $threads -C -D 1000 -a $genome/"Mus_musculus.GRCm39.109.gtf" \
-o $counts/$fq"_STAR_genecounts.txt" $readsout/SRR2980403_STAR_Aligned.sortedByCoord.out.bam $readsout/SRR2980404_STAR_Aligned.sortedByCoord.out.bam \
$readsout/SRR2980405_STAR_Aligned.sortedByCoord.out.bam $readsout/SRR2980406_STAR_Aligned.sortedByCoord.out.bam $readsout/SRR2980407_STAR_Aligned.sortedByCoord.out.bam \
$readsout/SRR2980408_STAR_Aligned.sortedByCoord.out.bam $readsout/SRR2980409_STAR_Aligned.sortedByCoord.out.bam $readsout/SRR2980410_STAR_Aligned.sortedByCoord.out.bam \
$readsout/SRR2980411_STAR_Aligned.sortedByCoord.out.bam $readsout/SRR2980412_STAR_Aligned.sortedByCoord.out.bam
