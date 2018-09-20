energy_score <- read.table(file = "1binding_ediff.txt", header = TRUE, dec = ".")
energy_scoreG <- read.table(file = "1binding_ediff_pos20G.txt", header = TRUE, dec = ".")
energy_scoreA <- read.table(file = "1binding_ediff_pos20A.txt", header = TRUE, dec = ".")
energy_scoreU <- read.table(file = "1binding_ediff_pos20U.txt", header = TRUE, dec = ".")
energy_scoreC <- read.table(file = "1binding_ediff_pos20C.txt", header = TRUE, dec = ".")

regression <- lm(energy_scoreC$delta_e ~ energy_scoreC$sgRNAScore)
regression
plot(energy_scoreC$sgRNAScore, energy_scoreC$delta_e, type = "p", pch = 4, cex = 0.5,
     main = "Scatter plot of energy difference sgRNA:DNA - DNA:DNA\n versus sgRNAScore (C at position 20)",
     xlab = "sgRNAScore", ylab = "delta_e", col = "yellow")
points(energy_scoreA$sgRNAScore, energy_scoreA$delta_e, type = "p", pch = 2, cex = 0.5,
       col = "red")
points(energy_scoreU$sgRNAScore, energy_scoreU$delta_e, type = "p", pch = 3, cex = 0.5,
       col = "green")
points(energy_scoreC$sgRNAScore, energy_scoreC$delta_e, type = "p", pch = 4, cex = 0.5,
       col = "yellow")
abline(regression, lwd = 2)
cor.test(energy_scoreC$sgRNAScore, energy_scoreC$delta_e, method = "spearman")

smoothScatter(energy_score$sgRNAScore, energy_score$delta_e,
              main = "Scatter plot of energy difference sgRNA:DNA - DNA:DNA\n versus sgRNAScore",
              nbin = 128, colramp = colorRampPalette(c("white", blues9)),
              nrpoints = 100, ret.selection = FALSE,
              pch = ".", cex = 1, col = "black",
              transformation = function(x) x^.25,
              postPlotHook = box,
              xlab = "sgRNAScore", ylab = "delta_e",
              xaxs = par("xaxs"), yaxs = par("yaxs"))
abline(regression, lwd = 2)

max(energy_score)