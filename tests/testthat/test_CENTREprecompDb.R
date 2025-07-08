test_that("CENTREpreomputedDb obj works as intented", {
    eh <- ExperimentHub::ExperimentHub() 
    centreprecompdb <- eh[["EH9540"]]
    centreprecompdb <- CENTREprecompDb(centreprecompdb@conn)
    expect_false(RSQLite::dbIsValid(centreprecompdb@conn))
    expect_true(RSQLite::dbIsValid(.dbconn(centreprecompdb)))
})
