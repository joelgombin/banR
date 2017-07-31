library("banR")
library("dplyr")
context("Geocode")

test_that(
  desc = "Geocode works",
  code = {
    expect_is(geocode(query = "39 quai André Citroën Paris"), "tbl_df")
  }
)
