# 1. Merges the training and the test sets to create one data set.
X_traindat <- read.table("Downloads/UCI HAR Dataset/train/X_train.txt")
X_testdat <- read.table("Downloads/UCI HAR Dataset/test/X_test.txt")
Xdat <- rbind(X_traindat, X_testdat)
rm(X_traindat, X_testdat)

y_train <- read.table("Downloads/UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("Downloads/UCI HAR Dataset/test/y_test.txt")
act <- rbind(y_train, y_test)
rm(y_train, y_test)

sub_train <- read.table("Downloads/UCI HAR Dataset/train/subject_train.txt")
sub_test <- read.table("Downloads/UCI HAR Dataset/test/subject_test.txt")
sub <- rbind(sub_train, sub_test)
rm(sub_train, sub_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
feat <- read.table("Downloads/UCI HAR Dataset/features.txt")
mn_ind <- grep("mean\\(\\)", feat[,2])
sd_ind <- grep("std\\(\\)", feat[,2])
Xdat <- Xdat[,c(mn_ind, sd_ind)]

# 3. Uses descriptive activity names to name the activities in the data set
act_labs <- read.table("Downloads/UCI HAR Dataset/activity_labels.txt")
activity <- factor(act[,1], levels=act_labs[,1], labels=act_labs[,2])
rm(act)

# 4. Appropriately labels the data set with descriptive variable names.
names(Xdat) <- as.character(feat[c(mn_ind, sd_ind),2])

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Xdat$Subject <- as.factor(sub[,1])
Xdat$activity <- activity
newDat <- aggregate(Xdat, by=list(Xdat$Subject, Xdat$activity), FUN="mean")
newDat <- newDat[,-c(69,70)]
names(newDat)[1:2] <- c("Subject", "Activity")
write.table(newDat, "Dropbox/Coursera/getdataproject.txt", row.names=FALSE)