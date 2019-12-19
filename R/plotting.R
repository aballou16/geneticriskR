#' compares the prs for the cases and controls 
#' @name compare_boxplots
#' @param full_table data.frame containing phenotype and score information
#' @param phenotype character vector for column name for the phenotype
#' @param score character vector for column name for score
#' @importFrom graphics boxplot
#' @export

# side by side box plots
compare_boxplots <- function(full_table, phenotype, score) {
  message("cases = 1, controls = 0")
  boxplot(full_table[[score]] ~ full_table[[phenotype]], data = full_table,
          xlab="phenotype status", ylab="PRS",
          main = "Score Distributions by Phenotype Status")
}

#' show a histogram of the distribution of scores for the individuals in the cohort
#' @name score_distribution 
#' @param full_table data.frame containing phenotype and score information 
#' @param prs character vector for column name of score column
#' @importFrom graphics hist
#' @export

score_distribtuion <- function(full_table, prs) {
  score_hist <- hist(full_table[[prs]], plot= TRUE, main = paste("Histogram of score distribution"), xlab = "prs", ylab = "frequency")
}
