#!/bin/bash
#$ -N H3K27ac_Merge
#$ -cwd
#$ -l h_data=5G,h_rt=4:00:00
#$ -pe shared 6

source ~/.bashrc

module load samtools/1.15

threads=6

genome=/u/scratch/j/jadiruss/Genomes/mm39_STAR
reads=/u/scratch/j/jadiruss/E135_H3K27ac/merge
readsout=/u/scratch/j/jadiruss/E135_H3K27ac/align

#Female E13.5 H3K27ac ChIP
samtools merge -@ $threads -o $reads/E135_Female_H3K27ac_ChIP.bam $readsout/DRR126183_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/DRR126184_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E135_Female_H3K27ac_ChIP.bam > $reads/E135_Female_H3K27ac_ChIP_sorted.bam
samtools index -@ $threads -b $reads/E135_Female_H3K27ac_ChIP_sorted.bam $reads/E135_Female_H3K27ac_ChIP_sorted.bam.bai

#Female E13.5 Input
samtools sort -@ $threads $reads/DRR126248_STAR_sorted_nmulti1_rmdup_sorted.bam > $reads/E135_Female_Inp_sorted.bam
samtools index -@ $threads -b $reads/E135_Female_Inp_sorted.bam $reads/E135_Female_Inp_sorted.bam.bai


#Male E13.5 H3K27ac ChIP
samtools merge -@ $threads -o $reads/E135_Male_H3K27ac_ChIP.bam $readsout/DRR126197_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/DRR126198_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E135_Male_H3K27ac_ChIP.bam > $reads/E135_Male_H3K27ac_ChIP_sorted.bam
samtools index -@ $threads -b $reads/E135_Male_H3K27ac_ChIP_sorted.bam $reads/E135_Male_H3K27ac_ChIP_sorted.bam.bai


#Male E13.5 Input
samtools sort -@ $threads $reads/DRR126199_STAR_sorted_nmulti1_rmdup.bam > $reads/E135_Male_Inp_sorted.bam
samtools index -@ $threads -b $reads/E135_Male_Inp_sorted.bam $reads/E135_Male_Inp_sorted.bam.bai
