################################################################################
#
# Load function
# 
################################################################################


.onLoad <- function(libname, pkgname) {
  ns <- asNamespace(pkgname)
  dataname <- "PrecomputedDataLight.db"
  dbfile <- system.file("extdata", dataname, package=pkgname, lib.loc=libname)
  db <- CENTREprecompDb(dbfile)
  objname <- "CENTREprecompDb"
  assign(objname,db, envir=ns)
  namespaceExport(ns, objname)
}

