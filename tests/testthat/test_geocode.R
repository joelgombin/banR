library("banR")
library("dplyr")
context("Geocode")

test_that(
  desc = "Geocode works",
  code = {
    expect_s3_class(geocode(query = "39 quai André Citroën Paris"), "tbl_df")
  }
)

test_that(
  desc = "Reverse geocode works",
  code = {
    expect_s3_class(reverse_geocode(long = 2.37, lat = 48.537), "tbl_df")
  }
)
