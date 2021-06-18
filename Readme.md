---
title: "Readme"
author: "Vu Tuan Manh"
date: "6/18/2021"
output: html_document
---

## Overview

This document describe steps to fulfill assignment requirement

The requirement are:

You should create one R script called run_analysis.R that does the following.

1.  Merges the training and the test sets to create one data set.

2.  Extracts only the measurements on the mean and standard deviation for each measurement.

3.  Uses descriptive activity names to name the activities in the data set

4.  Appropriately labels the data set with descriptive variable names.

5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Detailed

### Step 1: Merges the training and the test sets to create one data set

**Input:**

-   UCI HAR Dataset\\test\\subject_test.txt, UCI HAR Dataset\\train\\subject_train.txt

-   UCI HAR Dataset\\test\\x_test.txt, UCI HAR Dataset\\train\\x_train.txt

-   UCI HAR Dataset\\test\\y_test.txt, UCI HAR Dataset\\train\\y_train.txt

**Output:**

-   subject_total_dt

-   x_total_dt

-   y_total_dt

**Process:**

Read data from text file

``` r
x_train_dt <- read.table("./UCI HAR Dataset/train/X_train.txt")
```

Merge 2 data set

```{x_total_dt <- rbind(x_train_dt, x_test_dt)}
```

### Step 2: Extracts only the measurements on the mean and standard deviation for each measurement

**Input:**

-   x_total_dt from step 1

-   Column Indices from features file related on mean and standard deviation

**Output:**

-   Get x_total_dt with columns match with column Indices input

**Process:**

-   Get column indices with grep

```{selected_feature <- feature_names_dt[grep("mean\\(\\)|std\\(\\)",feature_names_dt[,2], ignore.case = FALSE),]}
```

Filter data set with column indices

```{x_total_dt <- x_total_dt[,selected_feature[,1]]}
```

### Step 3. Uses descriptive activity names to name the activities in the data set

**Input:**

-   Column name from step 2: selected_feature[,2]

-   x_total_dt from step 2

-   y_total_dt and subject_total_dt from step 1

**Output:**

-   x_total_dt with column name of selected_feature[,2]

-   y_total_dt has column name "activity" and subject_total_dt has column name "subject"

**Process:**

-   Set column name

```{colnames(x_total_dt) <- selected_feature[,2]}
```

```{colnames(y_total_dt) <- "activity"}
```

```{colnames(subject_total_dt) <- "subject"}
```

-   Merge output dataset

```{total_dt <- cbind(subject_total_dt, y_total_dt, x_total_dt)}
```

### Step 4. Appropriately labels the data set with descriptive variable names

**Input:**

```{activity_labels_dt <- read.table("./UCI HAR Dataset/activity_labels.txt")}
```

**Output:**

-   Appropriately labels the data set with descriptive variable names

**Process:**

-   Turn activities & subjects into factors

```{total_dt$activity <- factor(total_dt$activity, levels = activity_labels_dt[,1], labels = activity_labels_dt[,2])}
```

```{total_dt$subject <- as.factor(total_dt$subject)}
```

### Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

**Input:**

-   total_dt from step 4

**Output:**

-   tidydata.txt

**Process:**

-   Creates a second, independent tidy data set with the average of each variable for each activity and each subject

```{tidy_dt <- total_dt %>% group_by(activity, subject) %>% summarize_all(funs(mean))}
```

-   Export summary data table

```{write.table(tidy_dt, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)}
```
