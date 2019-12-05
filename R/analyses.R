#' Runs a simple logistic regression with only prs as a predictor. 
#' @name simple_logistic_reg
#' @param full_table data.frame containing phenotype and score information
#' @param phenotype column name for phenotype
#' @param ... arguments passed 
#' @importFrom stats glm
#' @export

simple_logistic_reg <- function(full_table, phenotype, ...) {
  simple_logit_output <- glm(phenotype ~ prs, data = full_table, family = "binomial")
  summary(simple_logit_output)
  return(simple_logit_output)
}

#' Runs a more complex logistic regression with prs, age and sex as predictors
#' @rdname simple_logistic_reg
#' @export

complex_logistic_reg <- function(full_table, phenotype, ...) {
  complex_logit_output <- glm(phenotype ~ prs + age + sex, data = full_table, family = "binomial")
  summary(complex_logit_output)
  return(complex_logit_output)
}

#' runs ROC analysis 
#' @name proc_analysis
#' @param full_table data.frame containing phenotype and score information
#' @param phenotype column name for phenotype 
#' @param my_model glm for Y ~ prs (+ covariates)
#' @param ... arguments passed 
#' @importFrom stats fitted.values
#' @import pROC 
#' @export

proc_analysis <- function(full_table, phenotype, my_model, ...) {
  roc(full_table$phenotype, my_model$fitted.values, plot = TRUE)
}

#' outputs the number of subjects who are positive for the phenotype
#' @name positive_subjects
#' @param full_table data.frame containing phenotype and score information
#' @param phenotype column name for phenotype
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#' @export

# Number of subjects with positive phenotype
positive_subjects <- function(full_table, phenotype) {
  num_positive_subjects <- full_table %>%
    filter(phenotype == 1) 
  return(dim(num_positive_subjects))
}

#' performs 5-fold cross validation 
#' @name k_fold
#' @param full_table data.frame containing phenotype and score information
#' @param phenotype column name for phenotype
#' @param age_col age column
#' @param sex_col sex column
#' @param score_col score column
#' @export

k_fold <- function(full_table, phenotype, age_col, sex_col, score_col) {
  k <- 5 #number of fold
  out <- "k_fold" # output file prefix
  pheno <- as.character(phenotype)
  age <- as.character(age_col)
  sex <- as.character(sex_col)
  score <- as.character(score_col)
  # Randomly shuffle the data after setting seed
  set.seed(1234)
  shuffle_data <- full_table[sample(nrow(full_table)), ]
  # Create k equally sized folds
  folds <- cut(seq(1, nrow(shuffle_data)), breaks = k, labels = FALSE)
  # initialize list for saving data
  pheno_list <- list()
  # Perform k fold cross validation
  for (i in 1:k) {
    # Segment your data by fold using the which() function
    testIndexes <- which(folds == i, arr.ind = TRUE)
    test_data <- shuffle_data[testIndexes, ]
    train_data <- shuffle_data[-testIndexes, ]
    # fit model on training data
    glm.obj <- glm(get(pheno) ~ get(age) + get(sex) + get(score), data = train_data, family = "binomial")
    # predict in testing data
    test_preds <- predict(glm.obj, test_data)
    pdf(file = paste0(out, "ROC", i, ".pdf"), height = 6, width = 6)
    roc.obj <- roc(test_data[[pheno]], test_preds, plot = TRUE, print.auc = TRUE, ci = TRUE)
    dev.off()
    pheno_list[[i]] <- roc.obj # save ROC  object
  }
  # parse the object
  avgAUC <- mean(unlist(lapply(pheno_list, auc)))
  print(avgAUC)

  # set seed and shuffle again to get the same order as before
  # Randomly shuffle the data after setting seed
  set.seed(1234)
  shuffle_data <- full_table[sample(nrow(full_table)), ]
  folds <- cut(seq(1, nrow(shuffle_data)), breaks = k, labels = FALSE)
  # pick k colors for plots
  colors <- brewer.pal(k, "Set3")
  # Perform k fold cross validation and plot all together
  pdf(file = paste0(out, "kfold_plot.pdf"), height = 6, width = 6)
  for (i in 1:k) {
    # Segment your data by fold using the which() function
    test_indexes <- which(folds == i, arr.ind = TRUE)
    test_data <- shuffle_data[test_indexes, ]
    train_data <- shuffle_data[-test_indexes, ]
    # fit model on training data
    glm.obj <- glm(get(pheno) ~ get(age) + get(sex) + get(score), data = trainData, family = "binomial")
    # use on testing data
    test_preds <- predict(glm.obj, test_data)
    if (i == 1) {
      roc(test_data[[pheno]], test_preds, plot = TRUE, ci = TRUE, col = colors[i], print.auc = TRUE, print.auc.col = colors[i], print.auc.y = 0.5 - (i * 0.05))
    } else {
      roc(test_data[[pheno]], test_preds, plot = TRUE, ci = TRUE, add = TRUE, col = colors[i], print.auc = TRUE, print.auc.col = colors[i], print.auc.y = 0.5 - (i * 0.05))
    }
  }
  dev.off()
}
