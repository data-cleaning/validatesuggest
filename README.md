
<!-- README.md is generated from README.Rmd. Please edit that file -->

# validatesuggest

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/validatesuggest)](https://CRAN.R-project.org/package=validatesuggest)
[![R-CMD-check](https://github.com/edwindj/validatesuggest/workflows/R-CMD-check/badge.svg)](https://github.com/edwindj/validatesuggest/actions)
<!-- badges: end -->

The goal of validatesuggest is to generate suggestions for
[validation](https://CRAN.R-project.org/package=validate) rules from a
supplied dataset. These can be used as a starting point for a rule set
and are to be adjusted by domain experts.

## Installation

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("edwindj/validatesuggest")
```

## Example

``` r
library(validate)
library(validatesuggest)

data(retailers, package="validate")
data(SBS2000, package="validate")

# does all
#suggest_rules(retailers)


suggest_range_check(retailers, min=TRUE, max=FALSE)
#> Object of class 'validator' with 10 elements:
#>  RC1 : size %in% c("sc0", "sc3", "sc1", "sc2")
#>  RC2 : incl.prob >= 0.02
#>  RC3 : staff >= 1
#>  RC4 : turnover >= 1
#>  RC5 : other.rev >= -33
#>  RC6 : total.rev >= 25
#>  RC7 : staff.costs >= 2
#>  RC8 : total.costs >= 22
#>  RC9 : profit >= -222
#>  RC10: vat >= 41

suggest_na_check(retailers)
#> Object of class 'validator' with 2 elements:
#>  NA1: is.complete(size)
#>  NA2: is.complete(incl.prob)

suggest_unique_check(SBS2000)
#> Object of class 'validator' with 1 elements:
#>  UN1: all_unique(id)

suggest_type_check(retailers)
#> Object of class 'validator' with 10 elements:
#>  TC1 : is.factor(size)
#>  TC2 : is.numeric(incl.prob)
#>  TC3 : is.integer(staff)
#>  TC4 : is.integer(turnover)
#>  TC5 : is.integer(other.rev)
#>  TC6 : is.integer(total.rev)
#>  TC7 : is.integer(staff.costs)
#>  TC8 : is.integer(total.costs)
#>  TC9 : is.integer(profit)
#>  TC10: is.integer(vat)

suggest_ratio_check(retailers)
#> Object of class 'validator' with 10 elements:
#>  RC1 : turnover >= 0 * total.rev
#>  RC2 : turnover <= 9.07 * total.rev
#>  RC3 : other.rev >= -0.1 * staff.costs
#>  RC4 : other.rev <= 34.55 * staff.costs
#>  RC5 : other.rev >= -0.01 * total.costs
#>  RC6 : other.rev <= 1.27 * total.costs
#>  RC7 : staff.costs >= 0 * total.costs
#>  RC8 : staff.costs <= 0.99 * total.costs
#>  RC9 : other.rev >= -2.8 * profit
#>  RC10: other.rev <= 4.72 * profit
```
