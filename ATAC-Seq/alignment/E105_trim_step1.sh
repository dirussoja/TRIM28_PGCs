#!/bin/bash
#$ -N E105_ATAC_Trim
#$ -cwd
#$ -l h_data=8G,h_rt=6:00:00
#$ -t 1-24:1
#$ -pe shared 6

source ~/.bashrc
module load python/3.6.8

fqs=(
JAD-E105-ATAC-FWT1_S313_L006
JAD-E105-ATAC-FWT2_S314_L006
JAD-E105-ATAC-FWT3_S315_L006
JAD-E105-ATAC-FWT4_S316_L006
JAD-E105-ATAC-MMUT1_S310_L006
JAD-E105-ATAC-MMUT2_S311_L006
JAD-E105-ATAC-MMUT3_S66_L006
JAD-E105-ATAC-MMUT4_S312_L006
JAD-E105-ATAC-MWT1_S306_L006
JAD-E105-ATAC-MWT2_S307_L006
JAD-E105-ATAC-MWT3_S308_L006
JAD-E105-ATAC-MWT4_S309_L006
JAD-E105-Female-Mut5_S326_L006
JAD-E105-Female-Mut6_S327_L006
JAD-E105-Female-Mut7_S328_L006
JAD-E105-Female-WT5_S325_L006
JAD-E105-F-MUT1_S317_L006
JAD-E105-F-MUT2_S318_L006
JAD-E105-F-MUT3_S319_L006
JAD-E105-F-MUT4_S320_L006
JAD-E105-Male-Mut5_S321_L006
JAD-E105-Male-Mut6_S322_L006
JAD-E105-Male-Mut7_S323_L006
JAD-E105-Male-Mut8_S324_L006)

threads=6

reads=/u/scratch/j/jadiruss/E105_ATAC_STAR/reads
trim=/u/scratch/j/jadiruss/E105_ATAC_STAR/trim

readsout=/u/scratch/j/jadiruss/E105_ATAC_STAR/align

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then
 
source /u/home/j/jadiruss/env_python3.6.8/bin/activate
source ~/.bashrc

trim_galore --fastqc --clip_R1 18 --stringency 3 --length 20 -o $trim/ -j $threads --paired --nextseq 20 $reads/$fq"_R1_001.fastq.gz" $reads/$fq"_R2_001.fastq.gz"

fi;
    COUNT=$[COUNT+1];
done;
