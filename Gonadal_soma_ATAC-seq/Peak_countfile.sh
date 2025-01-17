#!/bin/bash
#$ -N Cat_peaks_RPKM
#$ -cwd
#$ -l h_data=5G,h_rt=3:00:00
#$ -pe shared 6

source ~/.bashrc

module load bedtools/2.30.0
module load python/3.6.8

peaks_m=/u/scratch/j/jadiruss/soma/male_soma/peaks
peaks_f=/u/scratch/j/jadiruss/soma/female_soma/peaks
peaks=/u/scratch/j/jadiruss/soma/combined_peaks
bw_m=/u/scratch/j/jadiruss/soma/male_soma/bw
bw_f=/u/scratch/j/jadiruss/soma/female_soma/bw
genome=/u/home/j/jadiruss/project-clarka/Genomes/mm39_STAR/TE

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

#Combine peak files from all of the conditions from which we have called peaks.
cat $peaks_m/E105_Male_soma_genrich_out.narrowPeak $peaks_m/E135_Male_soma_genrich_out.narrowPeak \
$peaks_f/E105_Female_soma_genrich_out.narrowPeak $peaks_f/E135_Female_soma_genrich_out.narrowPeak > $peaks/all_peaks_cat.narrowPeak

#sort so that the narrowPeak file is accessible to bedtools suite

bedtools sort -i $peaks/all_peaks_cat.narrowPeak > $peaks/all_peaks_sort.narrowPeak

#Remove peaks which are duplicated between any conditions in the concatenated file

bedtools merge -d 10 -i $peaks/all_peaks_sort.narrowPeak > $peaks/all_peaks_merge.narrowPeak

#Add RPKM values for all of the DNAse replicates. RPKMs are from merged BAM files converted to bigWig

multiBigwigSummary BED-file -b $bw_m/E105_Male_RPKM_bs10.bw $bw_f/E105_Female_Soma_RPKM_bs10.bw $bw_m/E135_Male_RPKM_bs10.bw $bw_f/E135_Female_Soma_RPKM_bs10.bw \
-o $peaks/ATAC_soma_allpeaks_matrix.npz --BED $peaks/all_peaks_merge.narrowPeak -p 6 --outRawCounts $peaks/ATAC_soma_allpeaks.tsv

#Finally, check the intersection of the merged and RPKM-peaks with LTR, LINE and SINEs from mm39

bedtools intersect -a $peaks/ATAC_soma_allpeaks.tsv. -b $genome/mm39_rpt_dupID_LTRLINESINE.bed -wo -f 0.2 > $peaks/RPKM_LTRLINESINE_peaks_ATAC_soma.tsv
