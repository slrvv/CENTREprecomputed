test_that("CENTREpreomputedDb obj works as intented", {
    expect_false(RSQLite::dbIsValid(CENTREprecompDb@conn))
    expect_true(RSQLite::dbIsValid(.dbconn(CENTREprecompDb@conn)))
})
