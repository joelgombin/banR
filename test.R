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
  keep(.p = function(x) {(x != ~NULL)})
  
}
f1(data = table_test, adresse = x, code_insee = y) 

f1 <- function(data, adresse, code_insee = NULL, code_postal = NULL) {
  
  vars <- list(
    "adresse" = enquo(adresse), 
    "code_postal" = enquo(code_postal), 
    "code_insee" = enquo(code_insee)
    ) %>%
    keep(.p = function(x) {(x != ~NULL)})
  
  select(.data = data, !!! vars)  
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

table_test <- tibble::tibble(
  x = c("39 quai André Citroën", "64 Allée de Sully", "20 avenue de Ségur"), 
  y = c("75015", "75012", "75007"), 
  z = rnorm(3)
)
write_tempfile(data = table_test, adresse = x)

readr::read_csv(file = "/var/folders/rv/yt271f0523s3vmqt3p8zzr9h0000gn/T//RtmpRCe7Yk/file64ac5b68cd.csv")

library("dplyr")  

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
body$data = httr::upload_file(path = "/var/folders/rv/yt271f0523s3vmqt3p8zzr9h0000gn/T//RtmpRCe7Yk/file64a79526e2f.csv")
body
body$delimiter = ","
httr::POST(url = "http://api-adresse.data.gouv.fr/search/csv/", body = body) %>% httr::content()

write_tempfile(data = table_test, adresse = x) 
readr::
post_request(
  tempfile = "/var/folders/rv/yt271f0523s3vmqt3p8zzr9h0000gn/T//RtmpRCe7Yk/file64a79526e2f.csv", 
  adresse = x
  )


geocode_df <- function(data, adresse, code_insee = NULL, code_postal = NULL) {
  
  tmp <- paste0(tempfile(), ".csv")
    
  vars <- list(
    "adresse" = dplyr::enquo(adresse), 
    "code_postal" = dplyr::enquo(code_postal), 
    "code_insee" = dplyr::enquo(code_insee)
    ) %>%
    purrr::keep(.p = function(x) {(x != ~NULL)})
    
  dplyr::select(.data = data, !!! vars) %>%
    readr::write_csv(path = tmp)
  
  base_url  <- "http://api-adresse.data.gouv.fr/search/csv/"
  
  body <- list(
    columns = enquo(adresse), 
    citycode = enquo(code_insee),
    postalcode = enquo(code_postal)
    ) %>% 
    purrr::keep(.p = function(x) {(x != ~NULL)}) %>%
    plyr::llply(.fun = quo_name)
  
  body$data <- httr::upload_file(path = tmp)
  body$delimiter <- "," 
  
  query_results <- httr::POST(
    url = base_url, 
    body = body
    )
  
  message(httr::status_code(query_results))
  table_results <- httr::content(query_results)
  
  return(table_results)
  
}

geocode_df(data = table_test, adresse = x, code_postal = y)

  results <- post_request(
    data = tmp_file, 
    adresses = adresses, 
    code_insee = code_insee, 
    code_postal = code_postal)
  
  
  return(table_results)

  }

f2(
  tempfile = "/var/folders/rv/yt271f0523s3vmqt3p8zzr9h0000gn/T//RtmpRCe7Yk/file64ac5b68cd.csv", 
  adresse = x
  )

 httr::POST(
    base_url, 
    body = body
  )
  
  


