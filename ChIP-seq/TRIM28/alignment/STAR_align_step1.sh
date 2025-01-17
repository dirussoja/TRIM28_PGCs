#!/bin/bash
#$ -N TRIM28_ChIP_mm39
#$ -cwd
#$ -l h_data=10G,h_rt=8:00:00
#$ -t 1-8:1
#$ -pe shared 6

source ~/.bashrc

module load java/jre-1.8.0_281
module load samtools/1.11
module load picard_tools/2.25.0
module load python/3.9.6
module load star/2.7.9a

fqs=(
E125-ChIP-Female-1
E125-ChIP-Female-2
E125-ChIP-Female-Inp-1
E125-ChIP-Female-Inp-2
E125-ChIP-Male-1
E125-ChIP-Male-2
E125-ChIP-Male-Inp-1
E125-ChIP-Male-Inp-2
)

threads=6

genome=/u/home/j/jadiruss/project-clarka/Genomes/mm39_STAR_noGTF
reads=/u/scratch/j/jadiruss/TRIM28_ChIP_DEseq2/trim
outdir=/u/scratch/j/jadiruss/TRIM28_ChIP_DEseq2/summaries
readsout=/u/scratch/j/jadiruss/TRIM28_ChIP_DEseq2/align


#first, align using STAR. 

for fq in "${fqs[@]}"; do
    if [ $COUNT -eq $SGE_TASK_ID ]; then
    
source ~/.bashrc

STAR --genomeDir $genome \
  --readFilesCommand zcat \
  --readFilesIn $reads/$fq"-L1_val_1.fq.gz",$reads/$fq"-L2_val_1.fq.gz",$reads/$fq"-L3_val_1.fq.gz",$reads/$fq"-L4_val_1.fq.gz" $reads/$fq"-L1_val_2.fq.gz",$reads/$fq"-L2_val_2.fq.gz",$reads/$fq"-L3_val_2.fq.gz",$reads/$fq"-L4_val_2.fq.gz" \
  --outFilterMultimapNmax 1000 \
  --outFilterMismatchNmax 3 \
  --alignIntronMax 1 \
  --outSAMmultNmax 1 \
  --outSAMtype BAM SortedByCoordinate \
  --runThreadN $threads \
  --alignEndsType EndToEnd \
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

#write read stats to file.

mkdir $outdir/$fq

samtools flagstat $readsout/$fq"_STAR_nmulti1_Aligned.sortedByCoord.out.bam" > $outdir/$fq/$fq"_STAR_sorted_nmulti1_summary.txt"
samtools flagstat $readsout/$fq"_STAR_sorted_unique.bam" > $outdir/$fq/$fq"_STAR_sorted_unique_summary.txt"
samtools flagstat $readsout/$fq"_STAR_sorted_unique_rmdup_sorted.bam" > $outdir/$fq/$fq"_STAR_sorted_unique_rmdup_sorted_summary.txt"
samtools flagstat $readsout/$fq"_STAR_sorted_nmulti1_rmdup_sorted.bam" > $outdir/$fq/$fq"_STAR_sorted_nmulti1_rmdup_sorted_summary.txt"

fi;
    COUNT=$[COUNT+1];
done;
