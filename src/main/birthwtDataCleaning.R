#Initialization
library(MASS) #Install if not used
birthweight <- birthwt[,-1] #Initialize, Drop low (Redundant)

#Factor Type Conversion:
birthweight$race <- as.factor(birthweight$race)
levels(birthweight$race) <- c("white", "black", "other")
birthweight$smoke <- as.factor(birthweight$smoke)
birthweight$ht <- as.factor(birthweight$ht)
birthweight$ui <- as.factor(birthweight$ui)

#All Model:
bwtALL <- lm(bwt ~ ., data = birthweight)
summary(bwtALL)

#From our Regression Model, Uterine Irritability Appears as the most significant
#regressor on the response bwt. Use ANOVA to confirm significance:

bwtNoUI <- lm(bwt ~ age + lwt + race + smoke + ptl + ht + ftv, 
              data = birthweight)
anova(bwtNoUI, bwtALL)

#With p-value < 0.0003, UI is significant.
#As such, we will create 2 KDEs based off of the
#factor UI and plot them against one another.

#Subset the Data:
birthweightUI0 <- birthweight[birthweight$ui == 0,]
birthweightUI1 <- birthweight[birthweight$ui == 1,]

#Export as CSV for KDE Coding:
write.csv(birthweightUI0, "../../volume/birthweightUI0.csv")
write.csv(birthweightUI1, "../../volume/birthweightUI1.csv")