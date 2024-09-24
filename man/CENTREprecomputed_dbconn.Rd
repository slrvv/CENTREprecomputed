\name{CENTREprecomputedDbconn}
\alias{CENTREprecomputedDbconn}
\alias{CENTREprecomputedDbfile}
\alias{CENTREprecomputedDbInfo}

\title{Connect and  Collect Information about the CENTREprecomputedDb}

\description{
  Some convenience functions for getting a connection object to (or collecting
  information about) the package's CENTREprecomputedDb
}

\usage{
  CENTREprecomputed_dbconn()
  CENTREprecomputed_dbfile()
  CENTREprecomputed_dbInfo()
}

\details{
  \code{CENTREprecomputedDbconn()} returns a connection object to the
  package annotation DB.  IMPORTANT: Don't call
  \code{\link[DBI:dbConnect]{dbDisconnect}} on the connection object
  returned by \code{CENTREprecomputedDbconn()} or you will break all the
  \code{\link[AnnotationDbi:AnnDbObj-class]{AnnDbObj}} objects defined
  in this package!

  \code{CENTREprecomputedDbfile()} returns the path (character string) to the
  package annotation DB (this is an SQLite file).

  \code{CENTREprecomputedDbInfo()} prints other information about the package
  annotation DB.
}

\value{
  \code{CENTREprecomputedDbconn()}: a DBIConnection object representing an
  open connection to the package annotation DB.

  \code{CENTREprecomputedDbfile()}: a character string with the path to the
  package annotation DB.

  \code{CENTREprecomputedDbInfo}: metadata on the annotation DB.
}

\seealso{
  \code{\link[DBI:dbSendQuery]{dbGetQuery}},
  \code{\link[DBI:dbConnect]{dbConnect}},
  \code{\link[AnnotationDbi:AnnDbObj-class]{dbconn}},
  \code{\link[AnnotationDbi:AnnDbObj-class]{dbfile}},
  \code{\link[AnnotationDbi:AnnDbObj-class]{dbInfo}}
}

\examples{
  library(RSQLite)
  library(CENTREprecomputed)
  ## Get the combined fisher p.value for pair EH38E3350767_ENSG00000059728
  dbGetQuery(CENTREprecomputed_dbconn(),
  "SELECT * FROM combinedTestData WHERE pair in ('EH38E3350767_ENSG00000059728')")

  CENTREprecomputed_dbInfo()
}


