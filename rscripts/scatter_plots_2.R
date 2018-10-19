setwd("C:/Users/arnel/Documents/Uni Wien/Bachelor Thesis/CCAS9_binding_energies-master/output/shortening_from_3_prime_incl_PAM")

five_prime <- c(1)
three_prime <- c(4:23)
par(mfrow=c(5,4))
par(mar=c(2,2,2,1), oma = c(0, 0, 2, 0))
steep_vector <- vector()

for (i in 1:20) {
  current_file <- paste("binding_ediff_", five_prime[1], "-", three_prime[i], ".txt", sep = "")
  current_plot <- paste("nt ", five_prime[1], "-", 
                        three_prime[i], sep = "")
  print(current_file)
  print(current_plot)
  
  ediff_data <- read.table(file = current_file, header = TRUE, dec = ".")
  regression <- lm(ediff_data$delta_e ~ ediff_data$rank)
  print(regression)
  steep <- summary(regression)$coefficients[2,1]
  steep_vector <- c(steep_vector, steep)
  
  plot(ediff_data$rank, ediff_data$delta_e, type = "p", pch = 1, cex = 0.5, 
       main = current_plot, ylim = c(-5, 5),
       xlab = "geneRank", ylab = expression(paste(Delta, "energy")))
  abline(regression, lwd = 2, col="purple")
}
mtext("Energy difference 'sgRNA:DNA' - 'DNA:DNA' compared to sgRNA Rank", outer = TRUE, cex = 1.4)

steep_matrix <- matrix(steep_vector, nrow = 5, ncol = 4, byrow = TRUE)

