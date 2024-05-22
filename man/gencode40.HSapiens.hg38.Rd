\name{gencode40.HSapiens.hg38}
\alias{gencode40.HSapiens.hg38}
\docType{data}
\title{Genome wide GENCODE basic gene annotation hg38 version 40}
\description{
Genome wide GENCODE comprehensive basic gene annotation v40 on 
reference chromosomes only
}

\format{
  A data frame with 60574 observations and 12 variables: 
  \describe{
    \item{\code{chr}}{Chromosome in which the gene is located}
    \item{\code{start}}{Starting position of the gene}
    \item{\code{end}}{End position of the gene}
    \item{\code{gene_id}}{ENSEMBL gene id}
    \item{\code{orientation}}{+ or - strand}
    \item{\code{gene_id1}}{Gene id without version identifier}
    \item{\code{transcript_id}}{ENSEMBL transcript id}
    \item{\code{gene_name}}{Name of the gene}
    \item{\code{description}}{Type of gene}
    \item{\code{transcription_start}}{Transcription start site position of the
    gene}
    \item{\code{new_start}}{Starting position of the extended TSS. We extended the TSS to a 
          size of 499.}
    \item{\code{new_end}}{Ending position of the extended TSS}
  }
}
\details{
The data for GENCODE comprehensive gene annotation on the reference
chromosomes was downloaded from
https://www.gencodegenes.org/human/release_40.html
in GTF file format Release 40. The file was then transformed from GTF to bed
and the relevant columns where selected (chr, start, end, gene_id,
orientation, transcript_id, gene_name, description, transcription_start) and
we excluded exon annotation. The transcription start site was extended to a
size of 499 for all genes. We include the column gene_id1 which contains the
gene ID without version identifier.}
\source{
https://www.gencodegenes.org/human/release_40.html
}
\examples{
library(AnnotationHub)
hub <- AnnotationHub()
gencodeAnnot <- query(hub, c("CENTREannotation", "gencode.40.HSapiens.hg38"))
\dontrun{
## download resource
gencode = gencodeAnnot[[1]]
}}
}

\keyword{AnnotationHub}
