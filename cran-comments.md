## Test environments
* local Ubuntu 19.10, R 3.6.1
* ubuntu 16.04 (on travis-ci), R 3.6.1
* r-hub (using `rhub::check_for_cran()`)

## R CMD check results

── banR 0.2.1: OK

  Build ID:   banR_0.2.1.tar.gz-6e351c33a6da45b7a9f3ce61de70ca9a
  Platform:   Ubuntu Linux 16.04 LTS, R-release, GCC
  Submitted:  25m 11.3s ago
  Build time: 18m 17s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── banR 0.2.1: NOTE

  Build ID:   banR_0.2.1.tar.gz-7f2a1f1af4e6424a9a81ca8edd00c1c0
  Platform:   Fedora Linux, R-devel, clang, gfortran
  Submitted:  25m 11.4s ago
  Build time: 22m 1.1s

❯ checking CRAN incoming feasibility ...NB: need Internet access to use CRAN incoming checks
   NOTE
  Maintainer: ‘Joel Gombin <joel.gombin@gmail.com>’
  
  Possibly mis-spelled words in DESCRIPTION:
    Adresses (8:37)
    Nationale (8:46)
    geocode (9:5, 9:25)
    
The first two words are French words. 'geocode' might be unknown to the spellchecker but isn't incorrect IMHO.  
    

0 errors ✔ | 0 warnings ✔ | 1 note ✖

── banR 0.2.1: OK

  Build ID:   banR_0.2.1.tar.gz-c6765e70217344bba462b2fa5773cfff
  Platform:   Windows Server 2008 R2 SP1, R-devel, 32/64 bit
  Submitted:  25m 11.4s ago
  Build time: 5m 30.6s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

## Downstream dependencies

There are currently no downstream dependencies for this package. 