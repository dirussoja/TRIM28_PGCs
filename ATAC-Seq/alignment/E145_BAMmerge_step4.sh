#!/bin/bash
#$ -N E145_ATAC_mm39_merge
#$ -cwd
#$ -l h_data=5G,h_rt=4:00:00
#$ -pe shared 6

source ~/.bashrc

module load samtools/1.15

threads=6

genome=/u/scratch/j/jadiruss/Genomes/mm39_STAR
reads=/u/scratch/j/jadiruss/ATAC_new/E145/merge
outdir=/u/scratch/j/jadiruss/ATAC_new/E145/summaries

readsout=/u/scratch/j/jadiruss/ATAC_new/E145/align
peaks=/u/scratch/j/jadiruss/ATAC_new/E145/peaks

#E145 Male WT
samtools merge -@ $threads -o $reads/E145_MWT_nmulti1_noMT.bam $readsout/E145-M-WT1_STAR_noMT_multin1_rmdup_sorted.bam $readsout/E145-M-WT2_STAR_noMT_multin1_rmdup_sorted.bam $readsout/E145-M-WT3_STAR_noMT_multin1_rmdup_sorted.bam $readsout/E145-M-WT4_STAR_noMT_multin1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E145_MWT_nmulti1_noMT.bam > $reads/E145_MWT_nmulti1_noMT_sorted.bam
samtools index -@ $threads -b $reads/E145_MWT_nmulti1_noMT_sorted.bam $reads/E145_MWT_nmulti1_noMT_sorted.bam.bai

#E145 Male Mut
samtools merge -@ $threads -o $reads/E145_MMUT_nmulti1_noMT.bam $readsout/E145-M-MUT1_STAR_noMT_multin1_rmdup_sorted.bam $readsout/E145-M-MUT2_STAR_noMT_multin1_rmdup_sorted.bam $readsout/E145-M-MUT3_STAR_noMT_multin1_rmdup_sorted.bam $readsout/E145-F-MUT4_STAR_noMT_multin1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E145_MMUT_nmulti1_noMT.bam > $reads/E145_MMUT_nmulti1_noMT_sorted.bam
samtools index -@ $threads -b $reads/E145_MMUT_nmulti1_noMT_sorted.bam $reads/E145_MMUT_nmulti1_noMT_sorted.bam.bai

#E145 Female WT
samtools merge -@ $threads -o $reads/E145_FWT_nmulti1_noMT.bam $readsout/E145-F-WT1_STAR_noMT_multin1_rmdup_sorted.bam $readsout/E145-F-WT2_STAR_noMT_multin1_rmdup_sorted.bam $readsout/E145-F-WT3_STAR_noMT_multin1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E145_FWT_nmulti1_noMT.bam > $reads/E145_FWT_nmulti1_noMT_sorted.bam
samtools index -@ $threads -b $reads/E145_FWT_nmulti1_noMT_sorted.bam $reads/E145_FWT_nmulti1_noMT_sorted.bam.bai

#E145 Female Mut
samtools merge -@ $threads -o $reads/E145_FMUT_nmulti1_noMT.bam $readsout/E145-F-MUT1_STAR_noMT_multin1_rmdup_sorted.bam $readsout/E145-F-MUT2_STAR_noMT_multin1_rmdup_sorted.bam $readsout/E145-F-MUT3_STAR_noMT_multin1_rmdup_sorted.bam
samtools sort -@ $threads $reads/E145_FMUT_nmulti1_noMT.bam > $reads/E145_FMUT_nmulti1_noMT_sorted.bam
samtools index -@ $threads -b $reads/E145_FMUT_nmulti1_noMT_sorted.bam $reads/E145_FMUT_nmulti1_noMT_sorted.bam.bai
