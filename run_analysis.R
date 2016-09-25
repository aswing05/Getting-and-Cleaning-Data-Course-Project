#Step 1: Merge the training and test data sets

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

#create the merged datasets
xdata <- rbind(x_train, x_test)

ydata <- rbind(y_train, y_test)

subjectdata <- rbind(subject_train, subject_test)

#Step 2: Extracts only the measurements on the mean and standard deviation for each measurement

features <- read.table("features.txt")

mean_std_features <- grep("-(mean|std)\\(\\)", features[,2])

xdata <- xdata[,mean_std_features]

names(xdata) <- features[mean_std_features,2]

#Step 3: Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table("activity_labels.txt")

ydata[,1] <- activity_labels[ydata[,1],2]

names(ydata) <- "activity"

#Step 4: Appropriately labels the data set with descriptive variable names

names(subjectdata) <- "subject"

combined_data <- cbind(xdata, ydata, subjectdata)

#Step 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject

averages_data <- ddply(combined_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)