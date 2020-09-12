library(dplyr)

fileDir <- "./UCI HAR Dataset"

if (!file.exists(fileDir)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, destfile = "dataset.zip")
  unzip("dataset.zip")
  file.remove("dataset.zip")
}

features_label <- read.table(paste0(fileDir, "/features.txt"), colClasses = c("NULL", "character"))
features_label <- unlist(features_label$V2)

test_set <- read.table(paste0(fileDir, "/test/X_test.txt"))
test_label <- read.table(paste0(fileDir, "/test/y_test.txt"))
test_subject <- read.table(paste0(fileDir,"/test/subject_test.txt"))

train_set <- read.table(paste0(fileDir, "/train/X_train.txt"))
train_label <- read.table(paste0(fileDir, "/train/y_train.txt"))
train_subject <- read.table(paste0(fileDir,"/train/subject_train.txt"))

merged_set <- rbind(train_set, test_set)
merged_label <- rbind(train_label, test_label)
merged_subject <- rbind(train_subject, test_subject)

names(merged_set) <- features_label
merged_set <- merged_set %>% select(contains("std()"), contains("mean()"))
names(merged_set) <- gsub("^t", "Time", names(merged_set))
names(merged_set) <- gsub("^f", "FFT", names(merged_set))
names(merged_set) <- gsub("std", "Std", names(merged_set))
names(merged_set) <- gsub("mean", "Mean", names(merged_set))
names(merged_set) <- gsub("\\(\\)", "", names(merged_set))
names(merged_set) <- gsub("-", "", names(merged_set))

names(merged_label) <- c("label")
names(merged_subject) <- c("subject")

merged_data <- cbind(merged_subject, merged_set, merged_label)

final_data <- merged_data %>% group_by(subject, label) %>% summarise_all(mean)
