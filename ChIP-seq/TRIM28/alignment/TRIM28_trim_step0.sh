#!/bin/bash
#$ -N E125_TRIM_ChIP
#$ -cwd
#$ -l h_data=8G,h_rt=6:00:00
#$ -t 1-32:1
#$ -pe shared 6

source ~/.bashrc
module load python/3.6.8

fqs=(
E125-ChIP-Female-1-L1_S15_L001
E125-ChIP-Female-1-L2_S46_L002
E125-ChIP-Female-1-L3_S122_L003
E125-ChIP-Female-1-L4_S18_L004
E125-ChIP-Female-2-L1_S17_L001
E125-ChIP-Female-2-L2_S48_L002
E125-ChIP-Female-2-L3_S124_L003
E125-ChIP-Female-2-L4_S20_L004
E125-ChIP-Female-Inp-1-L1_S16_L001
E125-ChIP-Female-Inp-1-L2_S47_L002
E125-ChIP-Female-Inp-1-L3_S123_L003
E125-ChIP-Female-Inp-1-L4_S19_L004
E125-ChIP-Female-Inp-2-L1_S18_L001
E125-ChIP-Female-Inp-2-L2_S49_L002
E125-ChIP-Female-Inp-2-L3_S125_L003
E125-ChIP-Female-Inp-2-L4_S21_L004
E125-ChIP-Male-1-L1_S19_L001
E125-ChIP-Male-1-L2_S50_L002
E125-ChIP-Male-1-L3_S126_L003
E125-ChIP-Male-1-L4_S22_L004
E125-ChIP-Male-2-L1_S21_L001
E125-ChIP-Male-2-L2_S52_L002
E125-ChIP-Male-2-L3_S128_L003
E125-ChIP-Male-2-L4_S24_L004
E125-ChIP-Male-Inp-1-L1_S20_L001
E125-ChIP-Male-Inp-1-L2_S51_L002
E125-ChIP-Male-Inp-1-L3_S127_L003
E125-ChIP-Male-Inp-1-L4_S23_L004
E125-ChIP-Male-Inp-2-L1_S22_L001
E125-ChIP-Male-Inp-2-L2_S53_L002
E125-ChIP-Male-Inp-2-L3_S129_L003
E125-ChIP-Male-Inp-2-L4_S25_L004
)

threads=6

reads=/u/scratch/j/jadiruss/TRIM28_ChIP_DEseq2/reads
trim=/u/scratch/j/jadiruss/TRIM28_ChIP_DEseq2/trim

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then
 
source /u/home/j/jadiruss/env_python3.6.8/bin/activate
source ~/.bashrc

trim_galore --fastqc --stringency 3 --length 20 -o $trim/ -j $threads --paired --nextseq 20 $reads/$fq"_R1_001.fastq.gz" $reads/$fq"_R2_001.fastq.gz"

fi;
    COUNT=$[COUNT+1];
done;
