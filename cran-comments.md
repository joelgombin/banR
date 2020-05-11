## Test environments
* local Ubuntu 20.04, R 4.0.0
* [Github Actions](https://github.com/joelgombin/banR/actions?query=workflow%3AR-CMD-check) : 
  * macOS-latest, devel
  * macOS-latest, 4.0
  * windows-latest, 4.0
  * Ubuntu 16.04, 4.0
  * Ubuntu 16.04, 3.6
  * Ubuntu 16.04, 3.5
  * Ubuntu 16.04, 3.4
  * Ubuntu 16.04, 3.3
* r-hub (using `rhub::check_for_cran(env_vars=c(R_COMPILE_AND_INSTALL_PACKAGES = "always"))`)

## R CMD check results

All checks came back with 0 error, 0 warning and 0 note.

## Downstream dependencies

There are currently no downstream dependencies for this package. 