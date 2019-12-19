#' Runs a simple logistic regression with only prs as a predictor. 
#' @name simple_logistic_reg
#' @param full_table data.frame containing phenotype and score information
#' @param phenotype character vector for phenotype
#' @param ... dots argument for glm capabilities
#' @importFrom stats glm
#' @export

simple_logistic_reg <- function(full_table, phenotype, ...) {
  simple_logit_output <- glm(full_table[[phenotype]] ~ prs, data = full_table, family = "binomial")
  summary(simple_logit_output)
  return(simple_logit_output)
}

#' Runs a more complex logistic regression with prs, age and sex as predictors
#' @rdname simple_logistic_reg
#' @export

complex_logistic_reg <- function(full_table, phenotype) {
  complex_logit_output <- glm(full_table[[phenotype]] ~ prs + age + sex, data = full_table, family = "binomial")
  summary(complex_logit_output)
  return(complex_logit_output)
}

#' runs ROC analysis 
#' @name proc_analysis
#' @param full_table data.frame containing phenotype and score information
#' @param phenotype character vector for phenotype 
#' @param my_model glm for Y ~ prs (+ covariates)
#' @importFrom stats fitted.values
#' @import pROC 
#' @export

proc_analysis <- function(full_table, phenotype, my_model) {
  roc(full_table[[phenotype]], my_model$fitted.values, plot = TRUE)
}

#' outputs the number of subjects who are positive for the phenotype
#' @name positive_subjects
#' @param full_table data.frame containing phenotype and score information
#' @param phenotype character vector for column name for phenotype
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#' @export

# Number of subjects with positive phenotype
positive_subjects <- function(full_table, phenotype) {
  num_positive_subjects <- full_table %>%
    filter(full_table[[phenotype]] == 1) 
  return(dim(num_positive_subjects))
}

#' performs 5-fold cross validation 
#' @name k_fold
#' @param full_table data.frame containing phenotype and score information
#' @param phenotype character vector for phenotype
#' @param score_col character vector for score
#' @import pROC
#' @import RColorBrewer
#' @export

k_fold <- function(phenotype, score_col, full_table) {
  predict <- NULL
  pdf <- NULL
  dev.off <- NULL
  k <- 5 #number of fold
  out <- "phenotype_k_fold" #output file prefix
  pheno <- phenotype
  score <- score_col
  
  #Randomly shuffle the data after setting seed
  set.seed(1234)
  shuf_data <- full_table[sample(nrow(full_table)), ]
  
  #Create k equally sized folds
  folds <- cut(seq(1, nrow(shuf_data)), breaks = k, labels = FALSE)
  
  #initialize list for saving data
  roc_list <- list()
  
  #Perform k fold cross validation
  for (i in 1:k) {
    #Segment data by fold using the which() function
    test_indexes <- which(folds == i, arr.ind = TRUE)
    test_data <- shuf_data[test_indexes,]
    train_data <- shuf_data[-test_indexes,]
    #fit model on training data
    glm.obj <- glm(get(pheno) ~ get(score),
                   data = train_data,
                   family = "binomial")
    #predict in testing data
    test_preds <- predict(glm.obj, test_data)
    pdf(
      file = file.path("~/Desktop", paste0(out, "ROC", i, ".pdf")),
      height = 6,
      width = 6
    )
    roc.obj <-
      roc(
        test_data[[pheno]],
        test_preds,
        plot = TRUE,
        print.auc = TRUE,
        ci = TRUE
      )
    dev.off()
    roc_list[[i]] <- roc.obj	#save ROC  object
  }
  
  #parse the object
  avg_AUC <- mean(unlist(lapply(roc_list, auc)))
  #output avg_AUC
  message(avg_AUC)
  
  #set seed and shuffle again, plot all together
  #Randomly shuffle the data after setting seed
  set.seed(1234)
  shuf_data <- full_table[sample(nrow(full_table)),]
  folds <- cut(seq(1, nrow(shuf_data)), breaks = k, labels = FALSE)
  
  #set k colors for plots
  colors <- brewer.pal(k, "Set3")
  
  #Perform k fold cross validation and plot all together
  pdf(
    file = file.path("~/Desktop", paste0(out, "_ROC_all_folds.pdf")),
    height = 6,
    width = 6
  )
  for (i in 1:k) {
    #Segment data by fold using the which() function
    test_indexes <- which(folds == i, arr.ind = TRUE)
    test_data <- shuf_data[test_indexes,]
    train_data <- shuf_data[-test_indexes,]
    #fit model on training data
    glm.obj <-
      glm(get(pheno) ~ get(score),
          data = train_data,
          family = "binomial")
    #use on testing data
    testPreds <- predict(glm.obj, test_data)
    if (i == 1) {
      roc(
        test_data[[pheno]],
        test_preds,
        plot = TRUE,
        ci = TRUE,
        col = colors[i],
        print.auc = TRUE,
        print.auc.col = colors[i],
        print.auc.y = 0.5 - (i * 0.05)
      )
    } else {
      roc(
        test_data[[pheno]],
        test_preds,
        plot = TRUE,
        ci = TRUE,
        add = TRUE,
        col = colors[i],
        print.auc = TRUE,
        print.auc.col = colors[i],
        print.auc.y = 0.5 - (i * 0.05)
      )
    }
  }
  dev.off()
}


