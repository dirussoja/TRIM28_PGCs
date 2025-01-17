#!/bin/bash
#$ -N Align_2C
#$ -cwd
#$ -l h_data=10G,h_rt=10:00:00
#$ -t 1-10:1
#$ -pe shared 8

source ~/.bashrc

module load java/jre-1.8.0_281
module load samtools/1.11
module load picard_tools/2.25.0
module load python/3.9.6
module load star/2.7.9a

fqs=(
SRR2980403
SRR2980404
SRR2980405
SRR2980406
SRR2980407
SRR2980408
SRR2980409
SRR2980410
SRR2980411
SRR2980412
)

threads=8

genome=/u/home/j/jadiruss/project-clarka/Genomes/mm39_STAR
genome_te=/u/home/j/jadiruss/project-clarka/Genomes/mm39_STAR_noGTF
reads=/u/scratch/j/jadiruss/2C_RNA/fastq
readsout=/u/scratch/j/jadiruss/2C_RNA/align
counts=/u/scratch/j/jadiruss/2C_RNA/counts

#first, align using STAR. 

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then
    
source ~/.bashrc

STAR --genomeDir $genome \
  	--readFilesCommand zcat \
  	--readFilesIn $reads/$fq"_1.fastq.gz" $reads/$fq"_2.fastq.gz" \
  	--outFilterMultimapNmax 1000 \
  	--outFilterMismatchNmax 3 \
  	--alignIntronMax 1 \
  	--outSAMmultNmax 1 \
  	--outSAMtype BAM SortedByCoordinate \
  	--runThreadN $threads \
  	--outFileNamePrefix  $readsout/$fq"_STAR_"
#

samtools index -@ $threads $readsout/$fq"_STAR_Aligned.sortedByCoord.out.bam"

fi;
    COUNT=$[COUNT+1];
done;
