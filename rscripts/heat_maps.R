library(reshape2)
library("ggplot2")
ggplot(melt(steep_matrix), aes(Var2,Var1, fill=value)) + geom_raster()




heatmap(steep_matrix, Rowv = NA, Colv = NA, scale = "column", revC = TRUE, 
        col = rainbow(20, start = 0, end = 0.5, alpha = 0.8))