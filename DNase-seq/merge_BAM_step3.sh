#!/bin/bash
#$ -N DNAse_mm39_merge
#$ -cwd
#$ -l h_data=10G,h_rt=8:00:00
#$ -pe shared 6

source ~/.bashrc

module load samtools/1.15

threads=6

genome=/u/scratch/j/jadiruss/Genomes/mm39_STAR
reads=/u/scratch/j/jadiruss/DNase_new/align
outdir=/u/scratch/j/jadiruss/DNase_new/summaries

readsout=/u/scratch/j/jadiruss/DNase_new/merge
peaks=/u/scratch/j/jadiruss/DNase_new/peaks

#E9.5
samtools merge -@ $threads -o $readsout/E95_merge_STAR.bam $reads/SRR6519360_STAR_sorted_nmulti1_rmdup_sorted.bam $reads/SRR6519361_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $readsout/E95_merge_STAR.bam > $readsout/E95_merge_STAR_sorted.bam
samtools index -@ $threads -b $readsout/E95_merge_STAR_sorted.bam $readsout/E95_merge_STAR_sorted.bam.bai

#E10.5 
samtools merge -@ $threads -o $readsout/E105_merge_STAR.bam $reads/SRR6519362_STAR_sorted_nmulti1_rmdup_sorted.bam $reads/SRR6519363_STAR_sorted_nmulti1_rmdup_sorted.bam
samtools sort -@ $threads $readsout/E105_merge_STAR.bam > $readsout/E105_merge_STAR_sorted.bam
samtools index -@ $threads -b $readsout/E105_merge_STAR_sorted.bam $readsout/E105_merge_STAR_sorted.bam.bai

#E12.5 Female 
samtools merge -@ $threads -o $readsout/E125_F_merge_STAR.bam $reads/SRR6519364_STAR_sorted_nmulti1_rmdup_sorted.bam $reads/SRR6519365_STAR_sorted_nmulti1_rmdup_sorted.bam 
samtools sort -@ $threads $readsout/E125_F_merge_STAR.bam > $readsout/E125_F_merge_STAR_sorted.bam
samtools index -@ $threads -b $readsout/E125_F_merge_STAR_sorted.bam $readsout/E125_F_merge_STAR_sorted.bam.bai

#E12.5 Male 
samtools merge -@ $threads -o $readsout/E125_M_merge_STAR.bam $reads/SRR6519367_STAR_sorted_nmulti1_rmdup_sorted.bam $reads/SRR6519368_STAR_sorted_nmulti1_rmdup_sorted.bam 
samtools sort -@ $threads $readsout/E125_M_merge_STAR.bam > $readsout/E125_M_merge_STAR_sorted.bam
samtools index -@ $threads -b $readsout/E125_M_merge_STAR_sorted.bam $readsout/E125_M_merge_STAR_sorted.bam.bai

#E13.5 Female
samtools merge -@ $threads -o $reads/E135_F_merge_STAR.bam $reads/SRR6519370_STAR_sorted_nmulti1_rmdup_sorted.bam $reads/SRR6519371_STAR_sorted_nmulti1_rmdup_sorted.bam 
samtools sort -@ $threads $readsout/E135_F_merge_STAR.bam > $readsout/E135_F_merge_STAR_sorted.bam
samtools index -@ $threads -b $readsout/E135_F_merge_STAR_sorted.bam $readsout/E135_F_merge_STAR_sorted.bam.bai

#E13.5 Male
samtools merge -@ $threads -o $reads/E135_M_merge_STAR.bam $reads/SRR6519372_STAR_sorted_nmulti1_rmdup_sorted.bam $reads/SRR6519373_STAR_sorted_nmulti1_rmdup_sorted.bam 
samtools sort -@ $threads $readsout/E135_M_merge_STAR.bam > $readsout/E135_M_merge_STAR_sorted.bam
samtools index -@ $threads -b $readsout/E135_M_merge_STAR_sorted.bam $readsout/E135_M_merge_STAR_sorted.bam.bai

#E14.5 Female
samtools merge -@ $threads -o $readsout/E145_F_merge_STAR.bam $reads/SRR6519374_STAR_sorted_nmulti1_rmdup_sorted.bam $reads/SRR6519375_STAR_sorted_nmulti1_rmdup_sorted.bam 
samtools sort -@ $threads $readsout/E145_F_merge_STAR.bam > $readsout/E145_F_merge_STAR_sorted.bam
samtools index -@ $threads -b $readsout/E145_F_merge_STAR_sorted.bam $readsout/E145_F_merge_STAR_sorted.bam.bai

#E14.5 Male
samtools merge -@ $threads -o $readsout/E145_M_merge_STAR.bam $reads/SRR6519376_STAR_sorted_nmulti1_rmdup_sorted.bam $reads/SRR6519377_STAR_sorted_nmulti1_rmdup_sorted.bam 
samtools sort -@ $threads $readsout/E145_M_merge_STAR.bam > $readsout/E145_M_merge_STAR_sorted.bam
samtools index -@ $threads -b $readsout/E145_M_merge_STAR_sorted.bam $readsout/E145_M_merge_STAR_sorted.bam.bai

#E16.5 Female
samtools merge -@ $threads -o $readsout/E165_F_merge_STAR.bam $reads/SRR6519378_STAR_sorted_nmulti1_rmdup_sorted.bam $reads/SRR6519379_STAR_sorted_nmulti1_rmdup_sorted.bam 
samtools sort -@ $threads $readsout/E165_F_merge_STAR.bam > $readsout/E165_F_merge_STAR_sorted.bam
samtools index -@ $threads -b $readsout/E165_F_merge_STAR_sorted.bam $readsout/E165_F_merge_STAR_sorted.bam.bai

#E16.5 Male
samtools merge -@ $threads -o $readsout/E165_M_merge_STAR.bam $reads/SRR6519380_STAR_sorted_nmulti1_rmdup_sorted.bam $reads/SRR6519381_STAR_sorted_nmulti1_rmdup_sorted.bam 
samtools sort -@ $threads $readsout/E165_M_merge_STAR.bam > $readsout/E165_M_merge_STAR_sorted.bam
samtools index -@ $threads -b $readsout/E165_M_merge_STAR_sorted.bam $readsout/E165_M_merge_STAR_sorted.bam.bai


