test_that("CENTREpreomputedDb obj works as intented", {
    expect_false(dbIsValid(CENTREprecompDb@conn))
    expect_true(dbIsValid(.dbconn(CENTREprecompDb@conn)))
})
