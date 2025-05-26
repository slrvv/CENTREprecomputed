## A very simple query engine for the CENTREannotation package based on the 
## CompDb package adapted to CENTREannotation

#' @description
#'
#' Creates a SQL query for the `CENTREprecomputed` database
#' given the provided column names, filter and column filter.
#'
#' @param x `CENTREprecompDb`
#' @param columns Columns to select. Equivalent to X in SELECT X
#' @param filter Element ID to select. Equivalen to ID in SELECT X FROM TABLE 
#' WHERE ID in Z.
#' @param column_filter Column on which to apply filter. Equivalent to Z in 
#' SELECT X FROM TABLE WHERE ID in Z.
#' @details
#'
#' + Check first that the `columns` are valid
#' + Fetch the data based on filter and column on which to filter.
#'
#' @md
#' @references Based on [CompoundDb] query engine internal functions.
#' @noRd
.build_query <- function(x, table, columns, filter, column_filter) {
    if (missing(x))
        stop(" 'x' is required")
    if (missing(columns))
        stop("'columns' is required")
    if (missing(table))
        stop("'table' is required")

    tbls <- .tables(x)
    col_m <- columns[!columns %in% unique(unlist(tbls, use.names = FALSE))]
    msg <- paste(col_m, collapse = ", ")
    if (length(col_m != 0))
        stop("Columns ", msg,
             " are not present in the database. Use 'tables' to list ",
             "all tables and their columns.")
    paste0(paste0("select ", paste0(columns, collapse = ",")),
           paste0(" from ", table),
           .where(filter, column_filter))
}




#' @description
#'
#' Create the *where* condition for the SQL query based on the provided 
#' filter column
#'
#' @md
#'
#' @noRd
.where <- function(filter, column_filter) {
    if (!missing(column_filter)){
    paste0(" where ", column_filter , " in (",
    paste0(sprintf("'%s'", filter), collapse = ", "), ")")
}
}   

#' @name fetch_data
#'
#' @title Fetch data from the CENTREprecompDb database
#'
#' @description
#' Main interface to fetch data from the CENTREprecomputed package database 
#' through the `CENTREprecompDb` object.
#'
#' @param x `CENTREprecompDb` object.
#' @param table Table of the database on which to search. Can be combinedTestData
#' or cor_CRUP
#' @param columns Columns to select. Equivalent to X in SELECT X.
#' @param filter Element ID to select. Equivalen to ID in SELECT X FROM TABLE 
#' WHERE ID in Z. If filter or column_filter is missing the program assumes the
#' query is SELECT X FROM TABLE.
#' @param column_filter Column on which to apply filter. Equivalent to Z in 
#' SELECT X FROM TABLE WHERE ID in Z. If filter or column_filter is missing the 
#' program assumes the query is SELECT X FROM TABLE.
#' 
#' @references Based on [CompoundDb] query engine internal functions.
#' 
#' @seealso `vignette("CENTREprecomputed")`
#'
#' @examples
#'   res <- fetch_data(CENTREannotDb, 
#'                     columns=c("enhancer_id", "start"), 
#'                     filter=c("EH38E1519134","EH38E1519132") , 
#'                     column_filter="enhancer_id")
#' @export
fetch_data <- function(x, table, columns, filter, column_filter) {
    con <- .dbconn(x)
    if (length(.dbname(x)))
        on.exit(dbDisconnect(con))
    data <- dbGetQuery(con, .build_query(x,
                                         table = table,
                                         columns = columns,
                                         filter = filter,
                                         column_filter=column_filter))
    return(data)
}


