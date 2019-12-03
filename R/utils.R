#' Format object size
#'
#' This function is modified copy of the utils:::format.object_size 
#' function which is not exported. 
#' The main difference is that it returns values.
#' 
#' @param x a number
#' @param units a unit
#' @param standard a standard
#' @param digits number of digits
#' @param ... anything else
#'
format_object_size <- function(
  x, units = "b", standard = "auto", digits = 1L, ...) {

    known_bases <- c(legacy = 1024, IEC = 1024, SI = 1000)
    known_units <- list(
      SI = c("B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"),
      IEC = c("B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"),
      legacy = c("b", "Kb", "Mb", "Gb", "Tb", "Pb"),
      LEGACY = c("B", "KB", "MB", "GB", "TB", "PB")
      )

    units <- match.arg(units, c("auto", unique(unlist(known_units),
        use.names = FALSE)))
    standard <- match.arg(standard, c("auto", names(known_bases)))
    if (standard == "auto") {
        standard <- "legacy"
        if (units != "auto") {
            if (grepl("iB$", units))
                standard <- "IEC"
            else if (grepl("b$", units))
                standard <- "legacy"
            else if (units == "kB")
                stop("For SI units, specify 'standard = \"SI\"'")
        }
    }
    base <- known_bases[[standard]]
    units_map <- known_units[[standard]]
    if (units == "auto") {
        power <- if (x <= 0)
            0L
        else min(as.integer(log(x, base = base)), length(units_map) -
            1L)
    }
    else {
        power <- match(toupper(units), toupper(units_map)) -
            1L
        if (is.na(power))
            stop(gettextf("Unit \"%s\" is not part of standard \"%s\"",
                sQuote(units), sQuote(standard)), domain = NA)
    }
    unit <- units_map[power + 1L]
    if (power == 0 && standard == "legacy")
        unit <- "bytes"

    paste0(round(x = x / base ^ power, digits = digits), " ", unit)

}
