#Script to download the database and generate the package

library(RSQLite)
library(DBI)


download_url <- function(url, dir_name){
  download.file(url = url, destfile = (file.path(dir_name, basename(url))))
}

create_db_connection <- function(package_location){
  return(DBI::dbConnect(RSQLite::SQLite(),file.path(package_location, "inst", "extdata",
                                                    "PrecomputedDataLight.db")))
}


# We perform all operations in a temporary directory, so cleanup is easier/automatic
tmp_dir = tempdir(check = FALSE)

# Download the sql database
mysqlite_dump_url <- "http://owww.molgen.mpg.de/~CENTRE_data/PrecomputedDataLight.db"
download_url(mysqlite_dump_url, tmp_dir)


## Create package structure
package_location = file.path(tmp_dir, "CENTREprecomputed")


dir.create(file.path(package_location, "inst", "extdata"), recursive = TRUE)
dir.create(file.path(package_location, "inst", "scripts"), recursive = TRUE)
dir.create(file.path(package_location, "man"), recursive = TRUE)
dir.create(file.path(package_location, "R"), recursive = TRUE)
dir.create(file.path(package_location, "vignettes"), recursive = TRUE)
dir.create(file.path(package_location, "tests", "testthat"), recursive = TRUE)

## Copy static files
file.copy(from = "./NAMESPACE", 
          to = file.path(package_location, "NAMESPACE"))
file.copy(from = "./DESCRIPTION", 
          to = file.path(package_location, "DESCRIPTION"), overwrite = T)
file.copy(from = "./NEWS", 
          to = file.path(package_location, "NEWS"), overwrite = T)
file.copy(from = "./tests/testthat.R", 
          to = file.path(package_location, "tests/testthat.R"))
file.copy(from = "./inst/extdata/metadata.csv", 
          to = file.path(package_location, "inst/extdata/metadata.csv"))
file.copy(from = "./vignettes/CENTREprecomputed.Rmd", 
          to = file.path(package_location, "vignettes/CENTREprecomputed.Rmd"))


file.copy(from = list.files("inst/scripts", "+?\\.R$", full.names = TRUE),
          to = file.path(package_location, "/inst/scripts"))
file.copy(from = list.files("R", "+?\\.R$", full.names = TRUE),
          to = file.path(package_location, "/R"))
file.copy(from = list.files("man", "+?\\.Rd$", full.names = TRUE),
          to = file.path(package_location, "/man"), overwrite = T)
file.copy(from = list.files("tests/testthat", "+?\\.R$", full.names = TRUE),
          to = file.path(package_location, "/tests/testthat"), overwrite = T)



# Copy the sqlite into the package
file.copy(from = file.path(tmp_dir, "PrecomputedDataLight.db"), 
          to = file.path(package_location, "inst", "extdata",
                         "PrecomputedDataLight.db"),
          overwrite = TRUE)


metadata <- data.frame(
  name = c(
    "source_name",
    "source_url",
    "source_date",
    "organism",
    "Db type",
    "supporting_package",
    "supporting_object"
  ),
  value = c(
    "CENTREprecomputed",
    "http://owww.molgen.mpg.de/~CENTRE_data/CENTREexperimentData/PrecomputedDataLight.db",
    Sys.Date(),
    "HSapiens",
    "CENTREprecompDb",
    "CENTREprecomputed",
    "CENTREprecompDb"
  )
)



precomp_conn <- create_db_connection(package_location)
dbWriteTable(precomp_conn, "metadata", metadata, overwrite = T)
dbGetQuery(precomp_conn, "SELECT * from metadata")
dbDisconnect(precomp_conn)

#build package tarbal in tmp directory
system(paste0("cd ", package_location, "; R CMD build --resave-data=best ", package_location))
system(paste0("cd ", package_location, "; R CMD check ", paste0(package_location, "/CENTREprecomputed_0.99.0.tar.gz")))

