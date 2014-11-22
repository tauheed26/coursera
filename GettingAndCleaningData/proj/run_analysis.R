#################################################
## Getting and Cleaning Data | Course Project  ##
#################################################

##########################################################################################
## STEP-0
## Read in the train and test data sets for X, y and subject data for analysis
##
## Input files have been downloaded from the following url:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
## and the top level "UCI HAR Dataset" folder downloaded in current working directory
##########################################################################################

XTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
XTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

######################################################################
## STEP-1
## Merge the train and test data sets for X, y and subject data
######################################################################

## merge the data using row bind
X <- rbind(XTrain, XTest)
y <- rbind(yTrain, yTest)
subject <- rbind(subjectTrain, subjectTest)

############################################################################################
## STEP-2
## Extracts only the measurements on the mean and standard deviation for each measurement
############################################################################################

## Extract features descriptions
features <- read.table("UCI HAR Dataset/features.txt")

## initialize the column names for X with features names
colnames(X) <- features[, "V2"]

## fetch the columns with '-mean()' in the name
meanColNames <- grep("-mean\\(\\)", features[, "V2"], value=TRUE)

## fetch the columns with '-std()' in the name
stdColNames <- grep("-std\\(\\)", features[, "V2"], value=TRUE)

## create new dataset with only mean and std columns
X2 <- X[, c(meanColNames, stdColNames)]

##########################################################################
## STEP-3
## Use descriptive activity names to name the activities in the data set
##########################################################################

## Read in activity descriptions
activityLbl <- read.table("UCI HAR Dataset/activity_labels.txt")

## Removing underscore and converting to lower case for better variable name
activityLbl[, 2] <- tolower(gsub("_", "", activityLbl[, 2]))

## Conforming to Camel Case naming convention
substr(activityLbl[2, 2], 8, 8) <- toupper(substr(activityLbl[2, 2], 8, 8))
substr(activityLbl[3, 2], 8, 8) <- toupper(substr(activityLbl[3, 2], 8, 8))

## name the columns
colnames(activityLbl) <- c("activity_id", "activity")

## Join activity dataset with descriptive labels
colnames(y) <- "activity_id"
y2 <- merge(y, activityLbl)

## Join measurements dataset with activity labels
data <- cbind(X2, y2["activity"])

######################################################################
## STEP-4
## Appropriately labels the data set with descriptive variable names.
######################################################################

## Applying good variable naming conventions

## Removing "()" from variable names
names(data) <- gsub("\\(\\)", "", names(data))

## Removing "-" in column names
names(data) <- gsub("-", "", names(data)) 

## Capitalizing 'M' to make it more readable
names(data) <- gsub("mean", "Mean", names(data))

## Capitalize 'S' to make it more readable
names(data) <- gsub("std", "Std", names(data))


######################################################################
## STEP-5
## Create the tidy data set with the average of each variable for each
## activity and each subject.
######################################################################

##load the reshape2 package (needed for 'melt' and 'dcast' function)
library(reshape2)

## assign column name to subject data
colnames(subject) <- "subject"

## join the measurement and subject data
data2 <- cbind(data, subject)

## Melt the dataset with 'subject' and 'activity' as id column
## to assist in further reshaping of the data
data2melt <- melt(data2, id=c("subject", "activity"))

## Reshape the data by listing the average of each variable
## for each (activity and subject) combination
finalData <- dcast(data2melt, activity + subject ~ variable, mean)

## write the result data set to file
write.table(finalData, "tidy_activity_subject_means.txt", row.name=FALSE)

#### NOTE ####
## "tidy_activity_subject_means.txt" is a TIDY dataset as if adheres to the following conventions:
##
### (a) Each column only represents ONE variable
### (b) Each row only consists of ONE observation
### (c) The file contains data for only ONE kind of observation
### (d) The row and column names follow better naming conventions
###
###################################################################################################



