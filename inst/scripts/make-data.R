##########################################################################
# CENTREprecomputed: precomputed CENTRE data and example data
#########################################################################


# PrecomputedDataLight.db

# The PrecomputedDataLight.db contains the fisher combined p-value and the 
# correlation between CRUP-PP and -EP scores for every enhancer-target (ET) pair
# at 500kb.
#
# The combined p-value is computed from the p-values of four wilcoxon-rank sum tests
# for each ET. The four tests are on the CAGE-seq dataset, the DNAse-hypersensitive
# region dataset, the DNAse-seq-gene expression dataset and the CRUP-EP-gene 
# expression dataset.
#
# Here is an explanation on the processing of each dataset. For more information
# check the CENTRE article: 
# 
# Trisevgeni Rapakoulia, Sara Lopez Ruiz De Vargas, Persia Akbari Omgba, 
# Verena Laupert, Igor Ulitsky, Martin Vingron, CENTRE: a gradient boosting 
# algorithm for Cell-type-specific ENhancer-Target pREdiction, 
# Bioinformatics, Volume 39, Issue 11, November 2023, btad687, 
# https://doi.org/10.1093/bioinformatics/btad687
#
#
##CAGE-seq dataset
#
# We downloaded the RLE normalized expression TPM tables for enhancers and genes
# from the FANTOM5 portal 
#(https://fantom.gsc.riken.jp/5/datafiles/reprocessed/hg38_latest/extra/). 
# We averaged TPM values for the enhancers and for the genes across replicates 
# resulting in 848 different CTs. We intersected cCRE-ELS with enhancer CAGE 
# peaks [findOverlaps function from GenomicRanges library (Lawrence et al. 2013)]. 
# If a cCRE-ELS region overlapped with more than one CAGE-defined enhancer, 
# we added the TPM values of the overlapped CAGE enhancers. 
# We used the Wilcoxon rank-sum test to compare the gene expression in samples 
# where the enhancer is active (TPM>0) and inactive (TPM=0).
#
##DNAse-hypersensitive region dataset
#
# We downloaded normalized counts across 112 CTs for DNase-hypersensitive 
# sites or DHSs (dhs112_v3.bed) from http://big.databio.org/papers/RED/supplement/. 
# We used UCSC liftOver (Kent 2002) to obtain the hg38 coordinates of DHSs. 
# We intersected cCRE-ELS and target regions with the DHSs [findOverlaps function 
# from GenomicRanges library (Lawrence et al. 2013)]. If cCRE-ELS and target 
# regions overlapped with more than one DHS, we added the corresponding DHSs counts.
# We ranked CTs based on the enhancer DHSs normalized counts and selected the top
# quantile (0.25) as the ones with the higher enhancer activity. 
# We then used the Wilcoxon rank-sum test to compare the target DHSs signal in 
# samples where the enhancer has higher activity than the rest of the CTs.
#
##DNAse-seq-gene expression dataset
# 
# We downloaded the normalized microarray gene expression for 112 CTs (exp112.bed)
# that match the DNAse-hypersensitive dataset from 
# http://big.databio.org/papers/RED/supplement/. We used the processed DNA-seq 
# dataset for the enhancer regions and we applied the Wilcoxon rank-sum test to 
# compare the target gene expression in samples where the enhancer has higher 
# DNAse activity (top quantile) than the rest of the CTs.
#
##CRUP-EP-gene expression dataset
# 
# We downloaded H3K4me1, H3K4me3, H3K27ac, ChIP-seq data, and RNA-seq TPM values
# for 66 matched CTs from the ENCODE portal. 
# We applied the CRUP-EP function and extracted the enhancer probabilities for 
# cCRE-ELS regions, averaging them across the five bins. If the average CRUP-EP 
# probability was >0.5, we considered the enhancer region as an active enhancer. 
# We used the Wilcoxon rank-sum test to compare the gene expression TPM values 
# in CTs where the enhancer predicted active and inactive. The CRUP-EP- gene 
# expression dataset can be found at: 
# http://owww.molgen.mpg.de/~CENTRE_data/In_house_constructed_datasets.zip.
# 
## Fisher's combined probability
# 
# We combined the four Wilcoxon rank-sum test P-values into a single P-value 
# using Fisher's method. 
# We used the negative logarithm of the combined P-value as the final 
# feature in our classification.
#
# Here is the explanation on the correlation between CRUP-PP and -EP scores:
#
# We downloaded H3K4me1, H3K4me3, H3K27ac, ChIP-seq data for 104 CTs from the 
# ENCODE portal (Supplementary Tables S2–S4). We applied CRUP-EP and CRUP-PP 
# functions in all CTs and extracted the CRUP-EP and CRUP-PP predictions for 
# cCRE-ELS and target regions, respectively. We summed the probabilities over 
# the 5-bin regions and computed the Pearson correlation coefficient across the 
# 104 CTs. The CRUP-EP- CRUP-PP dataset can be found at: 
# http://owww.molgen.mpg.de/~CENTRE_data/In_house_constructed_datasets.zip.
#

# ENCODE HeLa Example data 
# 
# For the example input data we downloaded three Histone ChIP-seq experiments 
# and Control ChIP-seq for HeLa from ENCODE. 
# We downloaded the experiments in BAM format and merged the replicates with 
# bamtools merge. We separate the chromosomes using bamtools split and used the
# files for chromosome 19.
# 
# Bamtools index was used to index the BAM files.
#
# For the RNA-seq data we use the gene quantifications in tsv format.  
# The experiment accession numbers and URL's can be found on the metadata.csv 
# file.
