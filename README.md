An R client for the BAN API
===========================

The `banR` package is a light R client for the [BAN API](https://adresse.data.gouv.fr/api/). The [Base Adresse Nationale (BAN)](https://adresse.data.gouv.fr/) is an open database of French adresses, produced by OpenStreetMap, La Poste, the IGN and Etalab.

`banR` is not yet on CRAN, so for the time being it can be installed through `devtools`:

```r
# install.packages("devtools")
devtools::install_github("joelgombin/banR")
```

`banR` allows to geocode lots of adresses in batch (the only hard limit is that, at the moment, the API only allows CSV files up to 8 MB). Please be gentle with the server though!

Please report issues and suggestions to the [issues tracker](https://github.com/joelgombin/banR/issues).
