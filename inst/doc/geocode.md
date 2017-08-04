Geocoding French adresses with BanR
================
Paul-Antoine Chevalier (Etalab), Joël Gombin (Datactivist)
2017-08-04

``` r
library("tibble")
library("dplyr")
library("banR")
# generate fake data
table_test <- tibble::tibble(
  adress = c("39 quai André Citroën", "64 Allée de Bercy", "20 avenue de Ségur"),
  postal_code = c("75015", "75012", "75007"),
  z = rnorm(3)
  )
```

-   `geocode()` geocodes a single address
-   `reverse_geocode()` reverse geocodes a single pair of longitude and latitude
-   `geocode_tbl()` geocodes a data frame
-   `reverse_geocode_tbl()` reverse geocodes a data frame

Geocode
-------

Geocoding is the process of transforming a human readable address into a location (ie a pair of latitude and longitude).

### A single address

``` r
geocode(query = "39 quai André Citroën, Paris") %>%
  glimpse()
```

    ## 200

    ## Observations: 1
    ## Variables: 17
    ## $ id          <chr> "ADRNIVX_0000000270792870"
    ## $ importance  <dbl> 0.3044
    ## $ name        <chr> "39 Quai André Citroën"
    ## $ postcode    <chr> "75015"
    ## $ housenumber <chr> "39"
    ## $ citycode    <chr> "75115"
    ## $ x           <dbl> 647095.1
    ## $ label       <chr> "39 Quai André Citroën 75015 Paris"
    ## $ y           <dbl> 6860995
    ## $ street      <chr> "Quai André Citroën"
    ## $ context     <chr> "75, Paris, Île-de-France"
    ## $ type        <chr> "housenumber"
    ## $ city        <chr> "Paris"
    ## $ score       <dbl> 0.9367636
    ## $ type_geo    <chr> "Point"
    ## $ longitude   <dbl> 2.279092
    ## $ latitude    <dbl> 48.84683

The BAN API sends back both projected/Cartesian coordinates (`x` and `y` columns - they use Lambert 93 projection, aka as EPSG:2154), and lon/lat (i.e. WGS84) coordinates (`longitude` and `latitude` columns). It also indicates the degree of confidence it has in each result (column `score`). The above example only sends back one result, but sometimes the API will send back several suggestion for the same query. They are ordered by descending order of confidence.

### A data frame

