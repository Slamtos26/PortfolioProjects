# If not installed, you need to install all relevant packages first
install.packages("raster")
install.packages("sp")
install.packages("randomForest")
install.packages("rgdal")
install.packages("ggplot2")
install.packages("caret")
install.packages("abind")


#load libraries
library(sf)
library(raster)
library(randomForest)
library(sp)
library(rgdal)
library(ggplot2)
library(caret)
library(abind)
set.seed(123)

# Setting-up the working directory 
#"D:\ITC\Second Year\Advanced Image Analysis\Project_Assignment"

setwd("C:\\Users\\salam\\OneDrive\\Desktop\\Random_forest Training sample")
inraster = stack('bbb.tif')
inraster

#Specify bands names

names(inraster)=c('bbb_1','bbb_2','bbb_3','bbb_4') 
plot(inraster) #Display the composite


# Import training and validation data

#==================================================================================
# Setting-up the working directory 
#D:\ITC\Second Year\Advanced Image Analysis\Project_Assignment\Lemgo\training_2023_n (2)\train23 (1)
#D:\ITC\Second Year\Advanced Image Analysis\Project_Assignment\Gamil\TrainingSet
setwd("C:\\Users\\salam\\OneDrive\\Desktop\\Random_forest Training sample")

trainingData  =  shapefile("Training.shp")

TestingData = shapefile("testing.shp")


#==================================================================================
# Extract raster values for the training samples 
#==================================================================================
pt_samples <- spsample(trainingData,3000, type='regular') # Add the land cover class to the points  
pt_samples$Classvalue <- over(pt_samples, trainingData)$type #
pt_samples$Classvalue


training_data  = extract(inraster, pt_samples)
training_response = as.factor(pt_samples$Classvalue) 
training_data

#==================================================================================
#Select the number of input variables(i.e. predictors, features)
#==================================================================================
selection<-c(1:4) 
training_predictors = training_data[,selection]

#==================================================================================
# Train the random forest
#==================================================================================

ntree = 30    #number of trees to produce per iteration
mtry = 3       # number of variables used as input to split the variables
r_forest = randomForest(training_predictors, y=training_response, mtry=mtry, ntree = ntree, keep.forest=TRUE, importance = TRUE, proximity=TRUE)

#===================================================================================
#Investigate the OOB (Out-Of-the bag) error
#===================================================================================
r_forest

# Assessment of variable importance
#===================================================================================
imp =importance(r_forest)  #for ALL classes individually
imp                        #display importance output in console
varImpPlot(r_forest)
varUsed(r_forest)
importance(r_forest)

#=======================================================================================
#Evaluate the impact of the mtry on the accuracy
#========================================================================================

mtry <- tuneRF(training_predictors,training_response, ntreeTry=ntree,
               stepFactor=1.5,improve=0.01, trace=TRUE, plot=TRUE)
best.m <- mtry[mtry[, 2] == min(mtry[, 2]), 1]
print(mtry)
print(best.m)

#======================================================================================
#Number of tree nodes
#======================================================================================
hist(treesize(r_forest), main= "Number of Nodes for the trees",
     col= "green")

getTree(r_forest, 1, labelVar = TRUE) # inspect the tree characteristics

#==========================================================================================
# Classify the entire image:define raster data to use for classification
#=========================================================================================
predictor_data = subset(inraster, selection)	
setwd("D:/ITC/Year 2/Advanced_Image_Analaysis/Randomforest/NDVI_IMAGES/NDVI_IMAGES")#change this to your output directory if different

#==========================================================================================
# Classify the entire image
#=========================================================================================

predictions = predict(predictor_data, r_forest, format=".tif", overwrite=TRUE, progress="text", type="response")

#==========================================================================================
# Assess the classification accuracy
#=========================================================================================

Testing=extract(predictions, TestingData) # extracts the value of the classified raster at the validation point locations


confusionMatrix(as.factor(Testing), as.factor(TestingData$ClassID) )

confusionMatrix(as.factor(Testing), as.factor(TestingData$ClassID) )$byClass[, 1]
confusionMatrix(as.factor(Testing), as.factor(TestingData$ClassID) )$byClass[]
