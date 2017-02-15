basePath <- "./data/UCI HAR Dataset/"

# This function reads a specific data set (train or test) from text file
readDataSet <- function(dataSetType, colNames, activityMap) {
  
  # Format paths to retrieve the data set
  dataSetPath <- paste(basePath, sprintf("%s/X_%s.txt", dataSetType, dataSetType), sep = "")
  activityLabelPath <- paste(basePath, sprintf("%s/y_%s.txt", dataSetType, dataSetType), sep = "")
  subjectPath <- paste(basePath, sprintf("%s/subject_%s.txt", dataSetType, dataSetType), sep = "")
  
  # Read data from the .txt files
  dataSet <- read.table(dataSetPath, col.names = colNames)
  activityLabels <- read.table(activityLabelPath, col.names = c("activity.id"))
  subjects <- read.table(subjectPath, col.names = c("subject.id"))
  
  # Assign additional data to variables of the data frame
  dataSet$activity.id <- activityLabels$activity.id
  dataSet$subject.id <- subjects$subject.id
  
  # Match activity ids with activity type and add it to the data frame
  dataSet$activity <- with(activityMap, activity.type[match(dataSet$activity.id, activity.id)])
  
  # Filter out columns that are not mean, std, subject.id or activity
  varNames <- names(dataSet)
  stdVarNames <- varNames[grepl('^.+\\.std\\..*$', varNames, ignore.case = TRUE)]
  meanVarNames <- varNames[grepl('^.+\\.mean\\..*$', varNames, ignore.case = TRUE)]
  remVarNames <- c("activity","subject.id",rbind(meanVarNames,stdVarNames))
  
  # Return the data frame
  dataSet[,remVarNames]
}

# This function reads activity mapping from disk
readActivityMap <- function() {
  
  # Format path to retrieve activity map
  activityMapPath <- paste(basePath, "activity_labels.txt", sep = "")
  
  # Read map from .txt file
  activityMap <- read.table(activityMapPath, col.names = c("activity.id", "activity.type"))
  
  # Return the activity map
  activityMap
}

# This function reads the feature vector from disk
readFeatureVector <- function() {
  # Format path to retrieve activity map
  featureVectorPath <- paste(basePath, "features.txt", sep = "")
  
  # Read map from .txt file
  featureVector <- read.table(featureVectorPath, col.names = c("index", "feature.name"))
  
  # Return the activity map
  featureVector
}

# This function retrieves both the train and test data set and merge them.
getBigDataSet <- function() {
  
  # Prepare global data
  featureVector <- readFeatureVector()
  activityMap <- readActivityMap()
  
  # Retrieve the data sets
  trainDataSet <- readDataSet("train", featureVector$feature.name, activityMap)
  testDataSet <- readDataSet("test", featureVector$feature.name, activityMap)
  
  # Concatenate the data sets together
  rbind(trainDataSet, testDataSet)
}

getTidyDataSet <- function() {
  dataSet <- getBigDataSet()
  aggregate( . ~ activity + subject.id, dataSet, mean)
}

getTidyDataSet()