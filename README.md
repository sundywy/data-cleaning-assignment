## README

# How this R script work

The following details will list down the steps how the R script will work

1. Check if the folder containing dataset exist in current directory. If not, it'll download it from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip] and unzip it
2. Training and testing data will then be read and merged together according to its type, e.g. features, label and subject (_X_, _y_ and _subject_) data
3. Data other than average and standard deviation will be filtered and removed from features dataset
4. Features, label and subject data will be merged together to form final dataset and will be group by its label and subject and averaged
5. The final clean data will be the summary of the average data
