\name{CENTREprecomputed}
\alias{CENTREprecomputed}
\docType{data}
\title{
SQLite Database PrecomputedDataLight.db
}
\description{
The PrecomputedDataLight.db contains the fisher combined p-value and the 
correlation between CRUP-PP and -EP scores for every enhancer-target (ET) pair
at 500kb.

}
\details{
The combined p-value is computed from the p-values of four wilcoxon-rank sum tests
for each ET. The four tests are on the CAGE-seq dataset, the DNAse-hypersensitive
region dataset, the DNAse-seq-gene expression dataset and the CRUP-EP-gene 
expression dataset.

For more information check the CENTRE article in references
}
\source{
\url{http://owww.molgen.mpg.de/~CENTRE_data/CENTREexperimentData/PrecomputedDataLight.db}
}

\references{Trisevgeni Rapakoulia, Sara Lopez Ruiz De Vargas, Persia Akbari Omgba, 
Verena Laupert, Igor Ulitsky, Martin Vingron, CENTRE: a gradient boosting 
algorithm for Cell-type-specific ENhancer-Target pREdiction, 
Bioinformatics, Volume 39, Issue 11, November 2023, btad687, 
\url{https://doi.org/10.1093/bioinformatics/btad687}}


\examples{
\dontrun{
hub <- ExperimentHub()
eh <- query(hub, "CENTREprecomputed")
eh[["EH9540"]] ## PrecomputedData database
}
}

