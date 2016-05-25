#' géocode des adresses grâce à l'API BANO
#'
#' @param data un \code{dataframe} contenant, a minima, les adresses à géocoder.
#' @param adresses nom de la colonne contenant les adresses à géocoder.
#' @param code_insee nom d'une colonne contenant le code INSEE de la commune. Si \code{NULL} (par défaut), ce paramètre n'est pas utilisé.
#' @param code_postal nom d'une colonne contenant le code postal de la commune. Si \code{NULL} (par défaut), ce paramètre n'est pas utilisé. Si \code{code_insee} et \code{code_postal} sont tous les deux fournis, seul \code{code_insee} est fourni.
#' @param URL base de l'URL de l'API à utiliser. Ne modifier qu'en cas de déploiement local ou sur un serveur distant de l'API BAN, distinct du point d'entrée offert par Etalab (\url{http://api-adresse.data.gouv.fr/}).
#'
#' @details la fonction \code{ban_search_} utilise une formule pour l'argument \code{adresses}, tandis que la fonction \code{ban_search} utilise un nom de colonne sans guillemets, à la dplyr.
#' @return un dataframe avec des colonnes supplémentaires avec la géolocalisation
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
#' ban_search(test_df, adresse, code_insee = "code_insee")
#'
ban_search_ <- function(data, adresses, code_insee = NULL, code_postal = NULL, URL = "http://api-adresse.data.gouv.fr/") {
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

  write.csv(f_eval(~ data %>% dplyr::select_(uqs(vars))), file = tmp, row.names = FALSE) # be nice with the server/bandwidth, just upload what's necessary!

  # envoyer à BANO
#   baseURL <- "http://api-adresse.data.gouv.fr/search/csv/"
  message("Geocoding...")
  body <- list(data = httr::upload_file(tmp),
               columns = as.character(adresses)[2])
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
    locations <- readr::read_csv(queryResults$content, col_types = paste0("cc", paste0(rep("?", 13), collapse = "")))
  } else {
    stop("Error on the result, error code: ", httr::status_code(queryResults))
  }

  return(suppressMessages(dplyr::left_join(data, locations)))

}

#' @rdname ban_search_
#' @export
ban_search <- function(data, adresses, code_insee = NULL, code_postal = NULL, URL = "http://api-adresse.data.gouv.fr/") {
  ban_search_(data, f_capture(adresses), code_insee = code_insee, code_postal = code_postal, URL = URL)
}
