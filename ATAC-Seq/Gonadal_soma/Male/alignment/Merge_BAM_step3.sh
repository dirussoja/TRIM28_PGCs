#!/bin/bash
#$ -N ATAC_Soma_Merge
#$ -cwd
#$ -l h_data=5G,h_rt=2:00:00
#$ -pe shared 3

source ~/.bashrc

module load samtools/1.15

threads=6

genome=/u/scratch/j/jadiruss/Genomes/mm39_STAR
reads=/u/scratch/j/jadiruss/soma/male_soma/merge
readsout=/u/scratch/j/jadiruss/soma/male_soma/align

#Male Soma E10.5
samtools merge -@ $threads -o $reads/E105_Male_Soma_ATAC.bam $readsout/SRR7719557_STAR_noMT_multin1_rmdup_sorted.bam $readsout/SRR7719558_STAR_noMT_multin1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E105_Male_Soma_ATAC.bam > $reads/E105_Male_Soma_ATAC_sorted.bam
samtools index -@ $threads -b $reads/E105_Male_Soma_ATAC_sorted.bam $reads/E105_Male_Soma_ATAC_sorted.bam.bai

#Male soma E13.5
samtools merge -@ $threads -o $reads/E135_Male_Soma_ATAC.bam $readsout/SRR7719555_STAR_noMT_multin1_rmdup_sorted.bam $readsout/SRR7719556_STAR_noMT_multin1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E135_Male_Soma_ATAC.bam > $reads/E135_Male_Soma_ATAC_sorted.bam
samtools index -@ $threads -b $reads/E135_Male_Soma_ATAC_sorted.bam $reads/E135_Male_Soma_ATAC_sorted.bam.bai
