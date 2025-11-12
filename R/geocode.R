#' Get geometry
#'
#' @param x a feature
#' @importFrom magrittr extract2
#' @importFrom tibble tibble
#' @return a tibble
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
#' @importFrom dplyr bind_cols everything
#' @importFrom magrittr extract2
#' @importFrom purrr pluck map transpose map_df
#' @importFrom tidyr as_tibble unnest
get_features <- function(x) {
  dplyr::bind_cols(
    purrr::pluck(x, "features") %>% 
      purrr::map(~purrr::pluck(.x, "properties")) %>% 
      purrr::transpose() %>% 
      tidyr::as_tibble() %>% 
      tidyr::unnest(cols = dplyr::everything()),
    purrr::map_df(
      .x = magrittr::extract2(x, "features"),
      .f = get_geometry)
  )
}

#' Geocode
#'
#' @param query a string of the adress you want to geocode
#'
#' @return a tibble
#' @export
#'
#' @examples
#' geocode(query = "39 quai André Citroën, Paris")
#'
#' @importFrom httr GET status_code content
#' @importFrom utils URLencode
geocode <- function(query) {
  base_url <- "https://data.geopf.fr/geocodage/search/?q="
  get_query <- httr::GET(utils::URLencode(paste0(base_url, query)))
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
#' @importFrom httr GET status_code content
reverse_geocode <- function(long, lat) {

  base_url <- "https://data.geopf.fr/geocodage/reverse/?"
  get_query <- httr::GET(paste0(base_url, "lon=", long, "&lat=", lat))

  message(httr::status_code(x = get_query))

  if (httr::status_code(x = get_query) == 200) {
    get_features(x = httr::content(get_query))
  } else {
    stop("The API sent back an error ", httr::status_code(get_query))
  }

}
