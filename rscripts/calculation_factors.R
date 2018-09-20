negative_slopes <- c(0.226, 0.2179, 0.06976, 0.05605, 0.09333, 0.06865, 0.03952, 0.04434, -0.05866, -0.1551, -0.2492, -0.2702, -0.2383, -0.3285, -0.4514, -0.49309, -0.5964, -0.6094, -0.5235, -0.4464)
slopes <- ((negative_slopes*-1)+0.23)*exp(4*((negative_slopes*-1)+0.23))
slopes
sum_slopes <- sum(slopes)
factors <- (1/sum_slopes)*slopes
factors
