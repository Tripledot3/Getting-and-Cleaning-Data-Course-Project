## Reading all the tables into R
Feature <- read.table(file.choose())
activityLabels <- read.table(file.choose())
x_train <- read.table(file.choose())
y_train <- read.table(file.choose())
subject_train <- read.table(file.choose())
x_test <- read.table(file.choose())
y_test <- read.table(file.choose())
subject_test <- read.table(file.choose())
## Naming all of the colnums
colnames(x_train) <- Feature[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- Feature[,2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activityLabels) <- c("activityId", "activityType")
## Combining the Train and Test datasets
M_train <- cbind(y_train, subject_train, x_train)
M_Test <- cbind(y_test,subject_test,x_test)
Prime <- rbind(M_train, M_Test)
## Creating a variable that will search through the "prime" file and find the the mean and standard deviation included both ID's
Prime_Names <- colnames(Prime)
mean_and_std <- (grepl("activityId" , Prime_Names)
                 grepl("subjectId" , Prime_Names)
                 grepl("mean.." , Prime_Names) 
                 grepl("std.." , Prime_Names) )
##Creating a  subset that includes all the TRUE values
Prime_meanandstd <- Prime[,mean_and_std == TRUE]
## Adding the activity name to the new dataset by merging it with the activity label using the activityId
Prime_ActNames <- merge(Prime_meanandstd, activityLabels, 
                        by = "activityId", all.x = TRUE )
## Creating a second, independent tidy data set with the average of each variable for each activity and each subject
Prime_clean <- aggregate(. ~subjectId + activityId, Prime_ActNames, mean)
## Ordering the data first by subjectId then ActivityId
Prime_clean <- Prime_clean[order(Prime_clean$subjectId, Prime_clean$activityId),]
# uploading dataset as a txt file created with write.table()
write.table(Prime_clean, "Prime_clean.txt", row.names = FALSE)
