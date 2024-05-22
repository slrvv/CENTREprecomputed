\name{encode.ccres.v3.HSapiens.hg38}
\alias{encode.ccres.v3.HSapiens.hg38}
\docType{data}
\title{
ENCODE Registry of cCREs V3
}
\description{
ENCODE cCREs V3 all human cCREs.
}
\format{
  A data frame with the following variables.
  \describe{
    \item{\code{chr}}{Chromosome in which the reg. element is located}
    \item{\code{start}}{Starting position of the reg. element}
    \item{\code{end}}{End postion of the reg. element}
    \item{\code{accession}}{Accession id}
    \item{\code{enhancer_id}}{ENCODE enhancer id}
    \item{\code{description}}{Type of reg. element}
    \item{\code{new_start}}{Starting position of the extended element range}
    \item{\code{new_end}}{Ending position of the extended TSS}
    \item{\code{newsize}}{Size of the extended reg. element}
    \item{\code{middle_point}}{Middle point of the extended reg. element}
  }
}
\details{
The data for ENCODE cCREs was downloaded from https://screen.encodeproject.org V3
under Downloads for all types of regulatory elements in Human.
The BED file was downloaded and we added names to the columns. The regulatory
element region was extended to a have a size of 500 and the middle point in the
new reg element range was computed.

}
\source{
https://screen.encodeproject.org
}
\examples{
library(AnnotationHub)
hub <- AnnotationHub()
ccresAnnot <- query(hub, c("CENTREannotation", "encode.ccres.v3.HSapiens.hg38"))
\dontrun{
## download resource
ccres = ccres[[1]]
}}
\keyword{AnnotationHub}

