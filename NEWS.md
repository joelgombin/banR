# banR (development version)

# banR v0.2.3
- Change API url to IGN's geoplateforme (https://data.geopf.fr/geocodage/openapi)
- bug fix function reverse_geocode() that couldn't deal with NULL values any more, surely due to `as_tibble()` evolutions

# banR v0.2.2
- getting ready for dplyr v1.0

# banR v0.2.1
- very minor changes 
- fix #16: allows for characters in postcodes and housenumbers

# banR v0.2.0

- now manages reverse geocoding
- now completely handles NSE 
- code refactored to use the new tidyeval framework and dplyr >= 0.7
- vignette updated and enhanced
