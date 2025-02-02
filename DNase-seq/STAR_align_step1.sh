#!/bin/bash
#$ -N DNAse_mm39
#$ -cwd
#$ -l h_data=10G,h_rt=8:00:00
#$ -t 1-20:1
#$ -pe shared 6

source ~/.bashrc

module load java/jre-1.8.0_281
module load samtools/1.11
module load picard_tools/2.25.0
module load python/3.9.6
module load star/2.7.9a

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
SRR6519381)

threads=6

genome=/u/home/j/jadiruss/project-clarka/Genomes/mm39_STAR_noGTF
reads=/u/scratch/j/jadiruss/DNase_new/trim
outdir=/u/scratch/j/jadiruss/DNase_new/summaries

readsout=/u/scratch/j/jadiruss/DNase_new/align
peaks=/u/scratch/j/jadiruss/DNase_new/reads/peaks

#first, align using STAR. 
COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then
    
source ~/.bashrc

STAR --genomeDir $genome \
  --readFilesCommand zcat \
  --readFilesIn $reads/$fq"_trimmed.fq.gz" \
  --outFilterMultimapNmax 1000 \
  --outFilterMismatchNmax 3 \
  --alignIntronMax 1 \
  --outSAMmultNmax 1 \
  --outSAMtype BAM SortedByCoordinate \
  --runThreadN $threads \
  --outFileNamePrefix  $readsout/$fq"_STAR_nmulti1_"

samtools index -@ $threads $readsout/$fq"_STAR_nmulti1_Aligned.sortedByCoord.out.bam"

samtools view -@ $threads -q 2 -F 4 -b $readsout/$fq"_STAR_nmulti1_Aligned.sortedByCoord.out.bam" | samtools sort -o $readsout/$fq"_STAR_sorted_unique.bam" -T $readsout/$fq"_STAR_sorted_unique" "-"
samtools index -@ $threads $readsout/$fq"_STAR_sorted_unique.bam"

#remove PCR duplicates

java -XX:ParallelGCThreads=$threads -jar /u/home/j/jadiruss/Programs/picard/picard.jar \
MarkDuplicates I=$readsout/$fq"_STAR_sorted_unique.bam" O=$readsout/$fq"_STAR_sorted_unique_rmdup.bam" \
M=$readsout/$fq"_unique_mrkdup.txt" REMOVE_DUPLICATES=true \
CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT

java -XX:ParallelGCThreads=$threads -jar /u/home/j/jadiruss/Programs/picard/picard.jar \
MarkDuplicates I=$readsout/$fq"_STAR_nmulti1_Aligned.sortedByCoord.out.bam" O=$readsout/$fq"_STAR_sorted_nmulti1_rmdup.bam" \
M=$readsout/$fq"_all_mrkdup.txt" REMOVE_DUPLICATES=true \
CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT

#Sort and index deduplicated reads

samtools sort -@ $threads $readsout/$fq"_STAR_sorted_unique_rmdup.bam" -o $readsout/$fq"_STAR_sorted_unique_rmdup_sorted.bam"
samtools index -@ $threads $readsout/$fq"_STAR_sorted_unique_rmdup_sorted.bam"

samtools sort -@ $threads $readsout/$fq"_STAR_sorted_nmulti1_rmdup.bam" -o $readsout/$fq"_STAR_sorted_nmulti1_rmdup_sorted.bam"
samtools index -@ $threads $readsout/$fq"_STAR_sorted_nmulti1_rmdup_sorted.bam"

#Store read stats to file.

mkdir $outdir/$fq

samtools flagstat $readsout/$fq"_STAR_nmulti1_Aligned.sortedByCoord.out.bam" > $outdir/$fq/$fq"_STAR_sorted_nmulti1_summary.txt"
samtools flagstat $readsout/$fq"_STAR_sorted_unique.bam" > $outdir/$fq/$fq"_STAR_sorted_unique_summary.txt"
samtools flagstat $readsout/$fq"_STAR_sorted_unique_rmdup_sorted.bam" > $outdir/$fq/$fq"_STAR_sorted_unique_rmdup_sorted_summary.txt"
samtools flagstat $readsout/$fq"_STAR_sorted_nmulti1_rmdup_sorted.bam" > $outdir/$fq/$fq"_STAR_sorted_nmulti1_rmdup_sorted_summary.txt"

fi;
    COUNT=$[COUNT+1];
done;
