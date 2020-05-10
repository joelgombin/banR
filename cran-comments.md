## Test environments
* local Ubuntu 20.04, R 4.0.0
* [Github Actions](https://github.com/joelgombin/banR/actions?query=workflow%3AR-CMD-check) : 
  * macOS-latest, devel
  * macOS-latest, 4.0
  * windows-latest, 4.0
  * Ubuntu 16.04, 4.0
  * Ubuntu 16.04, 3.6
  * Ubuntu 16.04, 3.5
  * Ubuntu 16.04, 3.5
* r-hub (using `rhub::check_for_cran()`)

## R CMD check results

── banR 0.2.1: NOTE

  Build ID:   banR_0.2.1.tar.gz-162dcf5b7e24495296996761e8549c0a
  Platform:   Fedora Linux, R-devel, clang, gfortran
  Submitted:  19m 17s ago
  Build time: 18m 34.5s

❯ checking CRAN incoming feasibility ...NB: need Internet access to use CRAN incoming checks
   NOTE
  Maintainer: ‘Joel Gombin <joel.gombin@gmail.com>’
  
  Possibly mis-spelled words in DESCRIPTION:
    Adresses (8:37)
    Nationale (8:46)
    geocode (9:5, 9:25)

0 errors ✔ | 0 warnings ✔ | 1 note ✖

── banR 0.2.1: OK

  Build ID:   banR_0.2.1.tar.gz-481539c82f174f128c22fa5b02bfe775
  Platform:   Ubuntu Linux 16.04 LTS, R-release, GCC
  Submitted:  19m 17s ago
  Build time: 15m 54.2s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── banR 0.2.1: OK

  Build ID:   banR_0.2.1.tar.gz-ab2a4a3efd3841239d884b94d175b782
  Platform:   Windows Server 2008 R2 SP1, R-devel, 32/64 bit
  Submitted:  19m 17s ago
  Build time: 4m 48.6s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

## Downstream dependencies

There are currently no downstream dependencies for this package. 