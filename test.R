library("dplyr")
library("rlang")
library("banR")
library("tibble")
table_test <- tibble::tibble(
  x = c("39 quai André Citroën", "64 Allée de Sully", "20 avenue de Ségur"), 
  y = c("75015", "75012", "75007"), 
  z = rnorm(3)
)

geocode_tbl <- function(tbl, adresse, code_insee = NULL, code_postal = NULL) {
  
  tmp <- paste0(tempfile(), ".csv")
  message("writing to…", tmp)
  
  vars <- list(
    "adresse" = enquo(adresse), 
    "code_postal" = enquo(code_postal), 
    "code_insee" = enquo(code_insee)
    ) %>%
    purrr::keep(.p = function(x) {(x != ~NULL)})
  
  dplyr::select(.data = tbl, !!! vars) %>%
    readr::write_csv(path = tmp)

  message(
    "Size is : ", utils:::format.object_size(file.size(tmp), "MB"), "MB", 
    "\n If file is larger than 8 MB, it must be splitted"
    )
  
  tbl_temp <- dplyr::select(.data = tbl, - !!! vars)  

  body <- list(
    data = httr::upload_file(path = tmp), 
    columns = quo_name(enquo(adresse)), 
    delimiter = ","
  )
  
  print(body)  
  
  base_url  <- "http://api-adresse.data.gouv.fr/search/csv/"
  
  query_results <- httr::POST(
    url = base_url, 
    body = body
  )
  
  message(httr::http_status(query_results))
}
geocode_tbl(tbl = table_test, adresse = x)

  list(
    citycode = enquo(code_insee),
    postalcode = enquo(code_postal)
    ) %>% 
    
httr::POST(url = "http://api-adresse.data.gouv.fr/search/csv/", body = body) %>% httr::content()

geocode_df <- function(data, adresse, code_insee = NULL, code_postal = NULL) {
  

  
  table_results <- httr::content(results)

  return(table_results)
  
}


tbl_test <- tibble::tibble(x = 1:3, y = 4:6)
g0 <- function(tbl, z) {
  vars <- enquo(z)  
  select(.data = tbl, !! vars)
  }
g0(tbl = tbl_test, z = x)

g1 <- function(tbl, z) {
  g0(tbl = tbl, z = !! enquo(z))
}
g1(tbl = tbl_test, z = x)
