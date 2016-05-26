
<!-- README.md is generated from README.Rmd. Please edit that file -->
An R client for the BAN API
===========================

The `banR` package is a light R client for the [BAN API](https://adresse.data.gouv.fr/api/). The [Base Adresse Nationale (BAN)](https://adresse.data.gouv.fr/) is an open database of French adresses, produced by OpenStreetMap, La Poste, the IGN and Etalab.

`banR` is not yet on CRAN, so for the time being it can be installed through `devtools`:

``` r
# install.packages("devtools")
devtools::install_github("joelgombin/banR")
```

`banR` allows to geocode lots of adresses in batch (the only hard limit is that, at the moment, the API only allows CSV files up to 8 MB). Please be gentle with the server though!

`banR` is designed to be used in a data exploration workflow, with a syntax 'à la `dplyr`':

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

test_df <- paris2012 %>%
              slice(1:10) %>%
              mutate(adresse = paste(numero, voie, nom),
                     code_insee = paste0("751", arrondissement))
ban_search(test_df, adresse, code_insee = "code_insee") %>% glimpse
#> Geocoding...
#> Observations: 10
#> Variables: 22
#> $ arrondissement     (chr) "06", "06", "06", "06", "06", "06", "06", "...
#> $ bureau             (chr) "09", "09", "09", "09", "09", "09", "09", "...
#> $ numero             (int) 4, 5, 6, 7, 8, 11, 12, 13, 14, 16
#> $ voie               (chr) "RUE DE L", "RUE DE L", "RUE DE L", "RUE DE...
#> $ nom                (chr) "ABBAYE", "ABBAYE", "ABBAYE", "ABBAYE", "AB...
#> $ nb                 (int) 1, 1, 20, 2, 17, 2, 9, 15, 17, 8
#> $ ID                 (chr) "0609", "0609", "0609", "0609", "0609", "06...
#> $ adresse            (chr) "4 RUE DE L ABBAYE", "5 RUE DE L ABBAYE", "...
#> $ code_insee         (chr) "75106", "75106", "75106", "75106", "75106"...
#> $ latitude           (dbl) 48.85405, 48.85406, 48.85413, 48.85410, 48....
#> $ longitude          (dbl) 2.335707, 2.335172, 2.335349, 2.335034, 2.3...
#> $ result_label       (chr) "4 Rue de l'Abbaye 75006 Paris", "5 Rue de ...
#> $ result_score       (dbl) 0.94, 0.94, 0.94, 0.94, 0.94, 0.94, 0.94, 0...
#> $ result_type        (chr) "housenumber", "housenumber", "housenumber"...
#> $ result_id          (chr) "ADRNIVX_0000000270779523", "ADRNIVX_000000...
#> $ result_housenumber (int) 4, 5, 6, 7, 8, 11, 12, 13, 14, 16
#> $ result_name        (chr) "Rue de l'Abbaye", "Rue de l'Abbaye", "Rue ...
#> $ result_street      (chr) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ result_postcode    (int) 75006, 75006, 75006, 75006, 75006, 75006, 7...
#> $ result_city        (chr) "Paris", "Paris", "Paris", "Paris", "Paris"...
#> $ result_context     (chr) "75, Île-de-France", "75, Île-de-France", "...
#> $ result_citycode    (int) 75106, 75106, 75106, 75106, 75106, 75106, 7...
```

``` r
paris2012_geocoded <- paris2012 %>%
              slice(1:10) %>% 
              mutate(adresse = paste(numero, voie, nom),
                     code_insee = paste0("751", arrondissement)) 
paris2012_geocoded <- ban_search(paris2012_geocoded, adresse, code_insee = "code_insee")
#> Geocoding...

library(leaflet)
map <- paris2012_geocoded %>% 
  leaflet() %>% 
  addTiles() %>% 
  addCircleMarkers(
    lng = ~longitude, 
    lat = ~latitude, 
    radius = 5, 
    stroke = FALSE, 
    color = "navy")
# map
```

Please report issues and suggestions to the [issues tracker](https://github.com/joelgombin/banR/issues).
