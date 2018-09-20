energy_scoreA <- read.table(file = "1binding_ediff_pos20A.txt", header = TRUE, dec = ".")
energy_diffA <- energy_scoreA$delta_e
calculatedA <- mean(energy_diffA)

energy_scoreG <- read.table(file = "1binding_ediff_pos20G.txt", header = TRUE, dec = ".")
energy_diffG <- energy_scoreG$delta_e
calculatedG <- mean(energy_diffG)

energy_scoreC <- read.table(file = "1binding_ediff_pos20C.txt", header = TRUE, dec = ".")
energy_diffC <- energy_scoreC$delta_e
calculatedC <- mean(energy_diffC)

energy_scoreU <- read.table(file = "1binding_ediff_pos20U.txt", header = TRUE, dec = ".")
energy_diffU <- energy_scoreU$delta_e
calculatedU <- mean(energy_diffU)

bases <- c("A", "G", "C", "U")
energies <- c(calculatedA, calculatedG, calculatedC, calculatedU)

all_energies <- data.frame(bases, energies)
all_energies
