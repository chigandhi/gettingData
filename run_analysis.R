## run_analysis.R
## Chirag Gandhi
## Change this to the correct working directory
workingDirectory <- c("C:\\Users\\Chirag\\chirag personal\\US\\coursera\\getting data\\project\\UCI HAR Dataset\\UCI HAR Dataset")

## DO NOT change below this
## set working directory
setwd(workingDirectory)

## Read the column names
features <- read.table("features.txt")

## Read the activity codes
activityLabels <- read.table("activity_labels.txt")

## Read the test data
testData <- read.table("test\\X_test.txt", col.names=features$V2)
testSubject <- read.table("test\\subject_test.txt")
testActivity <- read.table("test\\y_test.txt")

## Create subset for test data
selectedTestData <- cbind(testSubject, testActivity, 1, testData[,grep('[Mm]ean|std',names(testData), value=T)])
colnames(selectedTestData)[1] <- c("subject")
colnames(selectedTestData)[2] <- c("activity")
colnames(selectedTestData)[3] <- c("cohort")


## Read the train data
trainData <- read.table("train\\X_train.txt", col.names=features$V2)
trainSubject <- read.table("train\\subject_train.txt")
trainActivity <- read.table("train\\y_train.txt")

## Create subset for test data
selectedTrainData <- cbind(trainSubject, trainActivity, 2, trainData[,grep('[Mm]ean|std',names(trainData), value=T)])
colnames(selectedTrainData)[1] <- c("subject")
colnames(selectedTrainData)[2] <- c("activity")
colnames(selectedTrainData)[3] <- c("cohort")

## merge the train and test data
completeData <- rbind(selectedTestData, selectedTrainData)

## make factors for activity
completeData$activity <- factor(completeData$activity)
levels(completeData$activity) <- activityLabels$V2


## make factors for cohort
completeData$cohort <- factor(completeData$cohort)
levels(completeData$cohort) <- c("Test", "Train")

## make subject a factor
completeData$subject <- factor(completeData$subject)

## create tidy data
tidyData <- aggregate(completeData[, grep('[Mm]ean|std', names(completeData), value=T)], list(subject = completeData$subject, activity = completeData$activity), FUN = mean)

## fix column names
tidyColNames <- paste("avg", colnames(tidyData), sep="_")
tidyColNames <- gsub("\\.{2,}", ".", tidyColNames)
tidyColNames <- gsub("avg_subject", "subject", tidyColNames)
tidyColNames <- gsub("avg_activity", "activity", tidyColNames)
tidyColNames <- gsub("\\.$", "", tidyColNames)
colnames(tidyData) <- tidyColNames

## write output file
write.csv(tidyData, file="tidydata.csv", row.names=F)

