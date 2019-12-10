#' compares the prs for the cases and controls 
#' @name compare_boxplots
#' @param full_table data.frame containing phenotype and score information
#' @param phenotype column name for the phenotype
#' @param score column name for score
#' @importFrom graphics boxplot
#' @export

# side by side box plots
compare_boxplots <- function(full_table, phenotype, score, ...) {
  boxplot(score ~ phenotype, data = full_table,
          xlab="phenotype status", ylab="PRS",
          main = "Score Distributions by Phenotype Status")
}

#' creates a plot that depicts the relationship between PRS decile and phenotypic prevalence in the cohort
#' @name prev_plot
#' @param full_table data.fram containing phenotype and score information 
#' @param PRS_col character vector corresponding to column name for scores
#' @param pheno_col character vector corresponding to column name for phenotype
#' @param qtile number of quantile desired 
#' @param prs_num column number corresponding to score column
#' @param pheno_num column number corresponding to phenotype column
#' @import ggplot2
#' @export


prev_plot <- function(full_table, prs_col, pheno_col, prs_num, pheno_num, qtile) {
  prev_per_quantile <- function(full_table, prs_col, pheno_col, qtile){
    ##initialize data structures
    p<-(100/qtile)/100
    index<-c(seq(from=0,to=1,by=p)*100)
    prevalences<-rep(NA,qtile+1) #initialize prevalence vector
    ns<-rep(NA,qtile+1) #initialize count vector
    ses<-rep(NA,qtile+1)#initialize se vector
    tiles<-quantile(full_table[[prs_col]],seq(from=0,to=1,by=p)) #quantile values
    for (i in 1:length(index)-1) {
      prev_list<-full_table[full_table[[prs_col]] > tiles[i] & full_table[[prs_col]] <= tiles[i+1],][[pheno_col]]
      prevalences[i]<-sum(prev_list)/length(prev_list) #how many affected in given quantile
      ns[i]<-length(prev_list)
      ses[i]<-sqrt((prevalences[i]*(1-prevalences[i]))/length(prev_list)) #what is SE for this prevalence
    }
    ##create object
    pq<-list(prev=prevalences,se=ses,i=index,n=ns,tiles=tiles)
    class(pq)<-"prev_quantile_obj"
    return(pq)
  }
  
  pq <- prev_per_quantile(full_table,prs_num,pheno_num,qtile)
  pqdf<-data.frame(prev=pq$prev,se=pq$se,i=pq$i,tiles=pq$n,pq$tiles)
  
  pqdf$frac=pqdf$i/100
  
  pqdf<-pqdf[pqdf$frac!=1.00,]
  pqdf$ub<-pqdf$prev+(1.96*pqdf$se)
  pqdf$lb<-pqdf$prev-(1.96*pqdf$se)
  ymax<-max(pqdf$ub) 
  
  if (unique(pqdf$i) > 10) {breaks=c(0,10,20,30,40,50,60,70,80,90,100)} else {breaks=pqdf$frac}
  pdf(file = "prevplot.pdf", height = 5, width = 5, useDingbats = FALSE)
  ggplot(pqdf,aes(x=frac,y=prev,color=as.factor(1))) + 
    geom_point() +
    scale_color_manual(values=c("grey")) +
    geom_errorbar(aes(ymin=pqdf$lb,ymax=pqdf$ub),color="grey")  +
    theme_bw() + 
    labs(title="Prev Plot") + 
    xlab(PRS) + 
    ylab(Prevalence)  + 
    coord_cartesian(ylim=c(0,ymax)) +
    theme(legend.position="none")
  dev.off()
}


#' show a histogram of the distribution of scores for the individuals in the cohort
#' @name score_distribution 
#' @param full_table data.frame containing phenotype and score information 
#' @param prs character vector for column name of score column
#' @importFrom graphics hist
#' @export

score_distribtuion <- function(full_table, prs) {
  score_hist <- hist(full_table[[prs]], plot= TRUE)
}




