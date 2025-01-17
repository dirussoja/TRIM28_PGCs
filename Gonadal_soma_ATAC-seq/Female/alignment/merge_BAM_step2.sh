#!/bin/bash
#$ -N ATAC_Soma_Merge
#$ -cwd
#$ -l h_data=5G,h_rt=2:00:00
#$ -pe shared 3

source ~/.bashrc

module load samtools/1.15

threads=6

genome=/u/scratch/j/jadiruss/Genomes/mm39_STAR
reads=/u/scratch/j/jadiruss/soma/female_soma/merge
readsout=/u/scratch/j/jadiruss/soma/female_soma/align

#Female Soma E10.5
samtools merge -@ $threads -o $reads/E105_Female_Soma_ATAC.bam $readsout/SRR7719559_STAR_noMT_multin1_rmdup_sorted.bam $readsout/SRR7719560_STAR_noMT_multin1_rmdup_sorted.bam $readsout/SRR7719561_STAR_noMT_multin1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E105_Female_Soma_ATAC.bam > $reads/E105_Female_Soma_ATAC_sorted.bam
samtools index -@ $threads -b $reads/E105_Female_Soma_ATAC_sorted.bam $reads/E105_Female_Soma_ATAC_sorted.bam.bai

#Female soma E13.5
samtools merge -@ $threads -o $reads/E135_Female_Soma_ATAC.bam $readsout/SRR7719553_STAR_noMT_multin1_rmdup_sorted.bam $readsout/SRR7719554_STAR_noMT_multin1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E135_Female_Soma_ATAC.bam > $reads/E135_Female_Soma_ATAC_sorted.bam
samtools index -@ $threads -b $reads/E135_Female_Soma_ATAC_sorted.bam $reads/E135_Female_Soma_ATAC_sorted.bam.bai
