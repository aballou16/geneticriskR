#' Selects column from phenotypic dataset to be used in analyses
#' @name pheno_select
#' @param pheno_table data.frame containing phenotypic information
#' @param pheno_name character vector column name of the phenotype of interest
#' @importFrom dplyr %>% 
#' @importFrom dplyr select
#' @export

pheno_select <- function(pheno_table, pheno_name){
  vars <- c(pheno_name, "age", "sex", "IID")
  pheno_table[vars]
}

#' join phenotype file with score file
#' @name join_scores
#' @param pheno_table data.frame containing phenotypic information 
#' @param score_table data.frame containing score information 
#' @importFrom dplyr %>% 
#' @importFrom dplyr inner_join
#' @export

join_scores <- function(pheno_table, score_table) {
  pheno_table %>%
    inner_join(score_table, by = "IID")
}
