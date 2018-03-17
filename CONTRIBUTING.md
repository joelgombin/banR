# Contributing guide

## Process

We use the pipeline and architecture described by @hadley in the [R Packages](http://r-pkgs.had.co.nz/) book

We use `devtools` to build, test, document and check the package

    library("devtools")
    document()
    build()
    test()
    check()
  
We use `lintr` to lint the code

    library("lintr")
    lint_package()

We use `pkgdown` to build the site

    library(pkgdown)
    build_site()
    
Once everything is running fine, one can do a pull request.  