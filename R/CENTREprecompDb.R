#' @name CENTREprecompDb
#'
#' @import BiocGenerics
#'
#' @title Database for the CENTRE precomputed data
#'
#' @aliases CENTREprecompDb-class show dbconn,CENTREprecompDb-method show,CENTREprecompDb-method
#'
#' @description
#'
#' `CENTREprecompDb` objects provide access to general (metabolite) compound
#' annotations along with *metadata* information such as the annotation's
#' source, date and release version. The data is stored internally in a
#' database (usually an SQLite database).
#'
#' @details
#'
#' `CENTREprecompDb` objects should be created using the constructor function
#' `CENTREprecompDb()` providing the name of the (SQLite) database file providing
#' the compound annotation data.
NULL
setClassUnion("DBIConnectionOrNULL", c("DBIConnection", "NULL"))

#' @importFrom methods new
#'
#' @exportClass CENTREprecompDb
.CENTREprecompDb <- setClass("CENTREprecompDb",
                    slots = c(dbcon = "DBIConnectionOrNULL",
                              .properties = "list",
                              dbname= "character",
                              dbflags = "integer"),
                    prototype = list(.properties = list(),
                                     dbcon = NULL,
                                     dbname = character(),
                                     dbflags = 1L))


#' @importFrom methods validObject
setValidity("CENTREprecompDb", function(object) {
  con <- .dbconn(object)
  if (!is.null(con)) {
    if (length(.dbname(object)))
      on.exit(dbDisconnect(con))
  } else TRUE
})

#' @export
#'
#' @importFrom RSQLite SQLITE_RO
#'
#' @rdname CENTREprecompDb
CENTREprecompDb <- function(x, flags = SQLITE_RO) {
  if (missing(x))
    stop("Argument 'x' is required and should be either a connection to ",
         "the database or, for SQLite, the database file.")
  if (is.character(x))
    return(.initialize_compdb(.CENTREprecompDb(dbname = x, dbflags = flags)))
  if (is(x, "DBIConnection"))
    return(.initialize_compdb(.CENTREprecompDb(dbcon = x, dbflags = flags)))
  stop("'x' should be either a connection to a database or a character ",
       "specifying the (SQLite) database file.")
}

.initialize_compdb <- function(x) {
  con <- .dbconn(x)
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


.dbflags <- function(x) {
  if (.hasSlot(x, "dbflags"))
    x@dbflags
  else 1L
}

.dbconn <- function(x) {
  if (length(.dbname(x))){
    print("Connecting")
    dbConnect(dbDriver("SQLite"), dbname = x@dbname, flags = .dbflags(x))
  }
    
  else x@dbcon
}

.dbname <- function(x) {
  if (.hasSlot(x, "dbname"))
    x@dbname
  else character()
}


#' @description Get a list of all tables and their columns.
#'
#' @param x `CompDb` object.
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
#' @rdname CompDb
tables <- function(x) {
  .tables(x)
}

.get_property <- function(x, name) {
  x@.properties[[name]]
}

