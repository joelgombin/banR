

#' Inverse geocoding geographical coordinates using a csv file
#'
#' @param file the path of the csv file containing the coordinates
#' @param ... additional arguments provided by the API.
#'
#' @return a tibble with reverse geocoded coordinates among other related information
#'
#' @export
#'
#' @examples
#'
#' # Downloading the example csv file provided in the API website
#'
#' download.file("https://adresse.data.gouv.fr/exemples/reverse.csv", "reverse.csv")
#'
#' # using this csv file
#'
#' geocode_csv_reverse("reverse.csv")
#'



geocode_csv_reverse <- function(file, ...){

  api_url <- "https://api-adresse.data.gouv.fr/reverse/csv/"

  resp <- httr::POST(
    url = api_url,
    body = list(
      data = httr::upload_file(file, type = "csv"),
      encoding = "UTF-8",
      ...
    ),

    encode = "multipart"
  )

  return(httr::content(resp, "parsed"))


}



