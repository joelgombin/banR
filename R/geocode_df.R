
#' write_tempfile
#'
#' @param data a data frame
#' @param adresses name of the address column (as a string)
#' @param code_insee name of insee code column (as a string)
#' @param code_postal name of the postal code column (as a string)
#'
#' @return path to the temp file
#' @export
#'
#' @examples
#' \dontrun{
#' data(paris2012)
#' table_test <- paris2012 %>%
#' slice(1:10) %>%
#' mutate(
#' adresse = paste(numero, voie, nom), 
#' code_insee = paste0("751", arrondissement)
#' )
#' write_tempfile(data = table_test, adresses = "adresse", 
#' code_insee = "code_insee")
#' write_tempfile(data = table_test, adresses = "adresse")
#' 
#' temp_file <- write_tempfile(data = table_test, adresses = "adresse")
#' file.size(temp_file)
#' utils:::format.object_size(file.size(temp_file), "MB")
#' }
#' 
write_tempfile <- function(data, adresses, code_insee = NULL, code_postal = NULL) {
  

  
  tmp <- paste0(tempfile(), ".csv")
  
  data %>% 
    dplyr::select_at(dplyr::vars(c(adresses, code_insee, code_postal)))  %>% 
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
#' \dontrun{
#' post_request(
#' data = "/tmp/RtmpQaOPOu/file2d0b69b2dc4a.csv", 
#' adresses = "adresse", 
#' code_insee = "code_insee")
#' results <- post_request(
#' data = "/tmp/RtmpQaOPOu/file2d0b69b2dc4a.csv", 
#' adresses = "adresse", 
#' code_insee = "code_insee")
#' }
#' 
post_request <- function(data, adresses, code_insee = NULL, code_postal = NULL) {
  
  base_url  <- "http://api-adresse.data.gouv.fr/search/csv/"
  
  body <- list(
    data = httr::upload_file(data), 
    columns = adresses, 
    citycode = code_insee,
    postalcode = code_postal,
    delimiter = ","
  )
  
  query_results <- httr::POST(
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
#' @import rlang
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

