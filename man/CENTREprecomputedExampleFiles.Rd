\name{CENTREprecomputedExampleFiles}
\alias{CENTREprecomputedExampleFiles}
\docType{data}
\title{Example of Input Data for CENTRE}
\description{
Input data from ENCODE for HeLa Cell-line: ChIP-seq for H3K4me3, H3K4me1, 
H3K27ac, Control and RNA-seq. The data is given in BAM format.BAM indexes are also 
provided in the package.
}
\source{
\url{https://www.encodeproject.org/}
}
\examples{
library(ExperimentHub)
hub <- ExperimentHub()
eh <- query(hub, "CENTREprecomputed")
eh$sourceurl # provides the exact source for each experiment
mcols(eh) #get more metadata
}
\keyword{ExperimentHub}
