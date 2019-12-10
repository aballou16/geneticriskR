
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geneticriskR

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/aballou16/geneticriskR.svg?branch=master)](https://travis-ci.org/aballou16/geneticriskR)
<!-- badges: end -->

The goal of geneticriskR is to provide standard formatting, statistical
analyses and plotting for polygenic risk score data generating using
PRSice-2 software. Because recent genetic risk studies have shown a
great deal of inconsistency, this package will allow for future studies
to be more easily reproduced.

## Installation

You can install the development version of geneticriskR from
[Github](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("aballou16/geneticriskR")
```

## Example(s)

This is a basic example which demonstrates how to run a simple logistic
regression model using an example output file from PRSice-2.

``` r
library(geneticriskR)
simple_mod <- simple_logistic_reg(test_data, hypertension)
simple_mod
```

This is another example which demonstrates how to run roc/auc analysis
on the model generated above.

``` r
library(geneticriskR)
proc_analysis(test_data, "hypertension", simple_mod)
```
