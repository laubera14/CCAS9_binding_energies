ediff_data <- read.table(file = "binding_ediff_1_20_PAM_19.txt", header = TRUE, dec = ".")
regression <- lm(ediff_data$delta_e ~ ediff_data$rank)
plot(ediff_data$rank, ediff_data$delta_e, type = "p", pch = 1, cex = 0.5, 
     main = "Energy difference sgRNA:DNA hybrid - DNA:DNA
compared to sgRNA Rank (nt 1-20 & PAM)",
     xlab = "geneRank", ylab = expression(paste(Delta, "energy")))
abline(regression, lwd = 2)
suppressWarnings(
  cor.test(ediff_data$rank, ediff_data$delta_e, method = "spearman")
)
regression

energy <- ediff_data$delta_e
calculated <- mean(energy)
calculated

shapiro.test(ediff_data$rank)


ediff_data <- read.table(file = "binding_ediff_data_rank_3prime_T.txt", header = TRUE, dec = ".")
ediff_data
regression <- lm(ediff_data$delta_e ~ ediff_data$sgScore)
regression
plot(ediff_data$sgScore, ediff_data$delta_e, xlab = "geneRank", ylab = expression(Delta))
abline(regression, lwd = 2)
cor.test(ediff_data$sgScore, ediff_data$delta_e, method = "spearman")

