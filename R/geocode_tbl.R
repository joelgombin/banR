#' Geocode tbl 
#'
#' Geocode tbl geocodes a whole data frame
#'
#' @param tbl a data frame or tibble
#' @param adresse adress column 
#' @param code_insee official citycode column
#' @param code_postal official postcode column
#'
#' @return an augmented data frame of classe tbl with latitude, longitude, etc
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
  message("Writing tempfile to…", tmp)

  vars <- list(
    rlang::enquo(adresse),
    rlang::enquo(code_postal),
    rlang::enquo(code_insee)
  ) %>%
  purrr::keep(.p = function(x) {
    (x != ~NULL)
    })

  dplyr::select(.data = tbl, !!! vars) %>%
    readr::write_csv(path = tmp)

  message(
    "If file is larger than 8 MB, it must be splitted\n",
    "Size is : ", file.size(tmp)
  )

  tbl_temp <- dplyr::select(.data = tbl, - !!! vars)

  body <- list(
    columns = rlang::enquo(arg = adresse),
    citycode = rlang::enquo(arg = code_insee),
    postalcode = rlang::enquo(arg = code_postal)
  ) %>%
  purrr::keep(.p = function(x) {
    (x != ~NULL)
    }) %>%
  plyr::llply(.fun = rlang::quo_name)

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
        latitude = readr::col_double(),
        longitude = readr::col_double(),
        result_label = readr::col_character(),
        result_score = readr::col_double(),
        result_type = readr::col_character(),
        result_id = readr::col_character(),
        result_housenumber = readr::col_integer(),
        result_name = readr::col_character(),
        result_street = readr::col_character(),
        result_postcode = readr::col_integer(),
        result_city = readr::col_character(),
        result_context = readr::col_character(),
        result_citycode = readr::col_character()
      )
    )

    dplyr::as_tibble(dplyr::bind_cols(tbl_temp, tbl_geocoded))

  }

}
