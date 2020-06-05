#Download dataset
if(!file.exists("./data")){
    dir.create("./data")
    }
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#### 1. Merges the training and the test sets to create one data set.

#Read all the tables
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')

activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#Column names
colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_labels) <- c('activityId','activityType')

#Merge all tables
merge_train <- cbind(y_train, subject_train, x_train)
merge_test <- cbind(y_test, subject_test, x_test)
merge_all <- rbind(merge_train, merge_test)

#### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

colNames <- colnames(merge_all)
mean_and_std <- (grepl("activityId" , colNames) | 
                     grepl("subjectId" , colNames) | 
                     grepl("mean.." , colNames) | 
                     grepl("std.." , colNames) 
)
MeanandStd<- merge_all[ , mean_and_std == TRUE]

#### 3. Uses descriptive activity names to name the activities in the data set

activityNames <- merge(MeanandStd, activity_labels,
                              by='activityId',
                              all.x=TRUE)

#### 4. Appropriately labels the data set with descriptive variable names.

mean_and_std <- (grepl("activityId" , colNames) | 
                     grepl("subjectId" , colNames) | 
                     grepl("mean.." , colNames) | 
                     grepl("std.." , colNames) 
)
MeanandStd<- merge_all[ , mean_and_std == TRUE]

#### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

secondTidySet <- aggregate(. ~subjectId + activityId, activityNames, mean)
secondTidySet <- secondTidySet[order(secondTidySet$subjectId, secondTidySet$activityId),]

#Write the txt
write.table(secondTidySet, "secondTidySet.txt", row.name=FALSE)