In addition to the adress, `geocode_tbl()` can take as argument either the [postal code](https://en.wikipedia.org/wiki/Postal_codes_in_France) or the French official code ([INSEE code](https://en.wikipedia.org/wiki/INSEE_code)) of the commune.

``` r
geocode_tbl(tbl = table_test, adresse = adress) %>%
  glimpse()
```

    ## Writing tempfile to.../tmp/Rtmp7cMa5G/file5efd43a9c648.csv

    ## If file is larger than 8 MB, it must be splitted
    ## Size is : 70 bytes

    ## SuccessOKSuccess: (200) OK

    ## Observations: 3
    ## Variables: 16
    ## $ postal_code        <chr> "75015", "75012", "75007"
    ## $ z                  <dbl> -0.2453739, -0.1189456, -1.0130883
    ## $ adress             <chr> "39 quai André Citroën", "64 Allée de Bercy...
    ## $ latitude           <dbl> 48.84683, 48.84255, 48.85032
    ## $ longitude          <dbl> 2.279092, 2.375933, 2.308332
    ## $ result_label       <chr> "39 Quai André Citroën 75015 Paris", "64 Al...
    ## $ result_score       <dbl> 0.94, 0.93, 0.95
    ## $ result_type        <chr> "housenumber", "housenumber", "housenumber"
    ## $ result_id          <chr> "ADRNIVX_0000000270792870", "ADRNIVX_000000...
    ## $ result_housenumber <int> 39, 64, 20
    ## $ result_name        <chr> "Quai André Citroën", "Allée de Bercy", "Av...
    ## $ result_street      <chr> NA, NA, NA
    ## $ result_postcode    <int> 75015, 75012, 75007
    ## $ result_city        <chr> "Paris", "Paris", "Paris"
    ## $ result_context     <chr> "75, Paris, Île-de-France", "75, Paris, Île...
    ## $ result_citycode    <chr> "75115", "75112", "75107"

``` r
geocode_tbl(tbl = table_test, adresse = adress, code_postal = postal_code) %>%
  glimpse()
```

    ## Writing tempfile to.../tmp/Rtmp7cMa5G/file5efd62e8e1ba.csv

    ## If file is larger than 8 MB, it must be splitted
    ## Size is : 100 bytes

    ## SuccessOKSuccess: (200) OK

    ## Observations: 3
    ## Variables: 16
    ## $ z                  <dbl> -0.2453739, -0.1189456, -1.0130883
    ## $ adress             <chr> "39 quai André Citroën", "64 Allée de Bercy...
    ## $ postal_code        <chr> "75015", "75012", "75007"
    ## $ latitude           <dbl> 48.84683, 48.84255, 48.85032
    ## $ longitude          <dbl> 2.279092, 2.375933, 2.308332
    ## $ result_label       <chr> "39 Quai André Citroën 75015 Paris", "64 Al...
    ## $ result_score       <dbl> 0.94, 0.93, 0.95
    ## $ result_type        <chr> "housenumber", "housenumber", "housenumber"
    ## $ result_id          <chr> "ADRNIVX_0000000270792870", "ADRNIVX_000000...
    ## $ result_housenumber <int> 39, 64, 20
    ## $ result_name        <chr> "Quai André Citroën", "Allée de Bercy", "Av...
    ## $ result_street      <chr> NA, NA, NA
    ## $ result_postcode    <int> 75015, 75012, 75007
    ## $ result_city        <chr> "Paris", "Paris", "Paris"
    ## $ result_context     <chr> "75, Paris, Île-de-France", "75, Paris, Île...
    ## $ result_citycode    <chr> "75115", "75112", "75107"

``` r
data("paris2012")
paris2012 %>%
  slice(1:100) %>%
  mutate(
    adresse = paste(numero, voie, nom),
    code_insee = paste0("751", arrondissement)
    ) %>%
  geocode_tbl(adresse = adresse, code_insee = code_insee) %>%
  glimpse()
```

    ## Writing tempfile to.../tmp/Rtmp7cMa5G/file5efd1c13b781.csv

    ## If file is larger than 8 MB, it must be splitted
    ## Size is : 3 Kb

    ## SuccessOKSuccess: (200) OK

    ## Observations: 100
    ## Variables: 22
    ## $ arrondissement     <chr> "06", "06", "06", "06", "06", "06", "06", "...
    ## $ bureau             <chr> "09", "09", "09", "09", "09", "09", "09", "...
    ## $ numero             <int> 4, 5, 6, 7, 8, 11, 12, 13, 14, 16, 3, 4, 5,...
    ## $ voie               <chr> "RUE DE L", "RUE DE L", "RUE DE L", "RUE DE...
    ## $ nom                <chr> "ABBAYE", "ABBAYE", "ABBAYE", "ABBAYE", "AB...
    ## $ nb                 <int> 1, 1, 20, 2, 17, 2, 9, 15, 17, 8, 13, 6, 6,...
    ## $ ID                 <chr> "0609", "0609", "0609", "0609", "0609", "06...
    ## $ adresse            <chr> "4 RUE DE L ABBAYE", "5 RUE DE L ABBAYE", "...
    ## $ code_insee         <chr> "75106", "75106", "75106", "75106", "75106"...
    ## $ latitude           <dbl> 48.85405, 48.85406, 48.85413, 48.85410, 48....
    ## $ longitude          <dbl> 2.335707, 2.335172, 2.335349, 2.335034, 2.3...
    ## $ result_label       <chr> "4 Rue de l'Abbaye 75006 Paris", "5 Rue de ...
    ## $ result_score       <dbl> 0.94, 0.94, 0.94, 0.94, 0.94, 0.94, 0.94, 0...
    ## $ result_type        <chr> "housenumber", "housenumber", "housenumber"...
    ## $ result_id          <chr> "ADRNIVX_0000000270779523", "ADRNIVX_000000...
    ## $ result_housenumber <int> 4, 5, 6, 7, 8, 11, 12, 13, 14, 16, 3, 4, 5,...
    ## $ result_name        <chr> "Rue de l'Abbaye", "Rue de l'Abbaye", "Rue ...
    ## $ result_street      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,...
    ## $ result_postcode    <int> 75006, 75006, 75006, 75006, 75006, 75006, 7...
    ## $ result_city        <chr> "Paris", "Paris", "Paris", "Paris", "Paris"...
    ## $ result_context     <chr> "75, Paris, Île-de-France", "75, Paris, Île...
    ## $ result_citycode    <chr> "75106", "75106", "75106", "75106", "75106"...

Reverse geocode
---------------

Reverse geocoding is the process of back (reverse) coding of a point location (latitude, longitude) to a human readable address.

### A single adress

`reverse_geocode()` takes longitude and latitude as arguments and returns a data frame with addresses.

``` r
reverse_geocode(long =  2.279092, lat = 48.84683)  %>%
  glimpse()
```

    ## 200

    ## Observations: 1
    ## Variables: 18
    ## $ id          <chr> "75115_0318_91e007"
    ## $ importance  <dbl> 0.3044
    ## $ name        <chr> "39 Quai André Citroën"
    ## $ distance    <int> 0
    ## $ postcode    <chr> "75015"
    ## $ housenumber <chr> "39"
    ## $ citycode    <chr> "75115"
    ## $ x           <dbl> 647050.2
    ## $ label       <chr> "39 Quai André Citroën 75015 Paris"
    ## $ y           <dbl> 6860963
    ## $ street      <chr> "Quai André Citroën"
    ## $ context     <chr> "75, Paris, Île-de-France"
    ## $ type        <chr> "housenumber"
    ## $ city        <chr> "Paris"
    ## $ score       <dbl> 1
    ## $ type_geo    <chr> "Point"
    ## $ longitude   <dbl> 2.279092
    ## $ latitude    <dbl> 48.84683

### A data frame

`reverse_geocode_tbl` takes the names of the longitude and latitude columns and returns a data frame with adresses.

``` r
test_df <- tibble::tibble(
  nom = sample(letters, size = 10, replace = FALSE),
  lon = runif(10, 2.19, 2.47),
  lat = runif(10, 48.8, 48.9)
)

test_df %>% 
  reverse_geocode_tbl(lon, lat) %>% 
  glimpse
```

    ## Writing tempfile to.../tmp/Rtmp7cMa5G/file5efd723bfbb4.csv

    ## If file is larger than 8 MB, it must be splitted
    ## Size is : 382 bytes

    ## SuccessOKSuccess: (200) OK

    ## Observations: 10
    ## Variables: 16
    ## $ nom                <chr> "q", "a", "s", "y", "f", "v", "b", "k", "z"...
    ## $ longitude          <dbl> 2.269380, 2.327532, 2.334737, 2.370485, 2.2...
    ## $ latitude           <dbl> 48.83021, 48.87524, 48.85729, 48.83499, 48....
    ## $ result_latitude    <dbl> 48.82991, 48.87522, 48.85716, 48.83474, 48....
    ## $ result_longitude   <dbl> 2.267338, 2.327530, 2.334976, 2.370134, 2.2...
    ## $ result_label       <chr> "48 Boulevard Gallieni 92130 Issy-les-Mouli...
    ## $ result_distance    <int> 153, 1, 22, 37, 6, 7, 34, 45, 21, 5
    ## $ result_type        <chr> "housenumber", "housenumber", "housenumber"...
    ## $ result_id          <chr> "92040_XXXX_d66ae3", "75109_XXXX_6dce2d", "...
    ## $ result_housenumber <chr> "48", "42", "6", "55 A", "7", "16", "1", "4...
    ## $ result_name        <chr> "Boulevard Gallieni", "Passage du Havre", "...
    ## $ result_street      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
    ## $ result_postcode    <chr> "92130", "75009", "75006", "75013", "92100"...
    ## $ result_city        <chr> "Issy-les-Moulineaux", "Paris", "Paris", "P...
    ## $ result_context     <chr> "92, Hauts-de-Seine, Île-de-France", "75, P...
    ## $ result_citycode    <chr> "92040", "75109", "75106", "75113", "92012"...
