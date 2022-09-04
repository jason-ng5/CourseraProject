setwd('./UCI HAR Dataset')
library(dplyr)
# Reading files into data frames
features <- read.table('features.txt')
X_test <- read.table('./test/X_test.txt')
X_train <- read.table('./train/X_train.txt')
subject_test <- read.table('./test/subject_test.txt')
subject_train <- read.table('./train/subject_train.txt')
activity_test <- read.table('./test/y_test.txt')
activity_train <- read.table('./train/y_train.txt')

# Identify columns with relevant data on mean and sd
indices <- grep('mean\\(\\)|std\\(\\)', features[,2])

# Extract measurements on the mean and sd only
required_X_test <- X_test[,indices]
required_X_train <- X_train[,indices]

# Match the data with the subject id and activity label column
test <- cbind(subject_test, activity_test, required_X_test)
train <- cbind(subject_train, activity_train, required_X_train)

# Merge test and train
all <- rbind(test, train)

# Labels the columns using descriptive names
colnames(all) <- c('subject', 'activity', grep('mean\\(\\)|std\\(\\)', features[,2], value = TRUE))

# Replace activity labels with descriptive names
all$activity[all$activity == 1]<-'WALKING'
all$activity[all$activity == 2]<-'WALKING_UPSTAIRS'
all$activity[all$activity == 3]<-'WALKING_DOWNSTAIRS'
all$activity[all$activity == 4]<-'SITTING'
all$activity[all$activity == 5]<-'STANDING'
all$activity[all$activity == 6]<-'LAYING'

#Grouping by activity and subject, produce a summary of the average of the mean and sd of each variable
grouped <- group_by(all, subject, activity)
average <- summarise(grouped, across(everything(), mean))

#Create txt file of the data frame
setwd('..')
write.table(average, file = 'average.txt', row.name = FALSE)