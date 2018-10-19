setwd("C:/Users/arnel/Documents/Uni Wien/Bachelor Thesis/CCAS9_binding_energies-master/output/gothroug_all")

five_prime <- c(1:21)
three_prime <- c(4:23)
par(mfrow=c(21,20))
par(mar=c(2,2,2,1), oma = c(0, 0, 2, 0))
steep_vector <- vector()
count <- 1
for (i in 1:21) {
  j <- 1
  if (count > 2) {j <- i-1}
  while (j <= 20) {
    current_file <- paste("binding_ediff_", five_prime[i], "-", three_prime[j], ".txt", sep = "")
    current_plot <- paste("nt ", five_prime[i], "-", 
                        three_prime[j]-3, " & PAM", sep = "")
    print(current_file)
    print(current_plot)
  
    ediff_data <- read.table(file = current_file, header = TRUE, dec = ".")
    regression <- lm(ediff_data$delta_e ~ ediff_data$rank)
    print(regression)
    steep <- summary(regression)$coefficients[2,1]
    steep_vector <- c(steep_vector, steep)
    j <- j + 1
  }
  count <- count + 1
}

steep_matrix <- matrix(steep_vector, nrow = 21, ncol = 20, byrow = TRUE)

