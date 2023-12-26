## COLLINEARITY ANALYSIS AND
## STEPWISE REGRESSION PROCEDURES IN R
## using R-Studio, which can be downloaded from: http://rstudio.org/
## T.A. GROEN (TAGROEN@GMAIL.COM)
## MARCH 2012

## start with specifying the right folder
setwd("d:\\regression")
setwd("C:\\Users\\salam\\OneDrive\\Desktop\\Environmental modelling\\R statistics\\data2")
##|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
##
## COLLINEARITY ANALYSIS
##
##|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
## For this exercise we will use the same data file that we used in the 
## multiple regression exercise.
d<-read.csv("Multiple linear regression Exercise.csv",header=TRUE, sep=",")

## A first step would be to calculate pairwise correlation
## coefficients using the cor.test(x,y) function
## so for example:
cor.test(d$CanopyCover,d$MaxHeight)
cor(d2[,2:4])
## Describe the variable that defines the dataset
## check the data type and then describe and summarize the dataset
d<-read.csv("tree_data.csv",header=TRUE, sep=",")
names(d)
d
summary(d)
str(d)
## Tranform the char datatype to factor
d$Species<-as.factor(d$Species)
str(d)
summary(d)
##View(d)
## Taking dependant variable as DBH (rpoxy for wood volume)
## Independent variables;Species, Field_Ht, LiDAR.Height, Nadir.Height, CPA,  & CD.
## Test for collinearity between the variables
model.x1<-lm(d$Species~ d$Field_Ht+d$LiDAR.Height+d$Nadir.Height+d$CPA+d$CD)
model.x2<-lm(d$Field_Ht~ d$Species + d$LiDAR.Height + d$Nadir.Height + d$CPA + d$CD)
model.x3<-lm(d$LiDAR.Height~ d$Species + d$Field_Ht + d$Nadir.Height + d$CPA + d$CD)
model.x4<-lm(d$Nadir.Height~ d$Species + d$Field_Ht+ d$LiDAR.Height + d$Nadir.Height + d$CPA + d$CD)
model.x5<-lm(d$CPA~ d$Species + d$Field_Ht+ d$LiDAR.Height + d$Nadir.Height + d$CD)
model.x6<-lm(d$CD~ d$Species + d$Field_Ht+ d$LiDAR.Height + d$Nadir.Height + d$CPA)
## Alternatively run the code: model.CD <-lm(CD~ Species + Field_Ht+ LiDAR.Height + Nadir.Height + CPA, data=d)
## Running VIF 
VIF.x1 <- 1/(1-summary(model.x1)$r.squared)
VIF.x2 <- 1/(1-summary(model.x2)$r.squared)
VIF.x3 <- 1/(1-summary(model.x3)$r.squared)
VIF.x4 <- 1/(1-summary(model.x4)$r.squared)
VIF.x5 <- 1/(1-summary(model.x5)$r.squared)
VIF.x6 <- 1/(1-summary(model.x6)$r.squared)
## Call VIF
VIF.x1
VIF.x2
VIF.x3
VIF.x4
VIF.x5
VIF.x6
## The warning messages imply the error implies we are using a factor variable as the response variable in a modeling 
## function. The function model.response() is designed to handle numeric response variables. 
## When you pass a factor as the response, it treats it as a categorical variable rather than a numeric one. 
## Consequently, the 'type = "numeric"' argument is ignored because it is not applicable to factors.
## Models x5 and x6 have VIF greater than 10,  but we need to check specifically if the 2 have collinearity
model.x5a<-lm(d$CPA~ d$Species + d$Field_Ht+ d$LiDAR.Height + d$Nadir.Height)
VIF.x5a <- 1/(1-summary(model.x5a)$r.squared)
VIF.x5a
model.x6a<-lm(d$CD~ d$Species + d$Field_Ht+ d$LiDAR.Height + d$Nadir.Height)
VIF.x6a <- 1/(1-summary(model.x6a)$r.squared)
VIF.x6a

# We model the regression that gives the best goodness of fit based on the selected variables
regr.model<-lm(d$DBH~ d$Species + d$Field_Ht+ d$LiDAR.Height + d$Nadir.Height + d$CD)
summary(regr.model)
## We note that species and nadir height are statistically insignificant in explaining the DBH. 
## We analyse for goodness of fit wrt variables by conducting the stepwise backward regression....this 
## eliminates irrelevant varaibles
model.small<-lm(d$DBH~ 1)
model.large<-lm(d$DBH~ d$Species + d$Field_Ht+ d$LiDAR.Height + d$Nadir.Height + d$CD)
model.backw<-step(model.large,scope=list(lower=model.small,upper=model.large),direction="backward")
## Going by the  AIC values, the best model is d$DBH ~ d$LiDAR.Height + d$CD and rerun the reg.model
regr.model2<-lm(d$DBH~ d$LiDAR.Height + d$CD)
summary(regr.model2)
##plot(reg.model2)
##plot(regr.model2)
## The observed r squares for the first reg and second reg model have not changed much i.e 87%
## the final reg model is
##||| DBH= -9.2676 + 1.0642*LiDAR.Height + 7.8491*CD
## Increasing LiDAR.Height by 1m increases DBH by 1.0642 and increasing CD by 1m increases DBH by 7.8491...
#### Note this is not a feasible model, we should consider the logistsic model for the first reg.model
##> model.logistic <- glm(d$DBH~ d$Species + d$Field_Ht+ d$LiDAR.Height + d$Nadir.Height + d$CD, family="polynomial")

