#' Write tempfile
#'
#' @param data a data frame
#' @param adresses name of the address column 
#' @param code_insee name of insee code column 
#' @param code_postal name of the postal code column
#'
#' @return path to the temp file
#' @export
#'
#' @examples
#' \dontrun{
#' table_test <- tibble::tibble(
#' x = c("39 quai André Citroën", "64 Allée de Sully", "20 avenue de Ségur"), 
#' y = c("75015", "75012", "75007"), 
#' z = rnorm(3)
#' )
#' 
#' write_tempfile(data = table_test, adresse = x, code_insee = y)
#' write_tempfile(data = table_test, adresse = x)
#' 
#' temp_file <- write_tempfile(data = table_test, adresse = x)
#' file.size(temp_file)
#' utils:::format.object_size(file.size(temp_file), "MB")
#' }
#' 
#' 
write_tempfile <- function(data, adresse, code_insee = NULL, code_postal = NULL) {

  tmp <- paste0(tempfile(), ".csv")
  
  vars <- list(
    "adresse" = dplyr::enquo(adresse), 
    "code_postal" = dplyr::enquo(code_postal), 
    "code_insee" = dplyr::enquo(code_insee)
  ) %>%
  purrr::keep(.p = function(x) {(x != ~NULL)})
  
  dplyr::select(.data = data, !!! vars) %>%
    readr::write_csv(path = tmp)
  
  return(tmp)
  
}

#' Post Request
#'
#' @param data 
#' @param adresses 
#' @param code_insee 
#' @param code_postal
#'
#' @return results of a request
#' @export
#'
#' @examples
#' 
post_request <- function(tempfile, adresse, code_insee = NULL, code_postal = NULL) {
  
  base_url  <- "http://api-adresse.data.gouv.fr/search/csv/"
  
  body <- list(
    columns = enquo(adresse), 
    citycode = enquo(code_insee),
    postalcode = enquo(code_postal)
  ) %>% 
    purrr::keep(.p = function(x) {(x != ~NULL)}) %>%
    plyr::llply(.fun = quo_name)
  
  body$data <- httr::upload_file(path = tempfile)
  body$delimiter <- "," 
  
  query_results <-httr::POST(
    base_url, 
    body = body
  )
  
  message(httr::status_code(query_results))
  
  return(query_results)
  
}

#' Geocode df
#'
#' @param data 
#' @param adresses 
#' @param code_insee 
#' @param code_postal
#'
#' @return a tibble
#' @export
#'
#' @examples
#' 
#' \dontrun{
#' geocode_df(data = table_test, adresses = adresse)
#' }
#' 
geocode_df <- function(data, adresses, code_insee = NULL, code_postal = NULL) {
  
  tmp_file <- write_tempfile(data, adresses = adresses, code_insee = code_insee, code_postal = code_postal)
  
  results <- post_request(
    data = tmp_file, 
    adresses = adresses, 
    code_insee = code_insee, 
    code_postal = code_postal)
  
  table_results <- httr::content(results)
  
  return(table_results)
}

