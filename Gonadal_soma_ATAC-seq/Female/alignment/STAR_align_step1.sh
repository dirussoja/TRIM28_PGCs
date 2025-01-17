#!/bin/bash
#$ -N atac_soma_set1
#$ -cwd
#$ -l h_data=10G,h_rt=8:00:00
#$ -t 1-11:1
#$ -pe shared 6

source ~/.bashrc

module load java/jre-1.8.0_281
module load samtools/1.11
module load picard_tools/2.25.0
module load python/3.9.6
module load star/2.7.9a

fqs=(
SRR7719553
SRR7719554
SRR7719559
SRR7719560
SRR7719561
)

threads=6

genome=/u/home/j/jadiruss/project-clarka/Genomes/mm39_STAR_noGTF
reads=/u/scratch/j/jadiruss/atac_soma/reads
outdir=/u/scratch/j/jadiruss/atac_soma/summaries

readsout=/u/scratch/j/jadiruss/atac_soma/align

#first, align using STAR. Here, I have set the paramaters for single-end reads, as this is how I have processed them using SRAtoolkit.
COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then


source ~/.bashrc

STAR --genomeDir $genome \
  --readFilesCommand zcat \
  --readFilesIn $reads/$fq".fastq.gz" \
  --outFilterMultimapNmax 1000 \
  --outFilterMismatchNmax 3 \
  --alignIntronMax 1 \
  --outSAMmultNmax 1 \
  --outSAMtype BAM SortedByCoordinate \
  --runThreadN $threads \
  --outFilterMatchNminOverLread 0.2 \
  --outFileNamePrefix  $readsout/$fq"_STAR_nmulti1_"

samtools index -@ $threads $readsout/$fq"_STAR_nmulti1_Aligned.sortedByCoord.out.bam"

#remove MT reads

samtools view -h $readsout/$fq"_STAR_nmulti1_Aligned.sortedByCoord.out.bam" | \
awk '{if($3 != "MT"){print $0}}' | samtools view -Shb > $readsout/$fq"_STAR_noMT_multin1.bam"

samtools sort -@ $threads $readsout/$fq"_STAR_noMT_multin1.bam" -o $readsout/$fq"_STAR_noMT_multin1_sorted.bam"

#Unique reads Sorted

samtools view -@ $threads -q 2 -F 4 -b $readsout/$fq"_STAR_noMT_multin1_sorted.bam" | samtools sort -o $readsout/$fq"_STAR_noMT_unique_sorted.bam" -T $readsout/$fq"_STAR_noMT_unique_sorted" "-"
samtools index -@ $threads $readsout/$fq"_STAR_noMT_unique_sorted.bam"

samtools index -@ $threads $readsout/$fq"_STAR_noMT_multin1_sorted.bam"
samtools index -@ $threads $readsout/$fq"_STAR_noMT_unique_sorted.bam"

#remove PCR duplicates

java -XX:ParallelGCThreads=$threads -jar /u/home/j/jadiruss/Programs/picard/picard.jar \
MarkDuplicates I=$readsout/$fq"_STAR_noMT_unique_sorted.bam" O=$readsout/$fq"_STAR_noMT_unique_rmdup.bam" \
M=$readsout/$fq"_unique_mrkdup.txt" REMOVE_DUPLICATES=true \
CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT

java -XX:ParallelGCThreads=$threads -jar /u/home/j/jadiruss/Programs/picard/picard.jar \
MarkDuplicates I=$readsout/$fq"_STAR_noMT_multin1_sorted.bam" O=$readsout/$fq"_STAR_noMT_multin1_rmdup.bam" \
M=$readsout/$fq"_all_mrkdup.txt" REMOVE_DUPLICATES=true \
CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT

#sort and index deduplicated reads

samtools sort -@ $threads $readsout/$fq"_STAR_noMT_unique_rmdup.bam" -o $readsout/$fq"_STAR_noMT_unique_rmdup_sorted.bam"
samtools index -@ $threads $readsout/$fq"_STAR_noMT_unique_rmdup_sorted.bam"

samtools sort -@ $threads $readsout/$fq"_STAR_noMT_multin1_rmdup.bam" -o $readsout/$fq"_STAR_noMT_multin1_rmdup_sorted.bam"
samtools index -@ $threads $readsout/$fq"_STAR_noMT_multin1_rmdup_sorted.bam"

#write read statistics to file

mkdir $outdir/$fq

samtools flagstat $readsout/$fq"_STAR_nmulti1_Aligned.sortedByCoord.out.bam" > $outdir/$fq/$fq"_STAR_nmulti1_Aligned_summary.txt"
samtools flagstat $readsout/$fq"_STAR_noMT_multin1_sorted.bam" > $outdir/$fq/$fq"_STAR_noMT_multin1_sorted_summary.txt"
samtools flagstat $readsout/$fq"_STAR_noMT_unique_rmdup_sorted.bam" > $outdir/$fq/$fq"_STAR_noMT_unique_rmdup_sorted_summary.txt"
samtools flagstat $readsout/$fq"_STAR_noMT_multin1_rmdup_sorted.bam" > $outdir/$fq/$fq"_STAR_noMT_multin1_rmdup_sorted_summary.txt"
samtools flagstat $readsout/$fq"_STAR_sorted_nmulti1_rmdup_sorted.bam" > $outdir/$fq/$fq"_STAR_sorted_nmulti1_rmdup_sorted_summary.txt"

fi;
    COUNT=$[COUNT+1];
done;
