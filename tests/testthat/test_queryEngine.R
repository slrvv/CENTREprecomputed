

test_that("fetch_data works as intented", {
    
    expected <- data.frame(
        pair = c("EH38E3440167_ENSG00000000419"),
        cor_CRUP = c(-0.006860231)
    )
    fetched <- fetch_data(CENTREprecompDb,
                          table = "crup_cor",
                          columns = c("pair", "cor_CRUP"),
                          entries = "EH38E3440167_ENSG00000000419",
                          column_filter = "pair"
    )
    
    expect_equal(fetched, expected, tolerance = 1e-6)
    
    # catch error missing Db oject
    expect_error(fetch_data(
        table = "crup_cor",
        columns = c("pair", "cor_CRUP"),
        entries = "EH38E3440167",
        column_filter = "symbol38"
    ))

    #catch error missing table
    expect_error(fetch_data(CENTREprecompDb,
        columns = c("pair", "cor_CRUP"),
        entries = "EH38E3440167",
        column_filter = "symbol38"
    ))

    #catch error missing columns
    expect_error(fetch_data(CENTREprecompDb,
        table = "crup_cor",
        entries = "EH38E3440167",
        column_filter = "symbol38"
    ))
    
    # #catch error when column name doesnt exist
    expect_error(fetch_data(CENTREprecompDb,
                            table = "crup_cor",
                            columns = c("pair", "cor_CRUP", "blipblup"),
                            entries = "EH38E3440167",
                            column_filter = "symbol38"
    ))

    expect_error(fetch_data(CENTREprecompDb,
        table = "wompwomp",
        columns = c("pair", "cor_CRUP"),
        entries = "EH38E3440167",
        column_filter = "symbol38"
    ))
})
