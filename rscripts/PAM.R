ediff_data <- read.table(file = "binding_ediff_extended_18_20_PAM.txt", header = TRUE, dec = ".")
ediff <- ediff_data$delta_e

mean_value <- mean(ediff)
mean_value

max_value <- max(ediff)
max_value

min_value <- min(ediff)
min_value