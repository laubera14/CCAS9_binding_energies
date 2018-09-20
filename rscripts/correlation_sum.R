hybrid_data <- read.table(file = "RNADNA_extended_sum.txt", header = TRUE, dec = ".")
DNA_data <- read.table(file = "DNADNA_extended_sum.txt", header = TRUE, dec = ".")

ediff <- hybrid_data$delta_e-DNA_data$delta_e
ediff
regression <- lm(ediff ~ hybrid_data$rank)
plot(hybrid_data$rank, ediff, type = "p", pch = 1, cex = 0.5, 
     main = "Energy difference sgRNA:DNA hybrid - DNA:DNA
compared to sgRNA Rank (nt 14-18 & PAM)",
     xlab = "geneRank", ylab = expression(paste(Delta, "energy")))
abline(regression, lwd = 2)
suppressWarnings(
  cor.test(hybrid_data$rank, ediff, method = "spearman")
)
regression

energy <- ediff
calculated <- mean(energy)
calculated