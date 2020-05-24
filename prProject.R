##You should create one R script called run_analysis.R that does the following.

##4. Appropriately labels the data set with descriptive variable names.
##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

filename <- "Coursera_DS3_Final.zip"

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
files



##1. Merges the training and the test sets to create one data set.

ytest  <- read.table(paste(sep = "",file.path(filespath, "test" , "Y_test.txt" )))
ytrain <- read.table(paste(sep = "",file.path(filespath, "train", "Y_train.txt")))

ymerge<-rbind(ytest, ytrain)

subjecttrain <- read.table(paste(sep = "",file.path(filespath, "train", "subject_train.txt")))
subjecttest  <- read.table(paste(sep = "",file.path(filespath, "test" , "subject_test.txt")))

subjectmerge<-rbind(subjecttest,subjecttrain)

xtest  <- read.table(paste(sep = "",file.path(filespath, "test" , "X_test.txt" )))
xtrain <- read.table(paste(sep = "",file.path(filespath, "train", "X_train.txt")))

xmerge<-rbind(xtest, xtrain)


str(xmerge)

xnames<-read.table(paste(sep = "",file="UCI HAR Dataset/features.txt"))
xnames

names(xmerge)<-xnames[,2]
str(xmerge)

##2. Extracts only the measurements on the mean and standard deviation for each measurement.

keepcols<-grep("-(mean|std).*", xnames[,2])
keepcols

features<-xmerge[keepcols]
features

newDataSet<-cbind(subjectmerge, ymerge, features)

colnames(newDataSet)[1]<-"subject"
colnames(newDataSet)[2]<-"activity"


##3. Uses descriptive activity names to name the activities in the data set
names(newDataSet)<-gsub("BodyBody", "Body", names(newDataSet))
names(newDataSet)<-gsub("^t", "time", names(newDataSet))
names(newDataSet)<-gsub("^f", "frequency", names(newDataSet))
names(newDataSet)<-gsub("-mean", "Mean", names(newDataSet), ignore.case = TRUE)
names(newDataSet)<-gsub("-std", "STD", names(newDataSet), ignore.case = TRUE)
names(newDataSet)<-gsub("-freq", "Frequency", names(newDataSet), ignore.case = TRUE)
names(newDataSet)<-gsub("\\(", "", names(newDataSet))
names(newDataSet)<-gsub("\\)", "", names(newDataSet))
names(newDataSet)<-gsub("\\-", ".", names(newDataSet))
names(newDataSet)<-gsub("Acc", "Acceleration", names(newDataSet), ignore.case = TRUE)
names(newDataSet)<-gsub("Mag", "Magnitude", names(newDataSet), ignore.case = TRUE)


head(newDataSet)
names(newDataSet)
