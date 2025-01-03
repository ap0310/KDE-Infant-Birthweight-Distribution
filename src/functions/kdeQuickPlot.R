#Quick Call Plot Function (QoL):
kdeQuickPlot <- function(x, bwth = "nrd0", krn = "gaussian", mn = "Title"){
  plot(density(x, bw = bwth, kernel = krn), main = mn) #KDE
}
