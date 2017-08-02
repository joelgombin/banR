## ----setup---------------------------------------------------------------
library("tibble")
library("dplyr")
library("banR")
# generate fake data
table_test <- tibble::tibble(
  adress = c("39 quai André Citroën", "64 Allée de Bercy", "20 avenue de Ségur"),
  postal_code = c("75015", "75012", "75007"),
  z = rnorm(3)
  )

## ----geocode-------------------------------------------------------------
geocode(query = "39 quai André Citroën, Paris") %>%
  glimpse()

## ----geocode-tbl---------------------------------------------------------
geocode_tbl(tbl = table_test, adresse = adress) %>%
  glimpse()

## ----geocode-tbl-postalcode----------------------------------------------
geocode_tbl(tbl = table_test, adresse = adress, code_postal = postal_code) %>%
  glimpse()

## ----geocode-tbl-codeinsee-----------------------------------------------
data("paris2012")
paris2012 %>%
  slice(1:100) %>%
  mutate(
    adresse = paste(numero, voie, nom),
    code_insee = paste0("751", arrondissement)
    ) %>%
  geocode_tbl(adresse = adresse, code_insee = code_insee) %>%
  glimpse()

## ----reverse-geocode-----------------------------------------------------
reverse_geocode(long =  2.279092, lat = 48.84683)  %>%
  glimpse()

## ----reverse-geocode-tbl-------------------------------------------------
test_df <- tibble::tibble(
  nom = sample(letters, size = 10, replace = FALSE),
  lon = runif(10, 2.19, 2.47),
  lat = runif(10, 48.8, 48.9)
)

test_df %>% 
  reverse_geocode_tbl(lon, lat) %>% 
  glimpse


