#!/bin/bash
#$ -N DNAse_Trim
#$ -cwd
#$ -l h_data=8G,h_rt=6:00:00
#$ -t 1-20:1
#$ -pe shared 6

source ~/.bashrc
module load python/3.6.8

fqs=(
SRR6519360
SRR6519361
SRR6519362
SRR6519363
SRR6519364
SRR6519365
SRR6519367
SRR6519368
SRR6519370
SRR6519371
SRR6519372
SRR6519373
SRR6519374
SRR6519375
SRR6519376
SRR6519377
SRR6519378
SRR6519379
SRR6519380
SRR6519381
)

threads=6

reads=/u/scratch/j/jadiruss/DNase_new/reads
trim=/u/scratch/j/jadiruss/DNase_new/trim

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then
 
source /u/home/j/jadiruss/env_python3.6.8/bin/activate
source ~/.bashrc

trim_galore --fastqc --stringency 3 --length 20 -o $trim/ -j $threads $reads/$fq".fastq.gz"

fi;
    COUNT=$[COUNT+1];
done;
