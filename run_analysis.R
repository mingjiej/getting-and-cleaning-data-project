
# download and unzip the data set

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "/Users/user/Dropbox/Computer\ Science/Online\ Course/Data\ Science\ Specialization/Getting\ clean\ data/Week4/data.zip", method = "curl")
unzip("/Users/user/Dropbox/Computer\ Science/Online\ Course/Data\ Science\ Specialization/Getting\ clean\ data/Week4/data.zip")

# load label and features with mean and std.

label <- read.table("/Users/user/Dropbox/Computer\ Science/Online\ Course/Data\ Science\ Specialization/Getting\ clean\ data/Week4/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
features <- read.table("/Users/user/Dropbox/Computer\ Science/Online\ Course/Data\ Science\ Specialization/Getting\ clean\ data/Week4/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
featuresRow <- grep(".+mean.+|.+std.+", features[,2])
features <- features[featuresRow,2]
features <- gsub("std", "Standard deviation", features)
features <- gsub("mean", "Mean", features)
features <- gsub("[()]", "", features)

# load training data set

train <- read.table("/Users/user/Dropbox/Computer\ Science/Online\ Course/Data\ Science\ Specialization/Getting\ clean\ data/Week4/UCI HAR Dataset/train/X_train.txt")
trainActivity <- read.table("/Users/user/Dropbox/Computer\ Science/Online\ Course/Data\ Science\ Specialization/Getting\ clean\ data/Week4/UCI HAR Dataset/train/Y_train.txt")
trainSubject <- read.table("/Users/user/Dropbox/Computer\ Science/Online\ Course/Data\ Science\ Specialization/Getting\ clean\ data/Week4/UCI HAR Dataset/train/subject_train.txt")
train <- train[, featuresRow]

# load test data set

test <- read.table("/Users/user/Dropbox/Computer\ Science/Online\ Course/Data\ Science\ Specialization/Getting\ clean\ data/Week4/UCI\ HAR\ Dataset/test/X_test.txt")
testActivity <- read.table("/Users/user/Dropbox/Computer\ Science/Online\ Course/Data\ Science\ Specialization/Getting\ clean\ data/Week4/UCI\ HAR\ Dataset/test/Y_test.txt")
testSubject <- read.table("/Users/user/Dropbox/Computer\ Science/Online\ Course/Data\ Science\ Specialization/Getting\ clean\ data/Week4/UCI\ HAR\ Dataset/test/subject_test.txt")
test <- test[, featuresRow]

# construct test data set and training data set

train <- cbind(trainSubject, trainActivity, train)
test <- cbind(testSubject, testActivity, test)

# merge data and add label

allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", features)

# replace index in allData with text

allData$activity <- factor(allData$activity, levels = label[,1], labels = label[,2])
allData$subject <- as.factor(allData$subject)

# reshape and claspes data

library(reshape2)
allData.melted <- melt(allData, id = c("subject", "activity"))

write.table(allData.mean, "/Users/user/Dropbox/Computer\ Science/Online\ Course/Data\ Science\ Specialization/Getting\ clean\ data/Week4/UCI\ HAR\ Dataset/tidy.txt", row.names = FALSE, quote = FALSE)
