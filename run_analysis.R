# constant path to file
ACTIVITY_LABELS = "./UCI HAR Dataset/activity_labels.txt"
FEATURES = "./UCI HAR Dataset/features.txt"
SUBJECT_TEST = "./UCI HAR Dataset/test/subject_test.txt"
X_TEST = "./UCI HAR Dataset/test/X_test.txt"
Y_TEST = "./UCI HAR Dataset/test/y_test.txt"
INERTIAL_SIGNALS_TEST = "./UCI HAR Dataset/test/Inertial Signals"
SUBJECT_TRAIN = "./UCI HAR Dataset/train/subject_train.txt"
X_TRAIN = "./UCI HAR Dataset/train/X_train.txt"
Y_TRAIN = "./UCI HAR Dataset/train/y_train.txt"
INERTIAL_SIGNALS_TRAIN = "./UCI HAR Dataset/train/Inertial Signals"

library(dplyr)
# Overview the steps
# 1. Merges the training and the test sets to create one data set
# 1.1 Read raw data from input file
# 1.2 Merge data x, y, subject of test, and training data into 3 data tables correspondingly
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 2.1 Get index of row in feature data related to mean and std
# 2.2 Select only Columns with index fulfilled the grep condition
# 3. Uses descriptive activity names to name the activities in the data set
# (Prepare final data table for calculate)
# 4. Appropriately labels the data set with descriptive variable names.
# (turn activities & subjects into factors)
# 5. creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# (Export summary data table)

# 1. Merges the training and the test sets to create one data set
# 1.1 Read raw data from input file
# read train data in to the tables
x_train_dt <- read.table(X_TRAIN)
y_train_dt <- read.table(Y_TRAIN)
subject_train_dt <- read.table(SUBJECT_TRAIN)

# read test data in to the tables
x_test_dt <- read.table(X_TEST)
y_test_dt <- read.table(Y_TEST)
subject_test_dt <- read.table(SUBJECT_TEST)

# read data feature
feature_names_dt <- read.table(FEATURES)

# read activity labels
activity_labels_dt <- read.table(ACTIVITY_LABELS)

# 1.2  Merge data x, y, subject of test, and training data into 3 data tables correspondingly
x_total_dt <- rbind(x_train_dt, x_test_dt)
y_total_dt <- rbind(y_train_dt, y_test_dt)
subject_total_dt <- rbind(subject_train_dt, subject_test_dt)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 2.1 Get index of row in feature data related to mean and std
selected_feature <- feature_names_dt[grep("mean\\(\\)|std\\(\\)",feature_names_dt[,2], ignore.case = FALSE),]
# 2.2 Select only Columns with index fulfilled the grep condition
x_total_dt <- x_total_dt[,selected_feature[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(x_total_dt) <- selected_feature[,2]
colnames(y_total_dt) <- "activity"
colnames(subject_total_dt) <- "subject"

# Prepare final data table for calculate
total_dt <- cbind(subject_total_dt, y_total_dt, x_total_dt)

# 4. Appropriately labels the data set with descriptive variable names
# (turn activities & subjects into factors)
total_dt$activity <- factor(total_dt$activity, levels = activity_labels_dt[,1], labels = activity_labels_dt[,2]) 
total_dt$subject <- as.factor(total_dt$subject) 

# 5. creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_dt <- total_dt %>% group_by(activity, subject) %>% summarize_all(funs(mean)) 

#(export summary data table)
write.table(tidy_dt, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE) 