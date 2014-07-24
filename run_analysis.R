#   The current R script reads data from the 'UCI HAR Dataset' directory and processes the 
#   data to make it more readable in R. As a result, a new csv file is created with the mean
#   and standard deviation of the quantities in the original dataset.

# data.table library is loaded for creating data tables.
library(data.table)

#Loading train and test data, as well as activiies and subjects.
trainData <- read.table('UCI HAR Dataset/train/X_train.txt')
trainDataActivity <- read.table('UCI HAR Dataset/train/y_train.txt')
trainDataSubject <- read.table('UCI HAR Dataset/train/subject_train.txt')
testData <- read.table('UCI HAR Dataset/test/X_test.txt')
testDataActivity <- read.table('UCI HAR Dataset/test/y_test.txt')
testDataSubject <- read.table('UCI HAR Dataset/test/subject_test.txt')

#Loading features of the measurements and renaming the variables to easier reading.
feature <- read.table('UCI HAR Dataset/features.txt', colClasses='character')
feature[,2] <- gsub('-mean', 'Mean', feature[,2])
feature[,2] <- gsub('-std', 'SD', feature[,2])
feature[,2] <- gsub('[-()]', '', feature[,2])
#Assigining feature names to columns 
colnames(testData) <- feature$V2
colnames(trainData) <- feature$V2
colnames(testDataActivity) <- 'Activity'
colnames(trainDataActivity) <- 'Activity'
colnames(testDataSubject) <- 'Subject'
colnames(trainDataSubject) <- 'Subject'

#Combining the datasets. First, adding new variables to train and testing data. Second, 
#combining the two subdatasets into a big data matrix.
testData <- cbind(testData, testDataActivity, testDataSubject)
trainData <- cbind(trainData, trainDataActivity, trainDataSubject)
bigData <- rbind(trainData, testData)
#Computing the mean and standard deviation from the bigData matrix
bigDataMean <- sapply(bigData, mean, na.rm=TRUE)
bigDataSD <- sapply(bigData, sd, na.rm=TRUE)

#Making a data table with tidy data containin the mean and SD of the data per activity and
#Subject. This table is saved into a file in the working directory.
dt <- data.table(bigData)
tidyData <- dt[,lapply(.SD,mean),by='Activity,Subject']
write.csv(tidyData, file='tidyDataWearables.csv', row.names=F)

