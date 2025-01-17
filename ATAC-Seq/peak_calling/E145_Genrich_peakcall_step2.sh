#!/bin/bash
#$ -N E145_ATAC_peakcall
#$ -cwd
#$ -l h_data=5G,h_rt=3:00:00
#$ -pe shared 6

source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

aligngen=/u/scratch/j/jadiruss/ATAC_Alluvial_WTonly/align/E145_sort
outgen=/u/scratch/j/jadiruss/ATAC_Alluvial_WTonly/align/E145_sort

threads=6

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

Genrich -t $aligngen/E145-M-WT1_genrich_namesort.bam,$aligngen/E145-M-WT2_genrich_namesort.bam,$aligngen/E145-M-WT3_genrich_namesort.bam,$aligngen/E145-M-WT4_genrich_namesort.bam -j -q 0.01 -o $outgen/E145_MWT_genrich_out.narrowPeak -f $outgen/E145_MWT_genrich_pqvalue.bed

Genrich -t $aligngen/E145-M-MUT1_genrich_namesort.bam,$aligngen/E145-M-MUT2_genrich_namesort.bam,$aligngen/E145-M-MUT3_genrich_namesort.bam -j -o $outgen/E145_MMUT_genrich_out.narrowPeak -f -q 0.01 $outgen/E145_MMUT_genrich_pqvalue.bed

Genrich -t $aligngen/E145-F-WT1_genrich_namesort.bam,$aligngen/E145-F-WT2_genrich_namesort.bam,$aligngen/E145-F-WT3_genrich_namesort.bam,$aligngen/E145-F-WT4_genrich_namesort.bam -j -q 0.01 -o $outgen/E145_FWT_genrich_out.narrowPeak -f $outgen/E145_FWT_genrich_pqvalue.bed

Genrich -t $aligngen/E145-F-MUT1_genrich_namesort.bam,$aligngen/E145-F-MUT2_genrich_namesort.bam,$aligngen/E145-F-MUT3_genrich_namesort.bam -j -o $outgen/E145_FMUT_genrich_out.narrowPeak -q 0.01 -f $outgen/E145_FMUT_genrich_pqvalue.bed
`
