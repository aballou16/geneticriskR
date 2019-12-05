# side by side box plots
compare_boxplots <- function(full_table, phenotype) {
  plot_box <- ggplot(data = full_table, aes(y = PRS, group = as.factor(phenotype), color = as.factor(phenotype))) +
    geom_boxplot() +
    ggtitle("Side by Side Box plots")
  print(p1)
}

# prevalence plot
prev_plot <- function(full_table, PRS_col, pheno_col, qtile) {
  prev_per_quantile <- function(full_table, PRS_col, prev_col, qtile) {
    if (!sum(unique(df[[pheno_col]]) == c(0, 1)) == 2) {
      message("Column for calculating prevalence of trait must be a binary variable. Expects 0 (controls) and 1 (cases).")
    }
    if (sum(qtile) < 2 * length(qtile)) { # check qtile
      message("q-quantiles should be number of divisions for data set and must be greater than 1")
    }
    ## initialize data structures
    p <- (100 / qtile) / 100
    index <- c(seq(from = 0, to = 1, by = p) * 100)
    prevalences <- rep(NA, qtile + 1) # initialize prevalence vector
    ns <- rep(NA, qtile + 1) # initialize count vector
    ses <- rep(NA, qtile + 1) # initialize se vector
    tiles <- quantile(df[[PRS_col]], seq(from = 0, to = 1, by = p)) # quantile values
    for (i in 1:length(index) - 1) {
      prev_list <- df[df[[PRS_col]] > tiles[i] & df[[PRS_col]] <= tiles[i + 1], ][[pheno_col]]
      prevalences[i] <- sum(prev_list) / length(prev_list) # how many affected in given quantile
      ns[i] <- length(prev_list)
      ses[i] <- sqrt((prevalences[i] * (1 - prevalences[i])) / length(prev_list)) # SE
    }
    ## create object
    pq <- list(prev = prevalences, se = ses, i = index, n = ns, tiles = tiles)
    class(pq) <- "prev_quantile_obj"
    return(pq)
  }
  pq <- prev_per_quantile(full_table, PRS_col, pheno_col, qtile)
  pqdf <- data.frame(prev = pq$prev, se = pq$se, i = pq$i, tiles = pq$n, pq$tiles)

  pqdf$frac <- pqdf$i / 100

  pqdf <- pqdf[pqdf$frac != 1.00, ]
  pqdf$ub <- pqdf$prev + (1.96 * pqdf$se)
  pqdf$lb <- pqdf$prev - (1.96 * pqdf$se)
  ymax <- max(pqdf$ub)

  main <- "Prevalence Plot"
  xlab <- "PRS"
  ylab <- "Prevalence"
  if (unique(pqdf$i) > 10) {
    breaks <- c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100)
  } else {
    breaks <- pqdf$frac
  }
  pdf(file = "prevplot.pdf", height = 5, width = 5, useDingbats = FALSE)
  ggplot(pqdf, aes(x = frac, y = prev, color = as.factor(1))) +
    geom_point() +
    scale_color_manual(values = c("grey")) +
    geom_errorbar(aes(ymin = pqdf$lb, ymax = pqdf$ub), color = "grey") +
    theme_bw() +
    labs(title = main) +
    xlab(xlab) +
    ylab(ylab) +
    coord_cartesian(ylim = c(0, ymax)) +
    theme(legend.position = "none")
  dev.off()
}

# Distribution of Scores
score_distribution <- function(full_table) {
  score_dist <- ggplot(data = full_table, aes(x = PRS)) +
    geom_histogram()
}
