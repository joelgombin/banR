
#' Get properties of a feature
#'
#' @param x a feature list
#'
#' @return a tibble
#' @export
#' 
#' @examples
#' library("magrittr")
#' library("httr")
#' library("tibble")
#' library("purrr")
#' test <- "http://api-adresse.data.gouv.fr/search/?q=8 bd du port" %>% 
#' URLencode() %>% 
#' GET() %>% 
#' content()
#' feature <- extract2(test, "features")[[1]]
#' get_properties(feature)
#' map_df(.x = test$features, .f = get_properties)
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
#' @export
#' 
#' @examples
#' library("magrittr")
#' library("httr")
#' library("tibble")
#' library("purrr")
#' test <- "http://api-adresse.data.gouv.fr/search/?q=8 bd du port" %>% 
#' URLencode() %>% 
#' GET() %>% 
#' content()
#' feature <- extract2(test, "features")[[1]]
#' get_geometry(feature)
#' map_df(.x = test$features, .f = get_geometry)
#' 
get_geometry <- function(x) {
  geom <- magrittr::extract2(x, "geometry")
  tibble::tibble(
    type = magrittr::extract2(geom, "type"), 
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
#' @export
#'
#' @examples
#' library("magrittr")
#' library("httr")
#' library("tibble")
#' library("purrr")
#' test <- "http://api-adresse.data.gouv.fr/search/?q=8 bd du port" %>% 
#' URLencode() %>% 
#' GET() %>% 
#' content()
#' get_features(test)
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
#' @param query a string
#'
#' @return a tibble
#' @export
#'
#' @examples
#' geocode(query = "8 boulevard du port")
#' 
geocode <- function(query) {
  base_url <- "http://api-adresse.data.gouv.fr/search/?q=" 
  get_query <- httr::GET(utils::URLencode(paste0(base_url, query)))
  message(
    httr::status_code(get_query)
  )
  if (httr::status_code(get_query) == 200) {
    get_features(
      x = httr::content(get_query)
    )
  }
}
