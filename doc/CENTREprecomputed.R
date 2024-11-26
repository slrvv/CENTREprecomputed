## ----results='hide'-----------------------------------------------------------
library(ExperimentHub)

## ----setup--------------------------------------------------------------------
hub <- ExperimentHub()
eh <- query(hub, "CENTREprecomputed")
eh

## ----results='hide'-----------------------------------------------------------
CENTREprecomputed::CENTREprecompDb

## -----------------------------------------------------------------------------
conn <- RSQLite::dbConnect(CENTREprecomputed::CENTREprecompDb@conn)
RSQLite::dbGetQuery(conn, "SELECT * from metadata")
RSQLite::dbDisconnect(conn) # don't forget to disconnect

