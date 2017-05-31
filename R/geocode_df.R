
#' write_tempfile
#'
#' @param data a data frame
#' @param adresses name of the address column (as a string)
#' @param code_insee name of insee code column (as a string)
#' @param code_postal name of the postal code column
#'
#' @return path to the temp file
#' @import rlang 
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
write_tempfile <- function(data, adresses, code_insee, code_postal) {
  
  if (missing(code_insee) & missing(code_postal)) {
    cols <- enquo(adresses)
  } else if (missing(code_postal)) {
    cols <-  c(enquo(adresses), enquo(code_insee))
  } else if (missing(code_insee)) {
    cols <-  c(enquo(adresses), enquo(code_postal))
  }
  
  
  tmp <- paste0(tempfile(), ".csv")
  
  data %>% 
    dplyr::select_at(dplyr::vars(UQS(cols)))  %>% 
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
post_request <- function(data, adresses, code_insee, code_postal) {
  
  base_url  <- "http://api-adresse.data.gouv.fr/search/csv/"
  
  body <- list(
    data = httr::upload_file(data), 
    columns = adresses, 
    delimiter = ","
  )
  
  if (!missing(code_insee)) {
    body$citycode <- code_insee
  }
  
  if (!missing(code_postal)) {
    body$postcode <- code_postal
  }
  
  query_results <- httr::POST(
    base_url, 
    body = body
  )
  
  message(httr::status_code(query_results))
  
  return(query_results)
  
}

#' Geocode df
#'
#' @inheritDotParams write_tempfile
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
geocode_df <- function(...) {
  
  args <- quos(...)
  
  tmp_file <- write_tempfile(UQS(args))
  
  results <- post_request(
    data = tmp_file, 
    UQS(args))
  
  table_results <- httr::content(results)
  
  return(table_results)
}

