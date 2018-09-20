energy_score <- read.table(file = "binding_ediff_rank_3prime_T.txt", header = TRUE, dec = ".")
energy_score
regression <- lm(energy_score$delta_e ~ energy_score$rank)
regression
plot(energy_score$rank, energy_score$delta_e, xlab = "geneRank", ylab = "delta_e")
abline(regression, lwd = 2)
cor.test(energy_score$rank, energy_score$delta_e, method = "spearman")