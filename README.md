
<!-- README.md is generated from README.Rmd. Please edit that file -->

# An R client for the BAN API

[![Travis-CI Build
Status](https://travis-ci.org/joelgombin/banR.svg?branch=master)](https://travis-ci.org/joelgombin/banR)

The `banR` package is a light R client for the [BAN
API](https://adresse.data.gouv.fr/api/). The [Base Adresse Nationale
(BAN)](https://adresse.data.gouv.fr/) is an open database of French
adresses, produced by OpenStreetMap, La Poste, the IGN and Etalab.

`banR` can be installed from CRAN (stable version):

``` r
install.packages("banR")
```

or from Github (dev version):

``` r
# install.packages("devtools")
devtools::install_github("joelgombin/banR", build_vignettes = TRUE)
```

`banR` allows to geocode lots of adresses in batch (the only hard limit
is that, at the moment, the API only allows CSV files up to 8 MB).
Please be gentle with the server though\!

`banR` is designed to be used in a data exploration workflow, with a
syntax ‘à la [`tidyverse`](http://tidyverse.org)’:

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
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
#> Writing tempfile to.../tmp/RtmpV2AX0y/file4e2e282dffd5.csv
#> If file is larger than 8 MB, it must be splitted
#> Size is : 3 Kb
#> SuccessOKSuccess: (200) OK
#> Observations: 100
#> Variables: 25
#> $ arrondissement     <chr> "06", "06", "06", "06", "06", "06", "06", "06", "0…
#> $ bureau             <chr> "09", "09", "09", "09", "09", "09", "09", "09", "0…
#> $ numero             <int> 4, 5, 6, 7, 8, 11, 12, 13, 14, 16, 3, 4, 5, 6, 7, …
#> $ voie               <chr> "RUE DE L", "RUE DE L", "RUE DE L", "RUE DE L", "R…
#> $ nom                <chr> "ABBAYE", "ABBAYE", "ABBAYE", "ABBAYE", "ABBAYE", …
#> $ nb                 <int> 1, 1, 20, 2, 17, 2, 9, 15, 17, 8, 13, 6, 6, 3, 9, …
#> $ ID                 <chr> "0609", "0609", "0609", "0609", "0609", "0609", "0…
#> $ adresse            <chr> "4 RUE DE L ABBAYE", "5 RUE DE L ABBAYE", "6 RUE D…
#> $ code_insee         <chr> "75106", "75106", "75106", "75106", "75106", "7510…
#> $ latitude           <dbl> 48.85405, 48.85407, 48.85414, 48.85410, 48.85425, …
#> $ longitude          <dbl> 2.335715, 2.335172, 2.335352, 2.335041, 2.334903, …
#> $ result_label       <chr> "4 Rue de l'Abbaye 75006 Paris", "5 Rue de l'Abbay…
#> $ result_score       <dbl> 0.96, 0.96, 0.96, 0.96, 0.96, 0.96, 0.96, 0.96, 0.…
#> $ result_type        <chr> "housenumber", "housenumber", "housenumber", "hous…
#> $ result_id          <chr> "75106_0002_00004", "75106_0002_00005", "75106_000…
#> $ result_housenumber <chr> "4", "5", "6", "7", "8", "11", "12", "13", "14", "…
#> $ result_name        <chr> "Rue de l'Abbaye", "Rue de l'Abbaye", "Rue de l'Ab…
#> $ result_street      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ result_postcode    <chr> "75006", "75006", "75006", "75006", "75006", "7500…
#> $ result_city        <chr> "Paris", "Paris", "Paris", "Paris", "Paris", "Pari…
#> $ result_context     <chr> "75, Paris, Île-de-France", "75, Paris, Île-de-Fra…
#> $ result_citycode    <chr> "75106", "75106", "75106", "75106", "75106", "7510…
#> $ result_oldcitycode <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ result_oldcity     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA…
#> $ result_district    <chr> "Paris 6e Arrondissement", "Paris 6e Arrondissemen…
```

To know more about this package, please read the
[vignette](http://joelgombin.github.io/banR/articles/geocode.html)
(`vignette("geocode")`)

Please report issues and suggestions to the [issues
tracker](https://github.com/joelgombin/banR/issues).

## See also

  - [BAN-geocoder](https://github.com/atao/BAN-Geocoder), python wrapper
    for adresse.data.gouv.fr
