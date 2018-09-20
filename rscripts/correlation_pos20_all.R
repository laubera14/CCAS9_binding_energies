energy_score <- read.table(file = "binding_ediff_extended_17_20_PAM.txt", header = TRUE, dec = ".")
energy_scoreG <- read.table(file = "binding_ediff_extended_17_20_PAM_G.txt", header = TRUE, dec = ".")
energy_scoreA <- read.table(file = "binding_ediff_extended_17_20_PAM_A.txt", header = TRUE, dec = ".")
energy_scoreU <- read.table(file = "binding_ediff_extended_17_20_PAM_U.txt", header = TRUE, dec = ".")
energy_scoreC <- read.table(file = "binding_ediff_extended_17_20_PAM_C.txt", header = TRUE, dec = ".")

regression <- lm(energy_score$delta_e ~ energy_score$rank)
regression
par(oma = c(1, 1, 1, 1))
plot(energy_scoreG$rank, energy_scoreG$delta_e, type = "p", pch = 1, cex = 0.5,
     main = "Energy difference sgRNA:DNA hybrid - DNA:DNA
compared to sgRNA Rank (nt 17-20 & PAM)",
     xlab = "gene Rank", ylab = expression(paste(Delta, "energy")),
     ylim = c(-4, 3.1), col = "blue")
points(energy_scoreA$rank, energy_scoreA$delta_e, type = "p", pch = 2, cex = 0.5,
       col = "red")
points(energy_scoreU$rank, energy_scoreU$delta_e, type = "p", pch = 3, cex = 0.5,
       col = "green")
points(energy_scoreC$rank, energy_scoreC$delta_e, type = "p", pch = 4, cex = 0.5,
       col = "yellow")
abline(regression, lwd = 2)
par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 1, 0, 0), new = TRUE)
plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")
legend("bottom", c("G", "A", "T", "C"), xpd = TRUE, horiz = TRUE, inset = c(0, 0),
bty = "n", pch = c(1, 2, 3, 4), col = c("blue", "red", "green", "yellow"), cex = 0.8)
cor.test(energy_score$rank, energy_score$delta_e, method = "spearman")

smoothScatter(energy_score$rank, energy_score$delta_e,
              main = "Scatter plot of energy difference sgRNA:DNA - DNA:DNA\n versus rank",
              nbin = 128, colramp = colorRampPalette(c("white", blues9)),
              nrpoints = 100, ret.selection = FALSE,
              pch = ".", cex = 1, col = "black",
              transformation = function(x) x^.25,
              postPlotHook = box,
              xlab = "rank", ylab = "delta_e",
              xaxs = par("xaxs"), yaxs = par("yaxs"))
abline(regression, lwd = 2)

max(energy_score)

plot(energy_scoreA$rank, energy_scoreA$delta_e, type = "p", pch = 1, cex = 0.5,
     main = "Energy difference sgRNA:DNA hybrid - DNA:DNA
compared to sgRNA Score (nt 17-20 & PAM)",
     xlab = "rank", ylab = expression(paste(Delta, "energy")), col = "blue")