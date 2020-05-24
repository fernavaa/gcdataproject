---
title: "Codebook"
author: "Fernanda Nava"
date: "24/5/2020"
output: html_document
---


```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## The Data

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

Notes: 

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.


## Modifying the data

* Data is downloaded    

```{r echo=TRUE, eval=FALSE}
# Checking if archieve already exists.
if (!file.exists(filename)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(URL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

filespath <- file.path("./" , "UCI HAR Dataset")
files<-list.files(filespath, recursive=TRUE)
```

* Loading the datasets and merging them

```{r echo=TRUE, eval=FALSE}
# Checking if archieve already exists.
ytest  <- read.table(paste(sep = "",file.path(filespath, "test" , "Y_test.txt" )))
ytrain <- read.table(paste(sep = "",file.path(filespath, "train", "Y_train.txt")))

ymerge<-rbind(ytest, ytrain)

subjecttrain <- read.table(paste(sep = "",file.path(filespath, "train", "subject_train.txt")))
subjecttest  <- read.table(paste(sep = "",file.path(filespath, "test" , "subject_test.txt")))

subjectmerge<-rbind(subjecttest,subjecttrain)

xtest  <- read.table(paste(sep = "",file.path(filespath, "test" , "X_test.txt" )))
xtrain <- read.table(paste(sep = "",file.path(filespath, "train", "X_train.txt")))

xmerge<-rbind(xtest, xtrain)
```

* Reading the names from the features files and adding them to the x set

```{r echo=TRUE, eval=FALSE}

str(xmerge)

xnames<-read.table(paste(sep = "",file="UCI HAR Dataset/features.txt"))
xnames

names(xmerge)<-xnames[,2]
str(xmerge)

```


* Keeping only columns that contain mean or standard deviation
```{r echo=TRUE, eval=FALSE}
keepcols<-grep("-(mean|std).*", xnames[,2])
keepcols

features<-xmerge[keepcols]


```

* Adding subject and activity, labelling them accordingly
```{r echo=TRUE, eval=FALSE}
mergedDataSet<-cbind(subjectmerge, ymerge, features)

colnames(mergedDataSet)[1]<-"subject"
colnames(mergedDataSet)[2]<-"activity"

```

* Modifications to variable names. f replaced for frequency and t for time. Abbreviated words susbtituted for whole words. Getting rid of symbols. 
```{r echo=TRUE, eval=FALSE}
names(mergedDataSet)<-gsub("BodyBody", "Body", names(mergedDataSet))
names(mergedDataSet)<-gsub("^t", "time", names(mergedDataSet))
names(mergedDataSet)<-gsub("^f", "frequency", names(mergedDataSet))
names(mergedDataSet)<-gsub("-mean", "Mean", names(mergedDataSet), ignore.case = TRUE)
names(mergedDataSet)<-gsub("-std", "STD", names(mergedDataSet), ignore.case = TRUE)
names(mergedDataSet)<-gsub("-freq", "Frequency", names(mergedDataSet), ignore.case = TRUE)
names(mergedDataSet)<-gsub("\\(", "", names(mergedDataSet))
names(mergedDataSet)<-gsub("\\)", "", names(mergedDataSet))
names(mergedDataSet)<-gsub("\\-", ".", names(mergedDataSet))
names(mergedDataSet)<-gsub("Acc", "Accelerometer", names(mergedDataSet), ignore.case = TRUE)
names(mergedDataSet)<-gsub("Mag", "Magnitude", names(mergedDataSet), ignore.case = TRUE)

```

* Creation of new data set. Using aggregate function to get a mean by subject and activity.
```{r echo=TRUE, eval=FALSE}
newDataSet<-aggregate(. ~subject + activity, mergedDataSet, mean)
newDataSet<-newDataSet[order(newDataSet$subject,newDataSet$activity),]
write.table(newDataSet, file = "tidydataset.txt",row.name=FALSE)

```
