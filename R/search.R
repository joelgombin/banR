#' geocoding using the French national address database (BAN)
#' http://adresse.data.gouv.fr/
#'
#' @param data a \code{dataframe} including at least one variable with addresses.
#' @param adresses name of the address column to be geocoded
#' @param code_insee name of the column including the French national code for a commune. If \code{NULL} (the default), this parameter is not used.
#' @param code_postal name of the column including  postal code. If \code{NULL} (the default), this parameter is not used. If \code{code_insee} and \code{code_postal} are provided, only \code{code_insee} is used.
#' @param URL base url of the API. This should only be modified if another endpoint than the one provided by Etalab (\url{http://api-adresse.data.gouv.fr/}) is used. 
#'
#' @details the function \code{ban_geocode_} use a formula for \code{adresses}, when the function \code{ban_geocode} works with column name without quote in the `dplyr` style.
#' @return an augmented dataframe with columns about geolocalization
#' @import lazyeval
#' @importFrom utils write.csv
#' @export
#' @examples
#' library(dplyr)
#' data(paris2012)
#' test_df <- paris2012 %>%
#'              slice(1:10) %>%
#'              mutate(adresse = paste(numero, voie, nom),
#'                     code_insee = paste0("751", arrondissement))
#' ban_geocode(test_df, adresse, code_insee = "code_insee")
#'
ban_geocode_ <- function(data, adresses, code_insee = NULL, code_postal = NULL, URL = "http://api-adresse.data.gouv.fr/") {
  # faire une sorte de test sur les adresses et éventuellement sur les IDs (??)

  # TODO : vérifier que le CSV est inférieur à 8 MO (limite de l'API)

  # sauver adresses dans un CSV pour les envoyer à l'API BANO
  tmp <- paste0(tempfile(), ".csv")
  vars <- adresses
  if (!is.null(code_insee)) {
    vars <- c(vars, code_insee)
  } else if (!is.null(code_postal)) {
    vars <- c(vars, code_postal)
  }

  write.csv(data[, vars, drop = FALSE], file = tmp, row.names = FALSE) # be nice with the server/bandwidth, just upload what's necessary!

  # envoyer à BANO
#   baseURL <- "http://api-adresse.data.gouv.fr/search/csv/"
  message("Geocoding...")
  body <- list(data = httr::upload_file(tmp),
               columns = adresses,
               delimiter = ",")
  # restriction de la requête par code insee ou code postal
  if (!is.null(code_insee)) {
    body$citycode <- code_insee
  } else if (!is.null(code_postal)) {
    body$postcode <- code_postal
  }

  URL <- paste0(URL, "search/csv/")

  queryResults <- httr::POST(URL,
                             body = body)

  # TODO : gérer les retours en erreur de l'API
  if (stringr::str_detect(queryResults$headers$`content-type`, "text/csv")) {
    locations <- readr::read_csv(queryResults$content, col_types = paste0(paste0(rep("c", 1 + sum(!is.null(code_insee), !is.null(code_postal))), collapse = ""), paste0(rep("?", 13), collapse = "")))
  } else {
    stop("Error on the result, error code: ", httr::status_code(queryResults))
  }

  return(suppressMessages(dplyr::bind_cols(tibble::as_tibble(data), locations[, -match(names(f_eval(~ data %>% dplyr::select_(uqs(vars)))), names(locations))])))

}

#' @rdname ban_geocode_
#' @export
ban_geocode <- function(data, adresses, code_insee = NULL, code_postal = NULL, URL = "http://api-adresse.data.gouv.fr/") {
  ban_geocode_(data, lazyeval::f_text(lazyeval::f_capture(adresses)), code_insee = code_insee, code_postal = code_postal, URL = URL)
}
