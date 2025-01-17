#!/bin/bash
#$ -N Fig2_TRIM_Plots
#$ -cwd
#$ -l h_data=6G,h_rt=6:00:00
#$ -pe shared 8

source ~/.bashrc

module load samtools/1.15
module load python/3.6.8

e145=/u/home/j/jadiruss/project-clarka/TRIM28/ATAC-seq/E145/bw
e105=/u/home/j/jadiruss/project-clarka/TRIM28/ATAC-seq/E105/bw
chip=/u/home/j/jadiruss/project-clarka/TRIM28/ChIP-seq/TRIM28/bw
h3k9me3=/u/home/j/jadiruss/project-clarka/TRIM28/ChIP-seq/H3K9me3/bw
beds=/u/home/j/jadiruss/project-clarka/TRIM28/ATAC-seq/Enrichment_and_H3K9me3
out=/u/scratch/j/jadiruss/Fig2_TRIM28

threads=8

source /u/home/j/jadiruss/env_python3.6.8/bin/activate

computeMatrix reference-point -S $chip/E125_M_readCount_subtract_bs10.bw $chip/E125_F_readCount_subtract_bs10.bw \
-R $beds/RPKM_E145_MMUT_LTRonly.bed $beds/RPKM_E145_FMUT_LTRonly.bed $beds/RPKM_E145_MMUT_FMUT_Specific.bed \
-p $threads -a 10000 -b 10000 --missingDataAsZero -o $out/ATAC_Catagories_E145_MUT.m

computeMatrix reference-point -S $chip/E125_M_readCount_subtract_bs10.bw $chip/E125_F_readCount_subtract_bs10.bw \
-R $beds/RPKM_E145_MWT_LTRonly.bed $beds/RPKM_E145_FWT_LTRonly.bed $beds/RPKM_E145_MWT_FWT_LTRonly.bed \
-p $threads -a 10000 -b 10000 --missingDataAsZero -o $out/ATAC_Catagories_E145_Control.m

computeMatrix reference-point -S $chip/E125_M_readCount_subtract_bs10.bw $chip/E125_F_readCount_subtract_bs10.bw \
-R $beds/RPKM_E105_MMUT_LTRonly.bed $beds/RPKM_E105_FMUT_LTRonly.bed $beds/RPKM_E105_MMUT_FMUT_Specific.bed \
-p $threads -a 10000 -b 10000 --missingDataAsZero -o $out/ATAC_Catagories_E105_MUT.m

computeMatrix reference-point -S $chip/E125_M_readCount_subtract_bs10.bw $chip/E125_F_readCount_subtract_bs10.bw \
-R $beds/RPKM_E105_MWT_LTRonly.bed $beds/RPKM_E105_FWT_LTRonly.bed $beds/RPKM_E105_MWT_FWT_LTRonly.bed \
-p $threads -a 10000 -b 10000 --missingDataAsZero -o $out/ATAC_Catagories_E105_Control.m

#For H3K9me3

computeMatrix reference-point -S $h3k9me3/E105_readCount_subtract_bs10.bw $h3k9me3/E135_M_readCount_subtract_bs10.bw $h3k9me3/E135_F_readCount_subtract_bs10.bw \
-R $beds/RPKM_E145_MMUT_LTRonly.bed $beds/RPKM_E145_FMUT_LTRonly.bed $beds/RPKM_E145_MMUT_FMUT_Specific.bed \
-p $threads -a 10000 -b 10000 --missingDataAsZero -o $out/ATAC_Catagories_H3K9me3_E145_MUT.m

computeMatrix reference-point -S $h3k9me3/E105_readCount_subtract_bs10.bw $h3k9me3/E135_M_readCount_subtract_bs10.bw $h3k9me3/E135_F_readCount_subtract_bs10.bw \
-R $beds/RPKM_E145_MWT_LTRonly.bed $beds/RPKM_E145_FWT_LTRonly.bed $beds/RPKM_E145_MWT_FWT_LTRonly.bed \
-p $threads -a 10000 -b 10000 --missingDataAsZero -o $out/ATAC_Catagories_H3K9me3_E145_Control.m

computeMatrix reference-point -S $h3k9me3/E105_readCount_subtract_bs10.bw $h3k9me3/E135_M_readCount_subtract_bs10.bw $h3k9me3/E135_F_readCount_subtract_bs10.bw \
-R $beds/RPKM_E105_MMUT_LTRonly.bed $beds/RPKM_E105_FMUT_LTRonly.bed $beds/RPKM_E105_MMUT_FMUT_Specific.bed \
-p $threads -a 10000 -b 10000 --missingDataAsZero -o $out/ATAC_Catagories_H3K9me3_E105_MUT.m

computeMatrix reference-point -S $h3k9me3/E105_readCount_subtract_bs10.bw $h3k9me3/E135_M_readCount_subtract_bs10.bw $h3k9me3/E135_F_readCount_subtract_bs10.bw \
-R $beds/RPKM_E105_MWT_LTRonly.bed $beds/RPKM_E105_FWT_LTRonly.bed $beds/RPKM_E105_MWT_FWT_LTRonly.bed \
-p $threads -a 10000 -b 10000 --missingDataAsZero -o $out/ATAC_Catagories_H3K9me3_E105_Control.m


#genome effective size is non-n bases from: http://genomewiki.ucsc.edu/index.php/Mm39_35-way_Genome_size_statistics
