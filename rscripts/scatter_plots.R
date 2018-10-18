setwd("C:/Users/arnel/Documents/Uni Wien/Bachelor Thesis/CCAS9_binding_energies-master/output/chortening_from_5_prime_incl_PAM")

five_prime <- c(1:23)
three_prime <- c(23)
par(mfrow=c(5,4))
par(mar=c(2,2,2,1), oma = c(0, 0, 2, 0))

for (i in 1:20) {
  current_file <- paste("binding_ediff_", five_prime[i], "-", three_prime[1], ".txt", sep = "")
  current_plot <- paste("nt ", five_prime[i], "-", 
                        three_prime[1]-3, " & PAM", sep = "")
  print(current_file)
  print(current_plot)

  ediff_data <- read.table(file = current_file, header = TRUE, dec = ".")
  regression <- lm(ediff_data$delta_e ~ ediff_data$rank)
  
  plot(ediff_data$rank, ediff_data$delta_e, type = "p", pch = 1, cex = 0.5, 
       main = current_plot, ylim = c(-5, 5),
       xlab = "geneRank", ylab = expression(paste(Delta, "energy")))
  abline(regression, lwd = 2, col="purple")
}

mtext("Energy difference 'sgRNA:DNA' - 'DNA:DNA' compared to sgRNA Rank", outer = TRUE, cex = 1.4)


