#!/bin/bash
#$ -N Cat_peaks_RPKM
#$ -cwd
#$ -l h_data=5G,h_rt=3:00:00
#$ -pe shared 6

source ~/.bashrc

module load bedtools/2.30.0
module load python/3.6.8

peaks105=/u/scratch/j/jadiruss/ATAC_Alluvial_WTonly/align/E105_sort
peaks145=/u/scratch/j/jadiruss/ATAC_Alluvial_WTonly/align/E145_sort
peaks=/u/scratch/j/jadiruss/ATAC_Alluvial_WTonly/align/
bw105=/u/home/j/jadiruss/project-clarka/TRIM28/ATAC-seq/E105/bw
bw145=/u/home/j/jadiruss/project-clarka/TRIM28/ATAC-seq/E145/bw
genome=/u/home/j/jadiruss/project-clarka/Genomes/mm39_STAR/TE

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

#Combine peak files from all of the conditions from which we have called peaks.
cat $peaks105/E105_MWT_genrich_out.narrowPeak $peaks105/E105_FWT_genrich_out.narrowPeak $peaks145/E145_MWT_genrich_out.narrowPeak $peaks145/E145_FWT_genrich_out.narrowPeak > $peaks/all_peaks_cat.narrowPeak

#sort so that the narrowPeak file is accessible to bedtools suite

bedtools sort -i $peaks/all_peaks_cat.narrowPeak > $peaks/all_peaks_sort.narrowPeak

#Remove peaks which are duplicated between any conditions in the concatenated file

bedtools merge -d 10 -i $peaks/all_peaks_sort.narrowPeak > $peaks/all_peaks_merge.narrowPeak

#Add RPKM values for all of the DNAse replicates. RPKMs are from merged BAM files converted to bigWig

multiBigwigSummary BED-file -b $bw105/E105_MWT_extend_RPKM_bs10.bw $bw105/E105_FWT_extend_RPKM_bs10.bw $bw145/E145_MWT_extend_RPKM_bs10.bw $bw145/E145_FWT_extend_RPKM_bs10.bw \
-o $peaks/ATAC_allpeaks_matrix.npz --BED $peaks/all_peaks_merge.narrowPeak -p 6 --outRawCounts $peaks/all_peaks_wt_mut_ATAC.tsv

#Finally, check the intersection of the merged and RPKM-peaks with LTR, LINE and SINEs from mm39

bedtools intersect -a $peaks/all_peaks_wt_mut_ATAC.tsv -b $genome/mm39_rpt_dupID_LTRLINESINE.bed -wo -f 0.2 > $peaks/RPKM_LTRLINESINE_peaks_ATAC_wt_mut.tsv
