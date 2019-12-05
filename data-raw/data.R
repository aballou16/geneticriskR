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

#table(prs, phenotype, age, sex)

test_data <- data.frame(prs, hypertension, age, sex)

usethis::use_data(test_data, overwrite = TRUE)
