
<!-- README.md is generated from README.Rmd. Please edit that file -->

# geneticriskR

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/aballou16/geneticriskR.svg?branch=master)](https://travis-ci.org/aballou16/geneticriskR)
<!-- badges: end -->

The goal of geneticriskR is to provide standard formatting, statistical
analyses and plotting for polygenic risk score data generated using
[PRSice-2](https://www.prsice.info/) software. Because recent genetic
risk studies have shown a great deal of inconsistency, this package will
aid the reproducibility of future studies.

## Installation

You can install the development version of geneticriskR from
[Github](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("aballou16/geneticriskR")
```

## Example(s)

This is a basic example which demonstrates how to run a simple logistic
regression model using an example output file from PRSice-2 called
“test\_data.”

``` r
library(geneticriskR)
View(test_data)
simple_mod <- simple_logistic_reg(test_data, hypertension)
simple_mod
```

This is another example which demonstrates how to run roc/auc analysis
on the model generated above.

``` r
library(geneticriskR)
proc_analysis(test_data, "hypertension", simple_mod)
```

This is an example of one of the standard plots included in most PRS
analyses: the side by side box plot comparing scores for cases and
conrols.

``` r
library(geneticriskR)
compare_boxplots(test_data, hypertension, prs)
```
