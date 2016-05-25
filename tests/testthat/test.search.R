library(banR)
library(dplyr)
context("search")

test_that("ban_search_ works ", {
  data(paris2012)
  test_df <- paris2012 %>% slice(1:10) %>% mutate(adresse = paste(numero, voie, nom), code_insee = paste0("751", arrondissement))
  expect_message(ban_search_(test_df, ~adresse, code_insee = "code_insee"), regexp = "Geocoding...")
  expect_is(ban_search_(test_df, ~adresse, code_insee = "code_insee"), "tbl_df")
})

test_that("ban_search works ", {
  data(paris2012)
  test_df <- paris2012 %>% slice(1:10) %>% mutate(adresse = paste(numero, voie, nom), code_insee = paste0("751", arrondissement))
  expect_message(ban_search(test_df, adresse, code_insee = "code_insee"), regexp = "Geocoding...")
  expect_is(ban_search(test_df, adresse, code_insee = "code_insee"), "tbl_df")
})
