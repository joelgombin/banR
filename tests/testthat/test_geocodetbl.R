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
  expect_s3_class(
    object = banR::geocode_tbl(tbl = table_test, adresse = x),
    class = "tbl_df"
    )
  expect_s3_class(
    object = banR::geocode_tbl(tbl = table_test, adresse = x, code_postal = y),
    class = "tbl_df"
    )
  }
  )

test_that("Input and output DFs have a similar number of rows", {
  # test introduit suite à issue #3
  table_test <- data.frame(
    adresses = c("11 allée Sacoman", "11 allée Sacoman", "23 allée Sacoman"),
    code_insee = "13216",
    stringsAsFactors = FALSE
    )

  table_results <- banR::geocode_tbl(
    tbl = table_test,
    adresse = adresses,
    code_insee = code_insee
    )

  expect_equal(nrow(table_test), nrow(table_results))
  }
)

test_that(
  desc = "Geocode_tbl works with a single-column input data.frame",
  code = {
    table_test <- data.frame(
      city = c("Agen", "Ajaccio"),
      stringsAsFactors = FALSE
      )
    expect_is(banR::geocode_tbl(tbl = table_test, adresse = city), "tbl_df")
    }
  )

test_that(
  desc = "Reverse geocode tbl works ",
  code = {
    table_reverse <- tibble::tibble(
      x = c(2.279092, 2.375933, 2.308332),
      y = c(48.84683, 48.84255, 48.85032),
      z = rnorm(3)
    )
    expect_s3_class(
      object = reverse_geocode_tbl(
        tbl = table_reverse, longitude = x, latitude = y),
      class = "tbl_df"
    )
  }
)

test_that(
  desc = "Code INSEE and Code postal return the same result",
  code = {
    table_check <- tibble::tribble(
      ~ num_voie, ~ cp,  ~ ville, ~ codecommune,
      "1 Rue Gaspard Monge", "22300", "Lannion", "22113",
      "Square Edouard Herriot", "85400", "Lucon", "85128"
      )

    expect_true(
      all_equal(
        geocode_tbl(
          tbl = table_check,
          adresse = num_voie,
          code_postal = cp
          ),
      geocode_tbl(
          tbl = table_check,
          adresse = num_voie,
          code_insee =  codecommune
        )
    )
  )
  }
)
