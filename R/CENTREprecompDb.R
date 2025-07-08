## Class definition and functions based on CoumpoundDb package.


#' @name CENTREprecompDb
#'
#' @import BiocGenerics
#' @importFrom ExperimentHub ExperimentHub
#' @title Database for the CENTRE precomputed data
#'
#' @aliases CENTREprecompDb-class show dbconn
#'
#' @description
#'
#' The `CENTREprecompDb` object provides access to CENTRE's Precomputed SQLite
#' Database PrecomputedDataLight.db. Inside the database is combinedTestData,
#' crup_cor and metadata. For more information check the
#' computeGenericFeatures() function from the CENTRE package.
#'
#' @references Based on CompoundDb::CompDb class.
#'
#' @details
#'
#' `CENTREprecompDb` is the object that provides access to CENTRE's database.
#' `tables(CENTREprecompDb)` shows the tables inside the database and
#' their columns.
#'
#' @return Object of class `CENTREprecompDb`
#'
#' @examples
#' #The object is accessed through the ExperimentHub record
#' eh <- ExperimentHub::ExperimentHub()
#' centreprecompdb <- eh[["EH9540"]]
#' tables(centreprecompdb)
#'

#'@importClassesFrom DBI DBIConnection
setClassUnion("DBIConnectionOrNULL", c("DBIConnection", "NULL"))

#' @importFrom methods new is
#'
#' @exportClass CENTREprecompDb
.CENTREprecompDb <- setClass("CENTREprecompDb",
    slots = c(
        conn = "DBIConnectionOrNULL",
        .properties = "list",
        dbname = "character",
        dbflags = "integer",
        packageName = "character"
    ),
    prototype = list(
        .properties = list(),
        conn = NULL,
        dbname = character(),
        dbflags = 1L,
        packageName = character()
    )
)

#' @importFrom methods validObject
setValidity("CENTREprecompDb", function(object) {
    con <- .dbconn(object)
    if (!is.null(con)) {
        .validCompDb(con)
    } else TRUE
})

#' @importFrom DBI dbListTables dbIsValid
.validCompDb <- function(x) {
    if (!dbIsValid(x))
        return("Database connection not available or closed.")
    tables <- dbListTables(x)
    required_tables <- c("combinedTestData", "crup_cor")
    got <- required_tables %in% tables
    if (!all(got)){
        return(paste0("Required tables ",
                      paste0("'", required_tables[!got], "'", collapse = ", "),
                      " not found in the database"))
    }
    TRUE
}

#' @param x sqlite file path
#
#' @importFrom RSQLite SQLITE_RO
#'
#' @rdname CENTREprecompDb
CENTREprecompDb <- function(x) {
    return(.initialize_centreprecompdb(.CENTREprecompDb(
        conn = x,
        dbflags = SQLITE_RO,
        packageName = "CENTREprecomputed"
    )))
}

#' @importFrom DBI dbDriver dbGetQuery dbConnect dbListTables dbDisconnect
.initialize_centreprecompdb <- function(x) {
    con <- .dbconn(x)
    x@dbname <- dbfile(con)
    if (length(.dbname(x)) && !is.null(con)) {
        on.exit(dbDisconnect(con))
    }
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
        if (length(n) && !is.null(x)) {
            on.exit(dbDisconnect(x))
        }
    }
    dbGetQuery(x, "select * from metadata")
}

.metadata_value <- function(x, key) {
    metad <- .metadata(x)
    metad[metad$name == key, "value"]
}

#' @importFrom methods .hasSlot
.dbflags <- function(x) {
    if (.hasSlot(x, "dbflags")) {
        x@dbflags
    } else {
        1L
    }
}

.dbconn <- function(x) {
    if  (!dbIsValid(x@conn)) {
        dbConnect(dbDriver("SQLite"), dbname = dbfile(x@conn), flags = .dbflags(x))
    } else {
        x@conn
    }
}

.dbname <- function(x) {
    if (.hasSlot(x, "dbname")) {
        x@dbname
    } else {
        character()
    }
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
    if (!missing(name)) {
        tbls <- tbls[name]
    }
    if (!metadata) {
        tbls <- tbls[names(tbls) != "metadata"]
    }
    tbls
}

#' @export
#'
#' @rdname CENTREprecompDb
tables <- function(x) {
    con <- .dbconn(x)
    x <- CENTREprecompDb(con)
    .tables(x)
}

.get_property <- function(x, name) {
    x@.properties[[name]]
}
