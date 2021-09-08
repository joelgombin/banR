#' Geocode tbl 
#'
#' Geocode tbl geocodes a whole data frame
#'
#' @param tbl a data frame or tibble
#' @param adresse adress column 
#' @param code_insee official citycode column
#' @param code_postal official postcode column
#'
#' @return an augmented data frame of class tbl with latitude, longitude, etc
#' @export 
#'
#' @examples
#' 
#' table_test <- tibble::tibble(
#' x = c("39 quai Andre Citroen", "64 Allee de Bercy", "20 avenue de Segur"), 
#' y = c("75015", "75012", "75007"), 
#' z = rnorm(3)
#' )
#' 
#' geocode_tbl(tbl = table_test, adresse = x)
#' geocode_tbl(tbl = table_test, adresse = x, code_postal = y)
#' 
geocode_tbl <- function(tbl, adresse, code_insee = NULL, code_postal = NULL) {

  tmp <- paste0(tempfile(), ".csv")
  message("Writing tempfile to...", tmp)

  vars <- list(
    rlang::enquo(adresse),
    rlang::enquo(code_postal),
    rlang::enquo(code_insee)
  ) %>%
  purrr::discard(rlang::quo_is_null)

  dplyr::select(.data = tbl, !!! vars) %>%
    dplyr::mutate({{adresse}} := stringr::str_replace({{adresse}}, "'", " ")) %>% 
    readr::write_csv(file = tmp)

  message(
    "If file is larger than 8 MB, it must be splitted\n",
    "Size is : ", format_object_size(x = file.size(tmp), units = "auto")
  )

  tbl_temp <- dplyr::select(
    .data = tbl,
    !!! purrr::map(
      .x = vars,
      .f = function(sym) {
        rlang::call2("-", sym)
        }
      )
    )

  body <- list(
    columns = rlang::enquo(arg = adresse),
    citycode = rlang::enquo(arg = code_insee),
    postcode = rlang::enquo(arg = code_postal)
  ) %>%
  purrr::discard(rlang::quo_is_null) %>%
  purrr::map(rlang::quo_name)

  body$data <- httr::upload_file(path = tmp)
  body$delimiter <- ","

  base_url  <- "http://api-adresse.data.gouv.fr/search/csv/"

  query_results <- httr::POST(
    url = base_url,
    body = body
  )

  message(httr::http_status(query_results))

  if (httr::status_code(query_results) == 200) {

    tbl_geocoded <- httr::content(
      query_results,
      encoding = "UTF-8",
      col_types = readr::cols(
        .default = readr::col_character(),
        latitude = readr::col_double(),
        longitude = readr::col_double(),
        result_label = readr::col_character(),
        result_score = readr::col_double(),
        result_type = readr::col_character(),
        result_id = readr::col_character(),
        result_housenumber = readr::col_character(),
        result_name = readr::col_character(),
        result_street = readr::col_character(),
        result_postcode = readr::col_character(),
        result_city = readr::col_character(),
        result_context = readr::col_character(),
        result_citycode = readr::col_character()
      )
    )

    dplyr::as_tibble(dplyr::bind_cols(tbl_temp, tbl_geocoded))

  } else {
    stop("The API sent back an error ", httr::status_code(query_results))
  }

}

#' Reverse geocode tbl
#'
#' reverse geocode a data frame
#' 
#' @param tbl name of the tibble
#' @param longitude name of the longitude column
#' @param latitude name of the latitude column
#'
#' @return an augmented tibble with addresses
#' @export
#'
#' @examples
#' 
#' table_reverse <- tibble::tibble(
#' x = c(2.279092, 2.375933,2.308332), 
#' y = c(48.84683, 48.84255, 48.85032), 
#' z = rnorm(3)
#' )
#' 
#' reverse_geocode_tbl(tbl = table_reverse, longitude = x, latitude = y)
#' 
reverse_geocode_tbl <- function(tbl, longitude, latitude) {

  tmp <- paste0(tempfile(), ".csv")
  message("Writing tempfile to...", tmp)

  vars <- list(
    "longitude" = rlang::enquo(longitude),
    "latitude" = rlang::enquo(latitude)
    )
  dplyr::select(.data = tbl, !!! vars) %>%
    readr::write_csv(file = tmp)

  tbl_temp <- dplyr::select(
    .data = tbl,
    !!! purrr::map(
      .x = vars,
      .f = function(sym) {
        rlang::call2("-", sym)
        })
    )

  message(
    "If file is larger than 8 MB, it must be splitted\n",
    "Size is : ", format_object_size(x = file.size(tmp), units = "auto")
  )

  body <- list(
    data = httr::upload_file(path = tmp),
    delimiter = ","
  )

  base_url  <- "https://api-adresse.data.gouv.fr/reverse/csv/"

  query_results <- httr::POST(
    url = base_url,
    body = body
  )

  message(httr::http_status(query_results))

  if (httr::status_code(query_results) == 200) {

    tbl_reverse <- httr::content(
      query_results,
      encoding = "UTF-8",
      col_types = readr::cols(
        longitude = readr::col_double(),
        latitude = readr::col_double(),
        result_latitude = readr::col_double(),
        result_longitude = readr::col_double(),
        result_label = readr::col_character(),
        result_distance = readr::col_integer(),
        result_type = readr::col_character(),
        result_id = readr::col_character(),
        result_housenumber = readr::col_character(),
        result_name = readr::col_character(),
        result_street = readr::col_character(),
        result_postcode = readr::col_character(),
        result_city = readr::col_character(),
        result_context = readr::col_character(),
        result_citycode = readr::col_character()
        )
      )

  return(
    dplyr::bind_cols(
      dplyr::as_tibble(tbl_temp),
      tbl_reverse
      )
    )
  } else {
    stop("The API sent back an error ", httr::status_code(query_results))
  }

}
