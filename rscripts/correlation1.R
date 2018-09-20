energy_score <- read.table(file = "binding_ediff_3prime.txt", header = TRUE, dec = ".")
energy_score
regression <- lm(energy_score$delta_e ~ energy_score$sgRNAScore)
regression
plot(energy_score$sgRNAScore, energy_score$delta_e, type = "p", pch = 1, cex = 0.5,
     main = "Scatter plot of energy difference DNA:DNA - sgRNA:DNA\n versus sgRNAScore",
     xlab = "sgRNAScore", ylab = "delta_e")
abline(regression, lwd = 2)
cor.test(energy_score$sgRNAScore, energy_score$delta_e, method = "spearman")

smoothScatter(energy_score$sgRNAScore, energy_score$delta_e,
              main = "Scatter plot of energy difference sgRNA:DNA - DNA:DNA \n versus sgRNAScore",
              nbin = 128, colramp = colorRampPalette(c("white", blues9)),
              nrpoints = 100, ret.selection = FALSE,
              pch = ".", cex = 1, col = "black",
              transformation = function(x) x^.25,
              postPlotHook = box,
              xlab = "sgRNAScore", ylab = "delta_e",
              xaxs = par("xaxs"), yaxs = par("yaxs"))
abline(regression, lwd = 2)

max(energy_score)