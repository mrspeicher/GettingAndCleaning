## This script uses the UCI HAR Dataset downloaded from 
## https://d396qusza40orc.cloudfront.net/ (more)
## getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## First merge the training and the test sets to create one data set
## Then extract the mean and standard deviation for each desired measurement 
## Put them in a new table
## Provide descriptive column names for the activities in the data set as column names
## Create a tidy data set with the avg of each var for each activity within each subject

## First merge the training and the test sets to create one data set
## Set working directory to the location where the UCI HAR Dataset was unzipped

setwd('/Users/mspeicher/Documents/Coursera/UCI HAR Dataset/');

## Read in the training and test data from files

training = read.csv("./train/X_train.txt", sep="", header=FALSE)
training[,562] = read.csv("./train/Y_train.txt", sep="", header=FALSE)
training[,563] = read.csv("./train/subject_train.txt", sep="", header=FALSE)

testing = read.csv("./test/X_test.txt", sep="", header=FALSE)
testing[,562] = read.csv("./test/Y_test.txt", sep="", header=FALSE)
testing[,563] = read.csv("./test/subject_test.txt", sep="", header=FALSE)

activityLabels = read.csv("./activity_labels.txt", sep="", header=FALSE)

## Assign column names

features = read.csv("./features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

## Combine training and test data to create the final data set

allData = rbind(training, testing)

## Get only the data on mean and SD

colsWeWant <- grep(".*Mean.*|.*Std.*", features[,2])
features <- features[colsWeWant,]

## Now add the last two columns (subject and activity)

colsWeWant <- c(colsWeWant, 562, 563)

## Remove the unwanted columns from allData

allData <- allData[,colsWeWant]

## Add the column names (features) to allData

colnames(allData) <- c(features$V2, "Activity", "Subject")
colnames(allData) <- tolower(colnames(allData))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  allData$activity <- gsub(currentActivity, currentActivityLabel, allData$activity)
  currentActivity <- currentActivity + 1
}

allData$activity <- as.factor(allData$activity)
allData$subject <- as.factor(allData$subject)

## Create a new tidy data set with the average of each variable
## For each activity and each subject

tidy = aggregate(allData, by=list(activity = allData$activity, subject=allData$subject), mean)

## create a new table without the subject and activity columns

tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "tidy.txt", sep="\t")
