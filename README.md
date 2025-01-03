# Summary
This report uses regression analysis to discover underlying health risks in mothers that may be correlated with differences in infant birthweight. This is done by applying Kernel Density Estimation (KDE) between mother health factors to model infant birthweight distribution. The mathematical theory, kernel optimization, and bandwidth selection techniques in the analysis are discussed in the report. Last edited: 12/7/2024

## LaTeX Code
Folder containing LaTeX code, bibliography, and figures used in the report.

## Infant-Birthweight-KDE.pdf
Generated report from LaTeX Code primarily discussing Uterine Irritability in mothers as the most significant risk factor for low infant birthweight.

## src
Folder containing 2 subfolders: main and functions

### main
Contains all R code written to generate volume folder contents and code written for performing data analysis in the report.

### functions
Contains 1 function, kdeQuickPlot, used to create plots using the density function in R's base quickly and concisely.

## volume
Folder containing csv spreadsheets and figures generated from R code written in the src/main folder.
