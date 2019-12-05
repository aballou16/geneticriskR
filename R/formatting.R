# select columns from phenotypes table that are related to phenotype of interest
pheno_select <- function(phenotype_file, phenotype_list) {
  phenotypes <- phenotype_file %>%
    select(phenotype_list)
  return(pheno_select())
}
# might have to remove NAss here

# join phenotype file with score file
join_scores <- function(phenotype_file, score_file) {
  full_table <- phenotype_file %>%
    inner_join(score_file, by = "IID")
  return(full_table)
}
