library("banR")
library("dplyr")
context("Geocode tbl")

test_that(
  "Geocode tbl works ", {
  table_test <- tibble::tibble(
    x = c("39 quai André Citroën", "64 Allée de Bercy", "20 avenue de Ségur"), 
    y = c("75015", "75012", "75007"), 
    z = rnorm(3)
  )
  expect_is(banR::geocode_tbl(tbl = table_test, adresse = x), "tbl_df")
  expect_is(banR::geocode_tbl(tbl = table_test, adresse = x, code_postal = y), "tbl_df")
  }
  )

test_that("Input and output DFs have a similar number of rows", {
  # test introduit suite à issue #3
  table_test <- data.frame(
    adresses = c("11 allée Sacoman", "11 allée Sacoman", "23 allée Sacoman"),
    code_insee = "13216",
    stringsAsFactors = FALSE
    )
  
  table_results <- banR::geocode_tbl(tbl = table_test, adresse = adresses, code_insee = code_insee)
  expect_equal(nrow(table_test), nrow(table_results))
  }
)

test_that("Geocode_tbl works with a single-column input data.frame", {
  table_test <- data.frame(
    ville = c("Agen", "Ajaccio"),
    stringsAsFactors = FALSE
    )
  expect_is(banR::geocode_tbl(tbl = table_test, adresse = ville), "tbl_df")
  }
  )
