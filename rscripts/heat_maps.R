library(reshape2)
library("ggplot2")
steep_matrix_plot <- melt(steep_matrix, varnames = c("relative_position_five_prime", "relative_position_three_prime"), value.name = "steep")
ggplot(steep_matrix_plot, aes(relative_position_three_prime, relative_position_five_prime, fill=steep)) + geom_raster() + geom_text(aes(label=round(steep, digits = 2)))




heatmap(steep_matrix, Rowv = NA, Colv = NA, scale = "column", revC = TRUE, 
        col = rainbow(200, start = 0, end = 1, alpha = 0.8))