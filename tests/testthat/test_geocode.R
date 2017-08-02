library("banR")
library("dplyr")
context("Geocode")

test_that(
  desc = "Geocode works",
  code = {
    expect_is(geocode(query = "39 quai André Citroën Paris"), "tbl_df")
  }
)

test_that(
  desc = "Reverse geocode works",
  code = {
    expect_is(reverse_geocode(long = 2.37, lat = 48.537), "tbl_df")
  }
)