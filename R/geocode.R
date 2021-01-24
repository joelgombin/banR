
#' Get properties of a feature
#'
#' @param x a feature list
#'
#' @return a tibble
#' 

get_properties <- function(x) {
  tibble::as_tibble(
    magrittr::extract2(x, "properties")
    )
}

#' Get geometry
#'
#' @param x a feature
#'
#' @return a tibble
#' 
get_geometry <- function(x) {
  geom <- magrittr::extract2(x, "geometry")
  tibble::tibble(
    type_geo = magrittr::extract2(geom, "type"),
    longitude = magrittr::extract2(
      magrittr::extract2(geom, "coordinates"),
      1),
    latitude = magrittr::extract2(
      magrittr::extract2(geom, "coordinates"),
      2)
  )
}

#' Get features
#'
#' @param x the content of a request
#'
#' @return a tibble
#' 
get_features <- function(x) {
  dplyr::bind_cols(
    purrr::map_df(
      .x = magrittr::extract2(x, "features"),
      .f = get_properties),
    purrr::map_df(
      .x = magrittr::extract2(x, "features"),
      .f = get_geometry)
  )
}

#' Geocode
#'
#' @param query a string of the address you want to geocode
#' @param limit an integer indicating the maximum number of results wanted
#' @param autocomplete a boolean
#' @param type a string with the type of result wanted. 
#'   Default returns all results. 
#'   Can have one of the following values: "all", "housenumber", "street", "locality" or "municipality"
#'
#' @return a tibble
#' @export
#'
#' @examples
#' geocode(query = "39 quai André Citroën, Paris")
#'
geocode <- function(query,
                    limit = NULL,
                    autocomplete = NULL,
                    type = c("all", "housenumber", "street", "locality", "municipality")) {

  if (missing(type) || type == "all")
    type <- NULL

  base_url <- "http://api-adresse.data.gouv.fr/search/?q="
  get_query <- httr::GET(
    url = base_url,
    query = list(
      q = query,
      limit = limit,
      autocomplete = as.integer(autocomplete),
      type = type
    )
  )
  message(
    httr::status_code(get_query)
  )
  if (httr::status_code(get_query) == 200) {
    get_features(
      x = httr::content(get_query)
    )
  } else {
    stop("The API sent back an error ", httr::status_code(get_query))
  }
}

#' Reverse geocode
#'
#' @param long longitude
#' @param lat latitude
#'
#' @return a tibble
#' @export
#'
#' @examples
#' 
#' reverse_geocode(long = 2.37, lat = 48.357)
#' 
reverse_geocode <- function(long, lat) {

  base_url <- "http://api-adresse.data.gouv.fr/reverse/?"
  get_query <- httr::GET(paste0(base_url, "lon=", long, "&lat=", lat))

  message(httr::status_code(x = get_query))

  if (httr::status_code(x = get_query) == 200) {
    get_features(x = httr::content(get_query))
  } else {
    stop("The API sent back an error ", httr::status_code(get_query))
  }

}
