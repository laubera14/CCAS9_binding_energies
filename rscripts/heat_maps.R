library(reshape2)
library("ggplot2")
library("ggcorrplot")
steep_matrix_plot <- melt(steep_matrix, varnames = c("start", "end"), value.name = "steep")
ggplot(steep_matrix_plot, aes(end, start, fill=steep)) + geom_raster() + geom_text(aes(label=round(steep, digits = 2)))

library(reshape2)
library("ggplot2")
spearman_pvalue_matrix_plot <- melt(spearman_pvalue_matrix, varnames = c("start", "end"), value.name = "p_value")
ggplot(spearman_pvalue_matrix_plot, aes(end, start, fill=p_value)) + 
  geom_tile(color = "white") + geom_raster() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") + 
  geom_text(aes(label=round(p_value, digits = 3)))

library(reshape2)
library("ggplot2")
spearman_rho_matrix_plot <- melt(spearman_rho_matrix, varnames = c("start", "end"), value.name = "rho")
ggplot(spearman_rho_matrix_plot, aes(end, start, fill=rho)) + 
  geom_tile(color = "white") + 
  scale_fill_gradient2(low = "purple", high = "green", mid = "white", 
                       midpoint = 0, limit = c(-0.2,0.2), space = "Lab", 
                       name="rho", na.value = "mistyrose") + 
  geom_text(aes(label=round(rho, digits = 3)))
  