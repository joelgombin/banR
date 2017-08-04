
<!-- README.md is generated from README.Rmd. Please edit that file -->
An R client for the BAN API
===========================

[![Travis-CI Build Status](https://travis-ci.org/joelgombin/banR.svg?branch=master)](https://travis-ci.org/joelgombin/banR)

The `banR` package is a light R client for the [BAN API](https://adresse.data.gouv.fr/api/). The [Base Adresse Nationale (BAN)](https://adresse.data.gouv.fr/) is an open database of French adresses, produced by OpenStreetMap, La Poste, the IGN and Etalab.

`banR` can be installed from CRAN (stable version):

``` r
install.packages("banR")
```

or from Github (dev version):

``` r
# install.packages("devtools")
devtools::install_github("joelgombin/banR", build_vignettes = TRUE)
```

`banR` allows to geocode lots of adresses in batch (the only hard limit is that, at the moment, the API only allows CSV files up to 8 MB). Please be gentle with the server though!

`banR` is designed to be used in a data exploration workflow, with a syntax 'à la [`tidyverse`](http://tidyverse.org)':

``` r
library(dplyr)
#> 
#> Attachement du package : 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(banR)
data("paris2012")

paris2012 %>%
  slice(1:100) %>%
  mutate(adresse = paste(numero, voie, nom),
         code_insee = paste0("751", arrondissement)) %>% 
  geocode_tbl(adresse = adresse, code_insee = code_insee) %>%
  glimpse
#> Writing tempfile to.../var/folders/rv/yt271f0523s3vmqt3p8zzr9h0000gn/T//RtmpmJYDLe/file537e35d5f4ba.csv
#> If file is larger than 8 MB, it must be splitted
#> Size is : 3 Kb
#> SuccessOKSuccess: (200) OK
#> Observations: 100
#> Variables: 22
#> $ arrondissement     <chr> "06", "06", "06", "06", "06", "06", "06", "...
#> $ bureau             <chr> "09", "09", "09", "09", "09", "09", "09", "...
#> $ numero             <int> 4, 5, 6, 7, 8, 11, 12, 13, 14, 16, 3, 4, 5,...
#> $ voie               <chr> "RUE DE L", "RUE DE L", "RUE DE L", "RUE DE...
#> $ nom                <chr> "ABBAYE", "ABBAYE", "ABBAYE", "ABBAYE", "AB...
#> $ nb                 <int> 1, 1, 20, 2, 17, 2, 9, 15, 17, 8, 13, 6, 6,...
#> $ ID                 <chr> "0609", "0609", "0609", "0609", "0609", "06...
#> $ adresse            <chr> "4 RUE DE L ABBAYE", "5 RUE DE L ABBAYE", "...
#> $ code_insee         <chr> "75106", "75106", "75106", "75106", "75106"...
#> $ latitude           <dbl> 48.85405, 48.85406, 48.85413, 48.85410, 48....
#> $ longitude          <dbl> 2.335707, 2.335172, 2.335349, 2.335034, 2.3...
#> $ result_label       <chr> "4 Rue de l'Abbaye 75006 Paris", "5 Rue de ...
#> $ result_score       <dbl> 0.94, 0.94, 0.94, 0.94, 0.94, 0.94, 0.94, 0...
#> $ result_type        <chr> "housenumber", "housenumber", "housenumber"...
#> $ result_id          <chr> "ADRNIVX_0000000270779523", "ADRNIVX_000000...
#> $ result_housenumber <int> 4, 5, 6, 7, 8, 11, 12, 13, 14, 16, 3, 4, 5,...
#> $ result_name        <chr> "Rue de l'Abbaye", "Rue de l'Abbaye", "Rue ...
#> $ result_street      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
#> $ result_postcode    <int> 75006, 75006, 75006, 75006, 75006, 75006, 7...
#> $ result_city        <chr> "Paris", "Paris", "Paris", "Paris", "Paris"...
#> $ result_context     <chr> "75, Paris, Île-de-France", "75, Paris, Île...
#> $ result_citycode    <chr> "75106", "75106", "75106", "75106", "75106"...
```

To know more about this package, please read the [vignette](./inst/doc/geocode.md) (`vignette("geocode")`)

Please report issues and suggestions to the [issues tracker](https://github.com/joelgombin/banR/issues).
