
## **Code Book for Course Project (Getting and Cleaning Data - getdata-009)**

##Contents:
1. **Section-1. Purpose**
1. **Section-2. Source of Data**
2. **Section-3. Steps in run_analysis.R**
3. **Section-4. Tidy data column descriptions**
4. **Section-5. Creating descriptive row and column names**
5. **Section-6. Creating tidy data**

## 

###SECTION-1

The purpose of this project is to collect, manipulate and clean an accelerometer datadata set and prepare a tidy data set for further analysis. 

###SECTION-2

Original dataset for analysis (from Samsung Galaxy S smartphone):
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Raw data for analysis downloaded from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


###SECTION-3

**Steps in the run_analysis.R to create the tidy data set:**

1. read X, y and subject data for both train and test datasets
2. merge X, y and subject data for both train and test datasets using row bind
3. read in features descriptions
4. set descriptive names for all columns in merged X, y and subject data
5. select features containing measurements on the mean and standard deviation
6. read in activity descriptions
7. join activity dataset with descriptive labels
8. join measurements dataset with activity labels
9. join data set with subject ids
10. summarize means per unique (activity, subject) pair
11. write this final result data set to text file


###SECTION-4

**Column description of the new tidy dataset:**

Column Number | Column Name | Column Description
------------- | ------------| -------------------
1 | activity | Descriptive name of the activity of the subject
2 | subject | Test subject id
3 to 68 | Formatted mean and standard deviation Columns names | Represents the average mean and standard deviavtion of measurements.  


###SECTION-5

**Methods applied to create descriptive and readable row and column names:**

* Removing underscore from column names
* Converting to lower case column names
* Conforming to Camel Case naming convention
* Removing "()" from variable names
* For column names with two words, capitalizing the first character of the second word to make it more readable


###SECTION-6

**Methods applied to create the TIDY dataset:**

1. Create a merged dataset combining the mean and std related measurements, activity and subjects
2. Using "melt" function, melt the combined dataset with 'subject' and 'activity' as id columns. This was done to assist in further reshaping of the data
3. Using "dcast" function, reshape the data by listing the average of each measurement (mean, std) for each (activity and subject) combination

