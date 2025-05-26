## Class definition and functions based on CoumpoundDb package.


#' @name CENTREprecompDb
#'
#' @import BiocGenerics
#' @title Database for the CENTRE precomputed data
#'
#' @aliases CENTREprecompDb-class show dbconn
#'
#' @description
#'
#' The `CENTREprecompDb` object provides access to CENTRE's Precomputed SQLite 
#' Database PrecomputedDataLight.db. Inside the database is combinedTestData, 
#' crup_cor and metadata. For more information check the computeGenericFeatures()
#' function from the CENTRE package
#' 
#' @references Based on [CompoundDb::CompDb] class.
#'
#' @details
#'
#' `CENTREprecompDb` is the object that provides access to CENTRE's database.
#' `CENTREprecompDb@.properties$tables` shows the tables inside the database and
#' their columns.


setClassUnion("DBIConnectionOrNULL", c("DBIConnection", "NULL"))

#' @importFrom methods new is
#'
#' @exportClass CENTREprecompDb
.CENTREprecompDb <- setClass("CENTREprecompDb",
                    slots = c(conn = "DBIConnectionOrNULL",
                              .properties = "list",
                              dbname= "character",
                              dbflags = "integer",
                              packageName= "character"),
                    prototype = list(.properties = list(),
                                     conn = NULL,
                                     dbname = character(),
                                     dbflags = 1L,
                                     packageName = character()))


#' @param x sqlite file path
#
#' @importFrom RSQLite SQLITE_RO
#'
#' @rdname CENTREprecompDb
CENTREprecomputedDb <- function(x) {
  return(.initialize_centreprecompdb(.CENTREprecompDb(dbname = x,
                                             dbflags = SQLITE_RO,
                                             packageName = "CENTREprecomputed")))
}

#' @importFrom DBI dbDriver dbGetQuery dbConnect dbListTables dbDisconnect
.initialize_centreprecompdb <- function(x) {
  con <- .dbconn(x)
  x@conn <- con
  if (length(.dbname(x)) && !is.null(con))
     on.exit(dbDisconnect(con))
  ## fetch all tables and all columns for all tables.
  tbl_nms <- dbListTables(con)
  tbls <- lapply(tbl_nms, function(z) {
    colnames(dbGetQuery(con, paste0("select * from ", z, " limit 1")))
  })
  names(tbls) <- tbl_nms
  x@.properties$tables <- tbls
  x
}

.metadata <- function(x) {
  if (!is(x, "DBIConnection")) {
    n <- .dbname(x)
    x <- .dbconn(x)
    if (length(n) && !is.null(x))
       on.exit(dbDisconnect(x))
  }
  dbGetQuery(x, "select * from metadata")
}

.metadata_value <- function(x, key) {
  metad <- .metadata(x)
  metad[metad$name == key, "value"]
}

#' @importFrom methods .hasSlot
.dbflags <- function(x) {
  if (.hasSlot(x, "dbflags")){
    x@dbflags
  }
  else 1L
}

.dbconn <- function(x) {
  if (length(.dbname(x))){
    dbConnect(dbDriver("SQLite"), dbname = x@dbname, flags = .dbflags(x))
  }
  else x@conn
}

.dbname <- function(x) {
  if (.hasSlot(x, "dbname"))
    x@dbname
  else character()
}


#' @description Get a list of all tables and their columns.
#'
#' @param x `CENTREprecompDb` object.
#'
#' @param name optional `character` to return the table/columns for specified
#'     tables.
#'
#' @param metadata `logical(1)` whether the metadata should be returned too.
#'
#' @noRd
.tables <- function(x, name, metadata = FALSE) {
  tbls <- .get_property(x, "tables")
  if (!missing(name))
    tbls <- tbls[name]
  if (!metadata)
    tbls <- tbls[names(tbls) != "metadata"]
  tbls
}

#' @export
#'
#' @rdname CENTREprecompDb
tables <- function(x) {
  .tables(x)
}

.get_property <- function(x, name) {
  x@.properties[[name]]
}

