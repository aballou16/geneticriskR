#' score and phenotype
#' 
#' a mock dataset containing score and phenotype information
#' 
#' @name test_data
#' 
#' @format data.frame with 3300 rows and 4 columns
#' \describe{
#'   \item{prs}{polygenic risk score}
#'   \item{hypertension}{phenotype status, 1 or 0}
#'   \item{age}{individual's age group, by decade}
#'   \item{sex}{individual's sex, 1 denotes male, 0 denotes female}
#' }
"test_data"

prs <- c(rnorm(3300, 0 ,1))

hypertension <- c(rep(1, 800),
               rep(0, 2500))

age <- c(rep(10, 10), 
         rep(20, 1000),
         rep(30, 750), 
         rep(40, 650),
         rep(50, 450),
         rep(60, 250),
         rep(70, 150),
         rep(80, 25),
         rep(90, 15)
         )

sex <- c(rep(1, 1700),
         rep(0, 1600)
         )

test_data <- data.frame(prs, hypertension, age, sex)

usethis::use_data(test_data, overwrite = TRUE)

#' phenotype table
#' 
#' a mock dataset containing phenotype information
#' 
#' @name pheno_data
#' 
#' @format data.frame with 3300 rows and 6 columns
#' \describe{
#'   \item{hypertension}{phenotype status, 1 or 0}
#'   \item{age}{individual's age group, by decade}
#'   \item{sex}{individual's sex, 1 denotes male, 0 denotes female}
#'   \item{IID}{individual identifier for each subject}
#'   \item{diabetes}{phenotype status, 1 or 0}
#'   \item{ms}{phenotype status, 1 or 0}
#' }
"pheno_data"

hypertension <- c(rep(1, 800),
                  rep(0, 2500))
age <- c(rep(10, 10), 
         rep(20, 1000),
         rep(30, 750), 
         rep(40, 650),
         rep(50, 450),
         rep(60, 250),
         rep(70, 150),
         rep(80, 25),
         rep(90, 15)
)

sex <- c(rep(1, 1700),
         rep(0, 1600)
)

IID <- seq(1, 3300)

diabetes <- c(rep(1, 900),
              rep(0, 2400)) 

ms <- c(rep(1, 500),
        rep(0, 2800))

pheno_data <- data.frame(hypertension, age, sex, IID, diabetes, ms)

usethis::use_data(pheno_data, overwrite = TRUE)

#' score information
#' 
#' a mock dataset containing score information
#' 
#' @name score_data
#' 
#' @format data.frame with 3300 rows and 2 columns
#' \describe{
#'   \item{prs}{polygenic risk score}
#'   \item{IID}{individual identifier for each subject}
#' }
"score_data"

prs <- c(rnorm(3300, 0 ,1))

IID <- seq(1, 3300)

score_data <- data.frame(prs, IID)

usethis::use_data(score_data, overwrite = TRUE)


