library(banR)
library(dplyr)
context("geocode_df")

test_that("geocode_df works ", {
  data(paris2012)
  test_df <- paris2012 %>% slice(1:10) %>% mutate(adresse = paste(numero, voie, nom), code_insee = paste0("751", arrondissement))
  expect_message(geocode_df(test_df, "adresse", "code_insee"), regexp = "Geocoding...")
  expect_is(ban_geocode(test_df, adresse, code_insee = "code_insee"), "tbl_df")
})

test_that("input and output DFs have a similar number of rows", {
  # test introduit suite à issue #3
  df <- data.frame(adresses = c("11 allée Sacoman", "11 allée Sacoman", "23 allée Sacoman"), code_insee = "13216", stringsAsFactors = FALSE)
  result <- banR::ban_geocode(df, adresses, code_insee = "code_insee")
  expect_equal(nrow(result), nrow(df))
})

test_that("ban_geocode works with a single-column input DF", {
  df <- data.frame(ville = c("Agen", "Ajaccio"), stringsAsFactors = FALSE)
  expect_message(banR::ban_geocode(df, ville), regexp = "Geocoding...")
  expect_is(banR::ban_geocode(df, ville), "tbl_df")
})