#!/bin/bash
#$ -N H3K9me3_mm39_merge
#$ -cwd
#$ -l h_data=5G,h_rt=8:00:00
#$ -pe shared 6

source ~/.bashrc

module load samtools/1.15

threads=6

reads=/u/scratch/j/jadiruss/H3K9me3_update/merge
new=/u/scratch/j/jadiruss/H3K9me3_update/align
readsout=/u/home/j/jadiruss/project-clarka/TRIM28/ChIP-seq/H3K9me3/align

#E105 ChIP
samtools merge -@ $threads -o $reads/E105_H3K9me3_ChIP_rmdup.bam $readsout/SRR10560100_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/SRR10560104_STAR_sorted_nmulti1_rmdup_sorted.bam $new/SRR13296472_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E105_H3K9me3_ChIP_rmdup.bam > $reads/E105_H3K9me3_ChIP_rmdup_sorted.bam
samtools index -@ $threads -b $reads/E105_H3K9me3_ChIP_rmdup_sorted.bam $reads/E105_H3K9me3_ChIP_rmdup_sorted.bam.bai

#E105 ChIP Input
samtools merge -@ $threads -o $reads/E105_Input_ChIP_rmdup.bam $readsout/SRR10560101_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/SRR10560105_STAR_sorted_nmulti1_rmdup_sorted.bam $new/SRR13296477_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E105_Input_ChIP_rmdup.bam > $reads/E105_Input_ChIP_rmdup_sorted.bam 
samtools index -@ $threads -b $reads/E105_Input_ChIP_rmdup_sorted.bam $reads/E105_Input_ChIP_rmdup_sorted.bam.bai

#135 Female ChIP
samtools merge -@ $threads -o $reads/E135_F_H3K9me3_ChIP_rmdup.bam $readsout/SRR10560108_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/SRR10560114_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/SRR13296474_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E135_F_H3K9me3_ChIP_rmdup.bam > $reads/E135_F_H3K9me3_ChIP_rmdup_sorted.bam
samtools index -@ $threads -b $reads/E135_F_H3K9me3_ChIP_rmdup_sorted.bam $reads/E135_F_H3K9me3_ChIP_rmdup_sorted.bam.bai

#135 Female Input
samtools merge -@ $threads -o $reads/E135_F_Input_ChIP_rmdup.bam $readsout/SRR10560106_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/SRR10560112_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/SRR13296479_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E135_F_Input_ChIP_rmdup.bam > $reads/E135_F_Input_ChIP_rmdup_sorted.bam
samtools index -@ $threads -b $reads/E135_F_Input_ChIP_rmdup_sorted.bam $reads/E135_F_Input_ChIP_rmdup_sorted.bam.bai

#135 Male ChIP
samtools merge -@ $threads -o $reads/E135_M_H3K9me3_ChIP_rmdup.bam $readsout/SRR10560111_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/SRR10560117_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/SRR13296476_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E135_M_H3K9me3_ChIP_rmdup.bam > $reads/E135_M_H3K9me3_ChIP_rmdup_sorted.bam
samtools index -@ $threads -b $reads/E135_M_H3K9me3_ChIP_rmdup_sorted.bam $reads/E135_M_H3K9me3_ChIP_rmdup_sorted.bam.bai

#135 Male Input
samtools merge -@ $threads -o $reads/E135_M_Input_ChIP_rmdup.bam $readsout/SRR10560109_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/SRR10560115_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/SRR13296481_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E135_M_Input_ChIP_rmdup.bam > $reads/E135_M_Input_ChIP_rmdup_sorted.bam
samtools index -@ $threads -b $reads/E135_M_Input_ChIP_rmdup_sorted.bam $reads/E135_M_Input_ChIP_rmdup_sorted.bam.bai
