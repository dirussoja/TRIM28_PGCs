#!/bin/bash
#$ -N E105_ATAC_STAR_mm39
#$ -cwd
#$ -l h_data=10G,h_rt=4:00:00
#$ -t 1-24:1
#$ -pe shared 6

source ~/.bashrc

module load java/jre-1.8.0_281
module load samtools/1.11
module load picard_tools/2.25.0
module load python/3.9.6
module load star/2.7.9a

fqs=(
JAD-E105-ATAC-FWT1
JAD-E105-ATAC-FWT2
JAD-E105-ATAC-FWT3
JAD-E105-ATAC-FWT4
JAD-E105-ATAC-MMUT1
JAD-E105-ATAC-MMUT2
JAD-E105-ATAC-MMUT3
JAD-E105-ATAC-MMUT4
JAD-E105-ATAC-MWT1
JAD-E105-ATAC-MWT2
JAD-E105-ATAC-MWT3
JAD-E105-ATAC-MWT4
JAD-E105-Female-Mut5
JAD-E105-Female-Mut6
JAD-E105-Female-Mut7
JAD-E105-Female-WT5
JAD-E105-F-MUT1
JAD-E105-F-MUT2
JAD-E105-F-MUT3
JAD-E105-F-MUT4
JAD-E105-Male-Mut5
JAD-E105-Male-Mut6
JAD-E105-Male-Mut7
JAD-E105-Male-Mut8
)

threads=6

genome=/u/home/j/jadiruss/project-clarka/Genomes/mm39_STAR_noGTF
reads=/u/scratch/j/jadiruss/ATAC_new/E105/trim
outdir=/u/scratch/j/jadiruss/ATAC_new/E105/summaries

readsout=/u/scratch/j/jadiruss/ATAC_new/E105/align
peaks=/u/scratch/j/jadiruss/ATAC_new/E105/peaks

#Reads aligned using STAR. 
COUNT=1
for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then
    
source ~/.bashrc

STAR --genomeDir $genome \
  --readFilesCommand zcat \
  --readFilesIn $reads/$fq"_val_1.fq.gz" $reads/$fq"_val_2.fq.gz" \
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

#sort and index deduplicated alignments

samtools sort -@ $threads $readsout/$fq"_STAR_noMT_unique_rmdup.bam" -o $readsout/$fq"_STAR_noMT_unique_rmdup_sorted.bam"
samtools index -@ $threads $readsout/$fq"_STAR_noMT_unique_rmdup_sorted.bam"

samtools sort -@ $threads $readsout/$fq"_STAR_noMT_multin1_rmdup.bam" -o $readsout/$fq"_STAR_noMT_multin1_rmdup_sorted.bam"
samtools index -@ $threads $readsout/$fq"_STAR_noMT_multin1_rmdup_sorted.bam"

#write read stats

mkdir $outdir/$fq

samtools flagstat $readsout/$fq"_STAR_nmulti1_Aligned.sortedByCoord.out.bam" > $outdir/$fq/$fq"_STAR_nmulti1_Aligned_summary.txt"
samtools flagstat $readsout/$fq"_STAR_noMT_multin1_sorted.bam" > $outdir/$fq/$fq"_STAR_noMT_multin1_sorted_summary.txt"
samtools flagstat $readsout/$fq"_STAR_noMT_unique_rmdup_sorted.bam" > $outdir/$fq/$fq"_STAR_noMT_unique_rmdup_sorted_summary.txt"
samtools flagstat $readsout/$fq"_STAR_noMT_multin1_rmdup_sorted.bam" > $outdir/$fq/$fq"_STAR_noMT_multin1_rmdup_sorted_summary.txt"

fi;
    COUNT=$[COUNT+1];
done;
