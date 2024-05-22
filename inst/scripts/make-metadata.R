##########################################################################
##
## CENTREexperiment: Precomputed fisher p -values and bam files for CENTRE
## package
##
##########################################################################

meta <- data.frame(
	Title = c("Precomputed Fisher combined p-values and crup correlations database",
	"H3K4me3 ChIP-seq HeLa-S3 from ENCODE",
	"H3K4me1 ChIP-seq HeLa-S3 from ENCODE",
	"H3K27ac ChIP-seq HeLa-S3 from ENCODE",
	"Control ChIP-seq HeLa-S3 from ENCODE",
	"RNA-seq gene quantifications HeLa-S3 from ENCODE"),
	Description = c(paste0("Precomputed Fisher combined p-values computed "
	,"from the p-values of the accross cell-type CAGE-seq, ",
	"DNAse-hypersensitive region dataset, DNAse-seqgene expression dataset ",
	"CRUP-EP-gene expression dataset wilcoxon rank-sum tests. Additonaly, ",
	"the database contains the precomputed crup scores correlations."),
	"Example input H3K4me3 ChIP-seq HeLa-S3 from ENCODE only chr 19",
	"Example input H3K4me1 ChIP-seq HeLa-S3 from ENCODE only chr 19",
	"Example input H3K27ac ChIP-seq HeLa-S3 from ENCODE only chr 19",
	"Example input Control ChIP-seq HeLa-S3 from ENCODE only chr 19",
	"Example input RNA-seq gene quantifications HeLa-S3 from ENCODE"),
	BiocVersion = rep("3.19", 6),
	Genome = rep("GRCh38", 6), 
	SourceType = c(paste0("BED(CAGE), BED(DNAse-hypersensitive),",
	              " BED(DNAse-seq-gene), BED and TSV (CRUP-EP-gene and crup cor)"),
	              rep("BAM", 4), 
	              "TSV"),
	SourceUrl = c(paste0("https://fantom.gsc.riken.jp/5/datafiles/reprocessed/hg38_latest/extra/\n",
	                     "http://big.databio.org/papers/RED/supplement/\n",
	                     "http://big.databio.org/papers/RED/supplement/\n",
	                     "http://owww.molgen.mpg.de/~CENTRE_data/In_house_constructed_datasets.zip\n",
	                     "http://owww.molgen.mpg.de/~CENTRE_data/In_house_constructed_datasets.zip"),
	"https://www.encodeproject.org/experiments/ENCSR340WQU/",
	"https://www.encodeproject.org/experiments/ENCSR000APW/",
	"https://www.encodeproject.org/experiments/ENCSR000AOC/",
	"https://www.encodeproject.org/experiments/ENCSR000AOB/",
	"https://www.encodeproject.org/experiments/ENCSR000CPP/"),
	Species = rep("Homo sapiens", 6),
	TaxonomyId = rep(9606, 6),
	Coordinate_1_based = rep(TRUE,6), 
	DataProvider = c("FANTOM5, big.databio.org and MPI for molecular genetics",
	                 rep("ENCODE", 5)),
	Maintainer = rep("Sara Lopez <lopez_s@molgen.mpg.de>", 6) ,
	RDataClass = c("SQLiteConnection", rep("character", 5)),
	DispatchClass = c("SQLiteFile",  rep("FilePath", 5)),
	Location_Prefix = c(rep("http://owww.molgen.mpg.de/~CENTRE_data/", 6)),
	RDataPath = c("CENTREexperimentData/PrecomputedDataLight.db", 
	              "CENTREexperimentData/example/HeLa_H3K4me3.REF_chr19.bam",
	              "CENTREexperimentData/example/HeLa_H3K4me1.REF_chr19.bam",
	              "CENTREexperimentData/example/HeLa_H3K27ac.REF_chr19.bam",
	              "CENTREexperimentData/example/HeLa_input.REF_chr19.bam",
	              "CENTREexperimentData/example/HeLa-S3.tsv"),
	Tags = c(rep("ExperimentHub:ExperimentData:PackageTypeData", 6))
)

write.csv(meta, file= system.file("extdata",
                                  "metadata.csv",
                                  package = "CENTREprecomputed"),
          row.names=FALSE)
 	