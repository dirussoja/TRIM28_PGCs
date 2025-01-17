#!/bin/bash
#$ -N E145_ATAC_STAR_mm39
#$ -cwd
#$ -l h_data=10G,h_rt=8:00:00
#$ -t 1-15:1
#$ -pe shared 6

source ~/.bashrc

module load java/jre-1.8.0_281
module load samtools/1.11
module load picard_tools/2.25.0
module load python/3.9.6
module load star/2.7.9a

fqs=(
E145-F-MUT1
E145-F-MUT2
E145-F-MUT3
E145-F-MUT4
E145-F-WT1
E145-F-WT2
E145-F-WT3
E145-F-WT4
E145-M-MUT1
E145-M-MUT2
E145-M-MUT3
E145-M-WT1
E145-M-WT2
E145-M-WT3
E145-M-WT4
)

threads=6

genome=/u/home/j/jadiruss/project-clarka/Genomes/mm39_STAR_noGTF
reads=/u/scratch/j/jadiruss/ATAC_new/E145/trim
outdir=/u/scratch/j/jadiruss/ATAC_new/E145/summaries

readsout=/u/scratch/j/jadiruss/ATAC_new/E145/align
peaks=/u/scratch/j/jadiruss/ATAC_new/E145/peaks

#first, align using STAR.

COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then
    
source ~/.bashrc

STAR --genomeDir $genome \
  --readFilesCommand zcat \
  --readFilesIn $reads/$fq"-L1_val_1.fq.gz",$reads/$fq"-L2_val_1.fq.gz",$reads/$fq"-L3_val_1.fq.gz" $reads/$fq"-L1_val_2.fq.gz",$reads/$fq"-L2_val_2.fq.gz",$reads/$fq"-L3_val_2.fq.gz" \
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

#write readstats to file

mkdir $outdir/$fq

samtools flagstat $readsout/$fq"_STAR_nmulti1_Aligned.sortedByCoord.out.bam" > $outdir/$fq/$fq"_STAR_nmulti1_Aligned_summary.txt"
samtools flagstat $readsout/$fq"_STAR_noMT_multin1_sorted.bam" > $outdir/$fq/$fq"_STAR_noMT_multin1_sorted_summary.txt"
samtools flagstat $readsout/$fq"_STAR_noMT_unique_rmdup_sorted.bam" > $outdir/$fq/$fq"_STAR_noMT_unique_rmdup_sorted_summary.txt"
samtools flagstat $readsout/$fq"_STAR_noMT_multin1_rmdup_sorted.bam" > $outdir/$fq/$fq"_STAR_noMT_multin1_rmdup_sorted_summary.txt"

fi;
    COUNT=$[COUNT+1];
done;
