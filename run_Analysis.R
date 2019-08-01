#**************************************************************************************
# Step 0: Downloading and unziping data
#**************************************************************************************

if (!file.exists('./data')) {
  dir.create('./data')
}
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileUrl,destfile = './data/dataset.zip')

#unzip Dataset 
unzip(zipfile="./data/Dataset.zip",exdir="./data")



#You should create one R script called run_analysis.R that does the following.

#************************************************************
#1. Merges the training and the test sets to create one data set.
#************************************************************

#Reading files
x_train <-read.table('./data/UCI HAR Dataset/train/X_train.txt')
y_train <-read.table('./data/UCI HAR Dataset/train/y_train.txt')
subject_train <-read.table('./data/UCI HAR Dataset/train/subject_train.txt')

x_test <-read.table('./data/UCI HAR Dataset/test/X_test.txt')
y_test <-read.table('./data/UCI HAR Dataset/test/y_test.txt')
subject_test <-read.table('./data/UCI HAR Dataset/test/subject_test.txt')

features<- read.table('./data/UCI HAR Dataset/features.txt')

activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

colnames(x_train) <- features[,2]
colnames(y_train) <- 'activityId'
colnames(subject_train) <- 'subjectId'

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"


colnames(activityLabels) <- c('activityId','activityType')

mrgTraining_set <- cbind(y_train,subject_train,x_train)

allMergedSets <- rbind(mrgTraining_set,mrgTest_set)

#dim(allMergedSets)
#[1] 10299   563



#************************************************************
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#************************************************************ 

mean_and_std <- grepl('activityId',colnames(allMergedSets)) | grepl('subjectId',colnames(allMergedSets)) | grepl('mean..',colnames(allMergedSets)) | grepl('std..',colnames(allMergedSets))

meanAndSdtSet <- allMergedSets[,mean_and_std==TRUE]

#************************************************************
#2. Uses descriptive activity names to name the activities in the data set.
#************************************************************ 

setWithActivityNames <- merge(meanAndSdtSet, activityLabels,by = 'activityId',all.x = TRUE)


#******************************************************************
#4. Appropriately labels the data set with descriptive variable names.
#******************************************************************

#Already labeled the data set with desciptive variable names

#******************************************************************
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable
#   for each activity and each subject.
#******************************************************************

tidySet <- aggregate(.~subjectId + activityid,setWithActivityNames,mean)

tidySet <- tidySet[order(tidySet$subjectId, tidySet$activityId),]

#5.2 Writing second tidy data set in txt file

write.table(tidySet, "tidySet.txt", row.name=FALSE)


