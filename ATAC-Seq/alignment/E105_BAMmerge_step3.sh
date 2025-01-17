#!/bin/bash
#$ -N E105_ATAC_mm39_merge
#$ -cwd
#$ -l h_data=5G,h_rt=2:00:00
#$ -pe shared 3

source ~/.bashrc

module load samtools/1.15

threads=6

genome=/u/scratch/j/jadiruss/Genomes/mm39_STAR
reads=/u/scratch/j/jadiruss/ATAC_new/E105/merge
outdir=/u/scratch/j/jadiruss/ATAC_new/E105/summaries

readsout=/u/scratch/j/jadiruss/ATAC_new/E105/align
peaks=/u/scratch/j/jadiruss/ATAC_new/E105/peaks

#FWT
samtools merge -@ $threads -o $reads/E105_FWT_noMT_rmdup.bam $readsout/JAD-E105-ATAC-FWT1_STAR_noMT_multin1_rmdup_sorted.bam $readsout/JAD-E105-ATAC-FWT3_STAR_noMT_multin1_rmdup_sorted.bam $readsout/JAD-E105-ATAC-FWT4_STAR_noMT_multin1_rmdup_sorted.bam $readsout/JAD-E105-Female-WT5_STAR_noMT_multin1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E105_FWT_noMT_rmdup.bam > $reads/E105_FWT_noMT_rmdup_sorted.bam
samtools index -@ $threads -b $reads/E105_FWT_noMT_rmdup_sorted.bam $reads/E105_FWT_noMT_rmdup_sorted.bam.bai

#MWT
samtools merge -@ $threads -o $reads/E105_MWT_noMT_rmdup.bam $readsout/JAD-E105-ATAC-MWT1_STAR_noMT_multin1_rmdup_sorted.bam $readsout/JAD-E105-ATAC-MWT2_STAR_noMT_multin1_rmdup_sorted.bam $readsout/JAD-E105-ATAC-MWT3_STAR_noMT_multin1_rmdup_sorted.bam $readsout/JAD-E105-ATAC-MWT4_STAR_noMT_multin1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E105_MWT_noMT_rmdup.bam > $reads/E105_MWT_noMT_rmdup_sorted.bam
samtools index -@ $threads -b $reads/E105_MWT_noMT_rmdup_sorted.bam $reads/E105_MWT_noMT_rmdup_sorted.bam.bai

#FMUT
samtools merge -@ $threads -o $reads/E105_FMUT_noMT_rmdup.bam $readsout/JAD-E105-F-MUT1_STAR_noMT_multin1_rmdup_sorted.bam $readsout/JAD-E105-F-MUT4_STAR_noMT_multin1_rmdup_sorted.bam $readsout/JAD-E105-Female-Mut5_STAR_noMT_multin1_rmdup_sorted.bam $readsout/JAD-E105-Female-Mut6_STAR_noMT_multin1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E105_FMUT_noMT_rmdup.bam > $reads/E105_FMUT_noMT_rmdup_sorted.bam
samtools index -@ $threads -b $reads/E105_FMUT_noMT_rmdup_sorted.bam $reads/E105_FMUT_noMT_rmdup_sorted.bam.bai

#MMUT
samtools merge -@ $threads -o $reads/E105_MMUT_noMT_rmdup.bam $readsout/JAD-E105-ATAC-MMUT2_STAR_noMT_multin1_rmdup_sorted.bam $readsout/JAD-E105-ATAC-MMUT3_STAR_noMT_multin1_rmdup_sorted.bam $readsout/JAD-E105-ATAC-MMUT4_STAR_noMT_multin1_rmdup_sorted.bam $readsout/JAD-E105-Male-Mut5_STAR_noMT_multin1_rmdup_sorted.bam $readsout/JAD-E105-Male-Mut7_STAR_noMT_multin1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E105_MMUT_noMT_rmdup.bam > $reads/E105_MMUT_noMT_rmdup_sorted.bam
samtools index -@ $threads -b $reads/E105_MMUT_noMT_rmdup_sorted.bam $reads/E105_MMUT_noMT_rmdup_sorted.bam.bai	
