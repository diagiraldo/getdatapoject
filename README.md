# getdatapoject
Course Project 
##run_analysis.R file

###First task: Merge the training and the test sets to create one data set

The following commands read and assign the data to new variables

    X_traindat <- read.table("Downloads/UCI HAR Dataset/train/X_train.txt")
    X_testdat <- read.table("Downloads/UCI HAR Dataset/test/X_test.txt")

Then the data is merged in a single variable and the previous variables are removed to save memory space.

    Xdat <- rbind(X_traindat, X_testdat)
    rm(X_traindat, X_testdat)

The same process is done with  the activity and subject code data.

    y_train <- read.table("Downloads/UCI HAR Dataset/train/y_train.txt")
    y_test <- read.table("Downloads/UCI HAR Dataset/test/y_test.txt")
    act <- rbind(y_train, y_test)
    rm(y_train, y_test)
    sub_train <- read.table("Downloads/UCI HAR Dataset/train/subject_train.txt")
    sub_test <- read.table("Downloads/UCI HAR Dataset/test/subject_test.txt")
    sub <- rbind(sub_train, sub_test)
    rm(sub_train, sub_test)

###Second task: Extract only the measurements on the mean and standard deviation for each measurement. 

The fist step is to load the names of the features in a new variable:

    feat <- read.table("Downloads/UCI HAR Dataset/features.txt")

Then, the positions of the mean and standard deviation measurments are saved in index vectors:

    mn_ind <- grep("mean\\(\\)", feat[,2])
    sd_ind <- grep("std\\(\\)", feat[,2])

And finally, these index vectors are used to extact the required features:

    Xdat <- Xdat[,c(mn_ind, sd_ind)]
    
###Third task: Use descriptive activity names to name the activities in the data set

Firts, load the data base with the activity codes and names:

    act_labs <- read.table("Downloads/UCI HAR Dataset/activity_labels.txt")

Then, the data in `act` are used to construct a factor with the activity names

    activity <- factor(act[,1], levels=act_labs[,1], labels=act_labs[,2])

###Fourth task: Appropriately label the data set with descriptive variable names.

The following command takes the names of the selected features and assign them to the names of the variables in the data set. These names are assigned in the same order the features were selected

    names(Xdat) <- as.character(feat[c(mn_ind, sd_ind),2])

###Fifth task: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The subject and activity information are included in the data frame that contains the features:

    Xdat$Subject <- as.factor(sub[,1])
    Xdat$activity <- activity
    
Then, a new data frame is created by aggregating the data by mean per subject and activity:

    newDat <- aggregate(Xdat, by=list(Xdat$Subject, Xdat$activity), FUN="mean")
    
The new data frame doesn't contain useful information in the last two columns (the former subject and activity columns and those values are located in the first two columns of the new data frame):

    newDat <- newDat[,-c(69,70)]
    names(newDat)[1:2] <- c("Subject", "Activity")
    
Finally, the new data is saved in a .txt file:

    write.table(newDat, "getdataproject.txt", row.names=FALSE)
