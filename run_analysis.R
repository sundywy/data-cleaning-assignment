library(dplyr)

fileDir <- "./UCI HAR Dataset"

if (!file.exists(fileDir)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, destfile = "dataset.zip")
  unzip("dataset.zip")
  file.remove("dataset.zip")
}

getDataSet <- function(name, colNames) {
  testData <- read.table(paste0(fileDir, "/test/", name, "_test.txt"))
  trainData <-read.table(paste0(fileDir, "/train/", name, "_train.txt"))
  mergedData <- rbind(trainData, testData)
  names(mergedData) <- colNames
  mergedData
}

features_label <- read.table(paste0(fileDir, "/features.txt"), colClasses = c("NULL", "character"))
features_label <- unlist(features_label$V2)

dataset <- getDataSet("X", colNames = features_label)

dataset <- dataset %>% select(contains("std()"), contains("mean()"))

rename <- function(name) {
  name <- gsub("^t", "Time", name)
  name <- gsub("^f", "FFT", name)
  name <- gsub("\\(\\)", "", name)
  ns <- strsplit(name, split = "-")
  
  paste0(ns[[1]][2], ns[[1]][1], ns[[1]][3])
}

names(dataset) <- unlist(lapply(names(dataset), rename))

datalabel <- getDataSet("y", colNames = c("label"))
datasubject <- getDataSet("subject", colNames = c("subject"))

dataset <- cbind(datasubject, dataset, datalabel)

cleanData <- dataset %>% group_by(subject, label) %>% summarise_all(mean)

write.table(cleanData, "clean-data.txt", row.name=FALSE)

