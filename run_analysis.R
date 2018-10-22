
#**The Code Book**
##**Downloading and unzipping dataset**

fileName <- "UCIdata.zip"
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir <- "UCI HAR Dataset"

### File download verification of the download to working directory.
if(!file.exists(fileName)){
  download.file(url,fileName, mode = "wb") 
}

### File unzip verification. unzip the downloaded file.
if(!file.exists(dir)){
  unzip("UCIdata.zip", files = NULL, exdir=".")
}

## **Created an R script called run_analysis.R read and analyze data** 

### Read Data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")  

## **Analysis of data**
### 1. Merges the training and the test sets to create one data set.

Merged_dataset <- rbind(X_train,X_test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
### Create a vector of only mean and std, use the vector to subset.

Mean_SD <- grep("mean()|std()", features[, 2]) 
Merged_dataset <- Merged_dataset[,Mean_SD]

## 4. Appropriately labels the data set with descriptive activity names.
### Create vector of "Clean" feature names by getting rid of "()" apply to the Merged_dataset to rename labels.
CleanFeatureNames <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
names(Merged_dataset) <- CleanFeatureNames[Mean_SD]

### combine test and train of subject data and activity data, give descriptive lables
subject <- rbind(subject_train, subject_test)
names(subject) <- "subject"
activity <- rbind(y_train, y_test)
names(activity) <- "activity"

### combine subject, activity, and mean and std only data set to create final data set.
Merged_dataset <- cbind(subject,activity, Merged_dataset)


## 3. Uses descriptive activity names to name the activities in the data set
### group the activity column of Merged_dataset, re-name lable of levels with activity_levels, and apply it to Merged_dataset.
act_group <- factor(Merged_dataset$activity)
levels(act_group) <- activity_labels[,2]
Merged_dataset$activity <- act_group


## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

library("reshape")

### melt data to small dataset and cast means.Write the tidy data to the working directory as "tidy_data.txt"
Melted_Data <- melt(Merged_dataset,(id.vars=c("subject","activity")))
Tidy_Data2 <- cast(Melted_Data, subject + activity ~ variable, mean)
names(Tidy_Data2)[-c(1:2)] <- paste("[mean of]" , names(Tidy_Data2)[-c(1:2)] )
write.table(Tidy_Data2, "tidy_data.txt", sep = ",")


  
