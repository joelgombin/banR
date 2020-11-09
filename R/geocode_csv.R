

#' Geocode French addresses using a CSV file
#'
#' @param file the path of the csv file containing the addresses.
#' @param ... additional arguments provided by the API.
#'
#' @return a tibble with geocoded addresses among other related information
#' @export
#'
#' @examples
#'
#' # Downloading the example csv file provided in the API website
#'
#' download.file("https://adresse.data.gouv.fr/exemples/search.csv", "search.csv")
#'
#' # using this csv file
#'
#' geocode_csv("search.csv")
#'
#'
#'

geocode_csv <- function(file, ...){

  api_url <- "https://api-adresse.data.gouv.fr/search/csv/"

  resp <- httr::POST(
    url = api_url,
    body = list(
      data = httr::upload_file(file, type = "csv"),
      ...
    ),

    encode = "multipart"
  )

  return(httr::content(resp, "parsed"))




}

