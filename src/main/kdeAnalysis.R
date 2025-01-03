#NOTE 1: Open birthwtDataCleaning to get/analyze dataset.

#NOTE 2: Since Data has been separated by Uterine Irritability (0,1), we only
#care about response. As such, we only keep column bwt (response).

#Import kdeQuickPlot (Optional, QoL):
source("../functions/kdeQuickPlot.R")

#Import Cleaned Data:
bwtUI0 <- read.csv("../../volume/birthweightUI0.csv")[,10] #UI = 0 bwt
bwtUI1 <- read.csv("../../volume/birthweightUI1.csv")[,10] #UI = 1 bwt

#Merging & Classification:
bwt <- as.data.frame(matrix(NA, nrow = 189, ncol = 2))
bwt[1:161,] <- c(bwtUI0, rep(0,161))
bwt[162:189,] <- c(bwtUI1, rep(1,28))
colnames(bwt) <- c("weight", "hasUI")

#Plotting Time:

#A: Different Kernels:

png("../../volume/KDE_kernel_choices.png",
    width = 600,
    height = 360)

par(mfrow = c(2,3))
kdeQuickPlot(bwt$weight[bwt$hasUI == 0], "nrd0", "g", "Gaussian, UI = 0")
kdeQuickPlot(bwt$weight[bwt$hasUI == 0], "nrd0", "r", "Uniform, UI = 0")
kdeQuickPlot(bwt$weight[bwt$hasUI == 0], "nrd0", "e", "Epanechnikov, UI = 0")
kdeQuickPlot(bwt$weight[bwt$hasUI == 1], "nrd0", "g", "Gaussian, UI = 1")
kdeQuickPlot(bwt$weight[bwt$hasUI == 1], "nrd0", "r", "Uniform, UI = 1")
kdeQuickPlot(bwt$weight[bwt$hasUI == 1], "nrd0", "e", "Epanechnikov, UI = 1")

dev.off()

#B: Different Bandwidths:

#For Plug-in Selection Bandwidth:
install.packages("ks")
library(ks)

#UI = 0
nrd00 <- bw.nrd0(bwt$weight[bwt$hasUI == 0]) #Scott's
nrd_0 <- bw.nrd(bwt$weight[bwt$hasUI == 0]) #Silverman's
bcv0 <- bw.bcv(bwt$weight[bwt$hasUI == 0]) #Biased CV (Smaller Variance)
pis0 <- hpi(bwt$weight[bwt$hasUI == 0]) #Plug-in Selection

#UI = 1
nrd01 <- bw.nrd0(bwt$weight[bwt$hasUI == 1]) #Scott's
nrd_1 <- bw.nrd(bwt$weight[bwt$hasUI == 1]) #Silverman's
bcv1 <- bw.bcv(bwt$weight[bwt$hasUI == 1]) #Biased CV (Smaller Variance)
pis1 <- hpi(bwt$weight[bwt$hasUI == 1]) #Plug-in Selection

#Plot using Epanechnikov Kernel:

png("../../volume/KDE_bandwidth_choices.png",
    width = 1000,
    height = 500)

par(mfrow = c(2,4))
kdeQuickPlot(bwt$weight[bwt$hasUI == 0], nrd00, "e", "Scott's UI0")
kdeQuickPlot(bwt$weight[bwt$hasUI == 0], nrd_0, "e", "Silverman's UI0")
kdeQuickPlot(bwt$weight[bwt$hasUI == 0], bcv0, "e", "Biased CV UI0")
kdeQuickPlot(bwt$weight[bwt$hasUI == 0], pis0, "e", "Plug-in Select UI0")
kdeQuickPlot(bwt$weight[bwt$hasUI == 1], nrd01, "e", "Scott's UI1")
kdeQuickPlot(bwt$weight[bwt$hasUI == 1], nrd_1, "e", "Silverman's UI1")
kdeQuickPlot(bwt$weight[bwt$hasUI == 1], bcv1, "e", "Biased CV UI1")
kdeQuickPlot(bwt$weight[bwt$hasUI == 1], pis1, "e", "Plug-in Select UI1")

dev.off()

#C: Plotting KDE0 vs. KDE1 vs. Generalized KDE:
#Using Epanechnikov kernel and Scott's Rule of Thumb:

kdeALL <- density(bwt$weight, bw = "nrd0", kernel = "e")
kde0 <- density(bwt$weight[bwt$hasUI == 0], bw = "nrd0", kernel = "e")
kde1 <- density(bwt$weight[bwt$hasUI == 1], bw = "nrd0", kernel = "e")

#Data Frame:
kdeDF <- cbind(kde0[["x"]], kde0[["y"]], 
               kde1[["x"]], kde1[["y"]], 
               kdeALL[["x"]], kdeALL[["y"]])
colnames(kdeDF) <- c("xUI0", "yUI0", "xUI1", "yUI1", "xUIALL", "yUIALL")

#Plotting Comparison:
library(ggplot2)

png("../../volume/KDE_UIPlot.png",
    width = 800,
    height = 400)

ggplot(kdeDF) +
  geom_line(aes(x = xUI0, y = yUI0, color = "0"), lty = "dashed") +
  geom_line(aes(x = xUI1, y = yUI1, color = "1"), lty = "dashed") +
  geom_line(aes(x = xUIALL, y = yUIALL, color = "all"), lwd = 0.75) +
  labs(title = "Effect Plot of Uterine Irritability on Infant Weight (Scott's Rule of Thumb & Epanechnikov Kernel)",
       x = "Infant Weight (grams)",
       y = "Density",
       color = "Uterine Irritabity") +
  theme(legend.position = c(.95, .8)) +
  scale_color_manual(values = c("red", "blue", "black"))

dev.off()

#D: Demonstrating Overfitting, Underfitting, and Properly fitting:

png("../../volume/KDE_FitComparison.png",
    width = 800,
    height = 400)

par(mfrow = c(1,3))
kdeQuickPlot(bwt$weight, 50, "g", "Underfitted")
kdeQuickPlot(bwt$weight, 5000, "g", "Overfitted")
kdeQuickPlot(bwt$weight, "nrd0", "g", "Properly Fitted")

dev.off()

#E: Demonstrating h -> 0 and h -> inf:

png("../../volume/BandwidthLimits.png",
    width = 800,
    height = 400)

par(mfrow = c(1,2))
kdeQuickPlot(bwt$weight, 1e-56, "g", "h -> 0")
kdeQuickPlot(bwt$weight, 1e+156, "g", "h -> inf")

dev.off()
