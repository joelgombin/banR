---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# An R client for the BAN API

<!-- badges: start -->
[![R build status](https://github.com/joelgombin/banR/workflows/R-CMD-check/badge.svg)](https://github.com/joelgombin/banR/actions)
<!-- badges: end -->
  
The `banR` package is a light R client for the [BAN API](https://geo.api.gouv.fr/adresse). The [Base Adresse Nationale (BAN)](https://adresse.data.gouv.fr/) is an open database of French adresses, produced by OpenStreetMap, La Poste, the IGN and Etalab. 

`banR` can be installed from Github (current version):


```r
# install.packages("devtools")
devtools::install_github("joelgombin/banR", build_vignettes = TRUE)
```

The CRAN version is out of date : 


```r
install.packages("banR")
```

`banR` allows to geocode lots of adresses in batch (the only hard limit is that, at the moment, the API only allows CSV files up to 50 MB). Please be gentle with the server though!

`banR` is designed to be used in a data exploration workflow, with a syntax 'à la [`tidyverse`](http://tidyverse.org)':


```r
library(dplyr)
library(banR)
data("paris2012")

paris2012 %>%
  slice(1:100) %>%
  mutate(adresse = paste(numero, voie, nom),
         code_insee = paste0("751", arrondissement)) %>% 
  geocode_tbl(adresse = adresse, code_insee = code_insee) %>%
  glimpse()
#> Writing tempfile to.../tmp/Rtmp9YlNra/file147282c595535.csv
#> If file is larger than 50 MB, it must be splitted
#> Size is : 3 Kb
#> SuccessOKSuccess: (200) OK
#> Rows: 100
#> Columns: 25
#> $ arrondissement     <chr> "06", "06", "06", "06", "06", "06", "06", "06", "06…
#> $ bureau             <chr> "09", "09", "09", "09", "09", "09", "09", "09", "09…
#> $ numero             <int> 4, 5, 6, 7, 8, 11, 12, 13, 14, 16, 3, 4, 5, 6, 7, 8…
#> $ voie               <chr> "RUE DE L", "RUE DE L", "RUE DE L", "RUE DE L", "RU…
#> $ nom                <chr> "ABBAYE", "ABBAYE", "ABBAYE", "ABBAYE", "ABBAYE", "…
#> $ nb                 <int> 1, 1, 20, 2, 17, 2, 9, 15, 17, 8, 13, 6, 6, 3, 9, 1…
#> $ ID                 <chr> "0609", "0609", "0609", "0609", "0609", "0609", "06…
#> $ adresse            <chr> "4 RUE DE L ABBAYE", "5 RUE DE L ABBAYE", "6 RUE DE…
#> $ code_insee         <chr> "75106", "75106", "75106", "75106", "75106", "75106…
#> $ latitude           <dbl> 48.85405, 48.85407, 48.85414, 48.85410, 48.85425, 4…
#> $ longitude          <dbl> 2.335715, 2.335172, 2.335352, 2.335041, 2.334903, 2…
#> $ result_label       <chr> "4 Rue de l’Abbaye 75006 Paris", "5 Rue de l’Abbaye…
#> $ result_score       <dbl> 0.97, 0.97, 0.97, 0.97, 0.97, 0.97, 0.97, 0.97, 0.9…
#> $ result_type        <chr> "housenumber", "housenumber", "housenumber", "house…
#> $ result_id          <chr> "75106_0002_00004", "75106_0002_00005", "75106_0002…
#> $ result_housenumber <chr> "4", "5", "6", "7", "8", "11", "12", "13", "14", "1…
#> $ result_name        <chr> "Rue de l’Abbaye", "Rue de l’Abbaye", "Rue de l’Abb…
#> $ result_street      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ result_postcode    <chr> "75006", "75006", "75006", "75006", "75006", "75006…
#> $ result_city        <chr> "Paris", "Paris", "Paris", "Paris", "Paris", "Paris…
#> $ result_context     <chr> "75, Paris, Île-de-France", "75, Paris, Île-de-Fran…
#> $ result_citycode    <chr> "75106", "75106", "75106", "75106", "75106", "75106…
#> $ result_oldcitycode <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ result_oldcity     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ result_district    <chr> "Paris 6e Arrondissement", "Paris 6e Arrondissement…
```

To know more about this package, please read the [vignette](http://joelgombin.github.io/banR/articles/geocode.html) (`vignette("geocode")`)

Please report issues and suggestions to the [issues tracker](https://github.com/joelgombin/banR/issues).

## See also

* [BAN-geocoder](https://github.com/atao/BAN-Geocoder), python wrapper for adresse.data.gouv.fr
* [tidygeocoder](https://github.com/jessecambon/tidygeocoder), r package similar to banR using other geocoding services such as US Census geocoder, Nominatim (OSM), Geocodio, and Location IQ. 
