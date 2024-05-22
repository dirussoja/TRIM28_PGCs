#!/bin/bash
#$ -N E105_ATAC_peakcall
#$ -cwd
#$ -l h_data=5G,h_rt=3:00:00
#$ -pe shared 6

source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

aligngen=/u/scratch/j/jadiruss/ATAC_new/E105/align
outgen=/u/scratch/j/jadiruss/ATAC_new/E105/peaks

threads=6

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

Genrich -t $aligngen/JAD-E105-ATAC-MWT1_genrich_namesort.bam,$aligngen/JAD-E105-ATAC-MWT2_genrich_namesort.bam,$aligngen/JAD-E105-ATAC-MWT3_genrich_namesort.bam,$aligngen/JAD-E105-ATAC-MWT4_genrich_namesort.bam -j -q 0.05 -o $outgen/E105_MWT_genrich_out.narrowPeak -f $outgen/E105_MWT_genrich_pqvalue.bed

Genrich -t $aligngen/JAD-E105-ATAC-MMUT2_genrich_namesort.bam,$aligngen/JAD-E105-ATAC-MMUT3_genrich_namesort.bam,$aligngen/JAD-E105-ATAC-MMUT4_genrich_namesort.bam,$aligngen/JAD-E105-Male-Mut5_genrich_namesort.bam,$aligngen/JAD-E105-Male-Mut7_genrich_namesort.bam -j -q 0.05 -o $outgen/E105_MMUT_genrich_out.narrowPeak -f $outgen/E105_MMUT_genrich_pqvalue.bed

Genrich -t $aligngen/JAD-E105-ATAC-FWT1_genrich_namesort.bam,$aligngen/JAD-E105-ATAC-FWT3_genrich_namesort.bam,$aligngen/JAD-E105-ATAC-FWT4_genrich_namesort.bam,$aligngen/JAD-E105-Female-WT5_genrich_namesort.bam -j -q 0.05 -o $outgen/E105_FWT_genrich_out.narrowPeak -f $outgen/E105_FWT_genrich_pqvalue.bed

Genrich -t $aligngen/JAD-E105-F-MUT1_genrich_namesort.bam,$aligngen/JAD-E105-F-MUT4_genrich_namesort.bam,$aligngen/JAD-E105-Female-Mut5_genrich_namesort.bam,$aligngen/JAD-E105-Female-Mut6_genrich_namesort.bam -j -q 0.05 -o $outgen/E105_FMUT_genrich_out.narrowPeak -f $outgen/E105_FMUT_genrich_pqvalue.bed
