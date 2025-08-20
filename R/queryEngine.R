## A very simple query engine for the CENTREannotation package based on the
## CompDb package adapted to CENTREannotation

#' @description
#'
#' Creates a SQL query for the `CENTREprecomputed` database
#' given the provided column names, filter and column filter.
#'
#' @param x `CENTREprecompDb`
#' @param columns Columns to select. Equivalent to X in SELECT X
#' @param entries Element ID to select. Equivalen to ID in SELECT X FROM TABLE
#' WHERE ID in Z.
#' @param column_filter Column on which to apply entries. Equivalent to Z in
#' SELECT X FROM TABLE WHERE Z in .
#' @details
#'
#' + Check first that the `columns` are valid
#' + Fetch the data based on entries and column on which to entries.
#'
#' @md
#' @references Based on CompoundDb package query engine internal functions.
#' @noRd
.build_query <- function(x, table, columns, entries, column_filter) {
    # check columns exist in db
    tbls <- .tables(x)
    col_m <- columns[!columns %in% unique(unlist(tbls, use.names = FALSE))]
    msg <- paste(col_m, collapse = ", ")
    if (length(col_m != 0)) {
        stop(
            "Columns ", msg,
            " are not present in the database. Use 'tables' to list ",
            "all tables and their columns."
        )

    }

    #check tables exist
    table_m <- table[!table %in% names(tbls)]
    if (length(table_m != 0)) {
        stop(
            "Table ", table_m,
            " is not present in the database. Use 'tables' to list ",
            "all tables and their columns."
        )
    }


    paste0(
        paste0("select ", paste0(columns, collapse = ",")),
        paste0(" from ", table),
        .where(entries, column_filter)
    )
}




#' @description
#'
#' Create the *where* condition for the SQL query based on the provided
#' filter column
#'
#' @md
#'
#' @noRd
.where <- function(entries, column_filter) {
    if (!missing(column_filter)) {
        paste0(
            " where ", column_filter, " in (",
            paste0(sprintf("'%s'", entries), collapse = ", "), ")"
        )
    }
}

#' @name fetch_data_precomp
#'
#' @title Fetch data from the CENTREprecompDb database
#'
#' @description
#' Function to fetch data from the CENTREprecomputed package database
#' through the `CENTREprecompDb` object.
#'
#' @param x `CENTREprecompDb` object.
#' @param table Table of the database on which to search.
#' Can be combinedTestData or cor_CRUP.
#' @param columns Columns to select. Equivalent to X in SELECT X.
#' @param entries Element ID to select. Equivalen to ID in SELECT X FROM TABLE
#' WHERE ID in Z. If entries or column_filter is missing the program assumes the
#' query is SELECT X FROM TABLE.
#' @param column_filter Column on which to apply filter. Equivalent to Z in
#' SELECT X FROM TABLE WHERE ID in Z. If entries or column_filter is missing the
#' program assumes the query is SELECT X FROM TABLE.
#'
#' @references Based on the package CompoundDb query engine internal functions.
#'
#' @seealso `vignette("CENTREprecomputed")`
#'
#' @return data.frame with the data queried.
#'
#' @examples
#' eh <- ExperimentHub::ExperimentHub()
#' centreprecompdb <- eh[["EH9540"]]
#'
#' res <- fetch_data_precomp(centreprecompdb,
#'     table = "crup_cor",
#'     columns = c("pair", "cor_CRUP"),
#'     entries = "EH38E3440167",
#'     column_filter = "symbol38"
#' )
#' @export
fetch_data_precomp <- function(x, table, columns, entries, column_filter) {
    if (missing(x)) {
        stop(" 'x' is required")
    }
    if (missing(columns)) {
        stop("'columns' is required")
    }
    if (missing(table)) {
        stop("'table' is required")
    }
    
    #fill the CENTREprecompdb slots
    x <- CENTREprecompDb(x@conn)
    con <- .dbconn(x) #connect to database to retrieve records
    if (length(.dbname(x)) && !is.null(con)) {
        on.exit(dbDisconnect(con))
    }
    query <- .build_query(x,
                          table = table,
                          columns = columns,
                          entries = entries,
                          column_filter = column_filter
    )
    data <- dbGetQuery(con, query)
    return(data)
}


