library("dplyr")
library("banR")
library("tibble")
table_test <- tibble::tibble(
  x = c("39 quai André Citroën", "64 Allée de Sully", "20 avenue de Ségur"), 
  y = c("75015", "75012", "75007"), 
  z = rnorm(3)
  )

f1 <- function(data, adresse, code_insee = NULL, code_postal = NULL) {
  vars <- enquo(adresse)
  vars
}
f1(data = table_test, adresse = x, code_postal = y)

f1 <- function(data, adresse, code_insee = NULL, code_postal = NULL) {
  vars <- enquo(adresse)
  select(.data = data, !! vars)
  }
f1(data = table_test, adresse = x, code_postal = y)

f1 <- function(data, adresse, code_insee = NULL, code_postal = NULL) {
  vars <- list(enquo(adresse), enquo(code_postal))
  vars
}
f1(data = table_test, adresse = x, code_postal = y)

f1 <- function(data, adresse, code_insee = NULL, code_postal = NULL) {
  vars <- list(
    "adresse" = enquo(adresse), 
    "code_postal" = enquo(code_postal)
    )
  select(.data = data, !!! vars)
}
f1(data = table_test, adresse = x, code_postal = y)

f1 <- function(data, adresse, code_insee = NULL, code_postal = NULL) {
  
  vars <- list(
    "adresse" = enquo(adresse), 
    "code_postal" = enquo(code_postal), 
    "code_insee" = enquo(code_insee)
  ) %>%
  purrr::keep(.p = function(x) {(x != ~NULL)})
  
}
f1(data = table_test, adresse = x, code_insee = y) 

f1 <- function(data, adresse, code_insee = NULL, code_postal = NULL) {
  
  vars <- list(
    "adresse" = enquo(adresse), 
    "code_postal" = enquo(code_postal), 
    "code_insee" = enquo(code_insee)
    ) %>%
    purrr::keep(.p = function(x) {(x != ~NULL)})
  
  dplyr::select(.data = data, !!! vars)  
}
f1(data = table_test, adresse = x, code_postal = y) 

table_test <- tibble::tibble(
  x = c("39 quai André Citroën", "64 Allée de Sully", "20 avenue de Ségur"), 
  y = c("75015", "75012", "75007"), 
  z = rnorm(3)
)

write_tempfile <- function(data, adresse, code_insee = NULL, code_postal = NULL) {
  
  tmp <- paste0(tempfile(), ".csv")
  
  vars <- list(
    dplyr::enquo(adresse), 
    dplyr::enquo(code_postal), 
    dplyr::enquo(code_insee)
  ) %>%
  purrr::keep(.p = function(x) {(x != ~NULL)})
  
  dplyr::select(.data = data, !!! vars) %>%
    readr::write_csv(path = tmp)
  
  return(tmp)
  
}


f2 <- function(adresse, code_insee = NULL, code_postal = NULL) {
  list(
    columns = enquo(adresse), 
    citycode = enquo(code_insee),
    postalcode = enquo(code_postal)
    ) %>% 
  purrr::keep(.p = function(x) {(x != ~NULL)}) %>%
  plyr::llply(.fun = quo_name)
  }
body <- f2(adresse = x, code_postal = z)
body$data = httr::upload_file(path = "/tmp/RtmpfDtsT9/file2105311d9638.csv")
body$delimiter = ","
httr::POST(url = "http://api-adresse.data.gouv.fr/search/csv/", body = body) %>% httr::content()

geocode_df <- function(data, adresse, code_insee = NULL, code_postal = NULL) {
  
  tmp_file <- write_tempfile(
    data = data, 
    adresse = !! enquo(adresse), 
    code_insee = !! enquo(code_insee), 
    code_postal = !! enquo(code_postal)
  )
  
  results <- post_request(
    tempfile = tmp_file, 
    adresse = !! enquo(adresse), 
    code_insee = !! enquo(code_insee), 
    code_postal = !! enquo(code_postal)
  )
  
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
