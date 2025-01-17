#!/bin/bash
#$ -N TRIM28_mm39_merge
#$ -cwd
#$ -l h_data=5G,h_rt=4:00:00
#$ -pe shared 6

source ~/.bashrc

module load samtools/1.15

threads=6

genome=/u/scratch/j/jadiruss/Genomes/mm39_STAR
reads=/u/scratch/j/jadiruss/TRIM28_ChIP/merge
readsout=/u/scratch/j/jadiruss/TRIM28_ChIP/align


#E125 Male
samtools merge -@ $threads -o $reads/E125_M_merge.bam $readsout/E125-ChIP-Male-1_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/E125-ChIP-Male-2_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E125_M_merge.bam > $reads/E125_M_merge_sorted.bam
samtools index -@ $threads -b $reads/E125_M_merge_sorted.bam $reads/E125_M_merge_sorted.bam.bai

#E125 Male Input
samtools merge -@ $threads -o $reads/E125_M_Inp_merge.bam $readsout/E125-ChIP-Male-Inp-1_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/E125-ChIP-Male-Inp-2_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E125_M_Inp_merge.bam > $reads/E125_M_Inp_merge_sorted.bam
samtools index -@ $threads -b $reads/E125_M_Inp_merge_sorted.bam $reads/E125_M_Inp_merge_sorted.bam.bai

#E125 Female
samtools merge -@ $threads -o $reads/E125_F_merge.bam $readsout/E125-ChIP-Female-1_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/E125-ChIP-Female-2_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E125_F_merge.bam > $reads/E125_F_merge_sorted.bam
samtools index -@ $threads -b $reads/E125_F_merge_sorted.bam $reads/E125_F_merge_sorted.bam.bai

#E125 Female Input
samtools merge -@ $threads -o $reads/E125_F_Inp_merge.bam $readsout/E125-ChIP-Female-Inp-1_STAR_sorted_nmulti1_rmdup_sorted.bam $readsout/E125-ChIP-Female-Inp-1_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E125_F_Inp_merge.bam > $reads/E125_F_Inp_merge_sorted.bam
samtools index -@ $threads -b $reads/E125_F_Inp_merge_sorted.bam $reads/E125_F_Inp_merge_sorted.bam.bai
