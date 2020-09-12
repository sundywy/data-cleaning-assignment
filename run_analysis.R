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

train_set <- read.table(paste0(fileDir, "/train/X_train.txt"))

merged_set <- rbind(train_set, test_set)

names(merged_set) <- features_label

label <- features_label[grep("(std()|mean())", features_label)]

merged_set <- merged_set %>% select(label)
