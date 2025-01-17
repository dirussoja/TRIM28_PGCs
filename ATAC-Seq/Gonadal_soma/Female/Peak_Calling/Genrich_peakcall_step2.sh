#!/bin/bash
#$ -N Female_soma_peakcall
#$ -cwd
#$ -l h_data=5G,h_rt=3:00:00
#$ -pe shared 6

source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

aligngen=/u/scratch/j/jadiruss/soma/female_soma/peaks
outgen=/u/scratch/j/jadiruss/soma/female_soma/peaks

threads=6

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

Genrich -t $aligngen/SRR7719553_genrich_namesort.bam,$aligngen/SRR7719554_genrich_namesort.bam -y -j -o $outgen/E135_Female_soma_genrich_out.narrowPeak

Genrich -t $aligngen/SRR7719559_genrich_namesort.bam,$aligngen/SRR7719560_genrich_namesort.bam,$aligngen/SRR7719561_genrich_namesort.bam -y -j -o $outgen/E105_Female_soma_genrich_out.narrowPeak
