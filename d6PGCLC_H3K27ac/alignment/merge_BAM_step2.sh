#!/bin/bash
#$ -N H3K27ac_Merge
#$ -cwd
#$ -l h_data=5G,h_rt=4:00:00
#$ -pe shared 6

source ~/.bashrc

module load samtools/1.15

threads=6

genome=/u/scratch/j/jadiruss/Genomes/mm39_STAR
reads=/u/scratch/j/jadiruss/H3K27ac_PGCLC/merge
outdir=/u/scratch/j/jadiruss/H3K27ac_PGCLC/summaries

readsout=/u/scratch/j/jadiruss/H3K27ac_PGCLC/align
peaks=/u/scratch/j/jadiruss/H3K27ac_PGCLC/peaks

#H3K27ac ChIP
samtools merge -@ $threads -o $reads/d6_PGCLC_H3K27ac_ChIP.bam $readsout/SRR1539456_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/SRR1539457_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/d6_PGCLC_H3K27ac_ChIP.bam > $reads/d6_PGCLC_H3K27ac_ChIP_sorted.bam
samtools index -@ $threads -b $reads/d6_PGCLC_H3K27ac_ChIP_sorted.bam $reads/d6_PGCLC_H3K27ac_ChIP.bam.bai

#H3K27ac ChIP Inp
samtools merge -@ $threads -o $reads/d6_PGCLC_Input.bam $readsout/SRR1539503_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/SRR1539504_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/d6_PGCLC_Input.bam > $reads/d6_PGCLC_Input_sorted.bam
samtools index -@ $threads -b $reads/d6_PGCLC_Input_sorted.bam $reads/d6_PGCLC_Input_sorted.bam.bai
