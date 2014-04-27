# The list of tasks to perform:
# Merging the training and the test sets to create one data set.
# Extracting only the measurements on the mean and standard deviation for each measurement. 
# Using descriptive activity names to name the activities in the data set
# Appropriately labeling the data set with descriptive activity names. 
# Creating a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Reading training and test set

#setting working directory
setwd("~/Dropbox/edu/coursera/DATA_SPECIALIZATION/getdata/UCI HAR Dataset/");

# Reading Data
features  = read.table('./features.txt', header=FALSE);
activityType = read.table('./activity_labels.txt', header=FALSE); 
subjectTrain = read.table('./train/subject_train.txt', header=FALSE); 
xTrain = read.table('./train/X_train.txt', header=FALSE); 
yTrain = read.table('./train/y_train.txt', header=FALSE);

# Working at Training Data: assigining column names
colnames(activityType)  = c('activityId','activityType');
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";
colnames(subjectTrain)  = "subjectId";

# A Final Training set
trainingData = cbind(yTrain,subjectTrain,xTrain);

# The test data: reading
subjectTest = read.table('./test/subject_test.txt', header = FALSE);
xTest = read.table('./test/X_test.txt', header = FALSE);
yTest = read.table('./test/y_test.txt', header = FALSE);

# Working at Test Data: assigining column names
colnames(xTest) = features[,2]; 
colnames(yTest) = "activityId";
colnames(subjectTest) = "subjectId";

# The final test set: merging column-wise
testData = cbind(yTest,
                 subjectTest,
                 xTest);

# Combining training, test set to create a final data set
# Merging the training & test data sets
finalData = rbind(trainingData,
                  testData);

# Storing the column names from the finalData
colNames  = colnames(finalData); 

# Create a logicalVector that contains TRUE values for the ID,
# mean() & stddev() columns and FALSE for others
logicalVector = (grepl("activity..", colNames) | grepl("subject..", colNames) |
                   grepl("-mean..", colNames) & !grepl("-meanFreq..", colNames) &
                   !grepl("mean..-", colNames) | grepl("-std..", colNames) &
                   !grepl("-std()..-", colNames));

# subset finalData table based on the logicalVector to keep only desired columns
finalData = finalData[logicalVector == TRUE];

# Merging activity_type with data from step 2. to include descriptives activity names 

# merge the finalData set with the acitivityType table
finalData = merge(finalData,
                  activityType,
                  by='activityId',
                  all.x=TRUE);

# Updating the colNames vector
colNames  = colnames(finalData); 

# Labeling the variables with descriptive names

# Converting the variable names
for (i in 1:length(colNames)) 
{
   colNames[i] = gsub("\\()", "", colNames[i])
   colNames[i] = gsub("-std$", "StdDev", colNames[i])
   colNames[i] = gsub("-mean", "Mean", colNames[i])
   colNames[i] = gsub("^(t)", "time", colNames[i])
   colNames[i] = gsub("^(f)", "freq", colNames[i])
   colNames[i] = gsub("([Gg]ravity)", "Gravity", colNames[i])
   colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)", "Body", colNames[i])
   colNames[i] = gsub("[Gg]yro", "Gyro", colNames[i])
   colNames[i] = gsub("AccMag", "AccMagnitude", colNames[i])
   colNames[i] = gsub("([Bb]odyaccjerkmag)", "BodyAccJerkMagnitude", colNames[i])
   colNames[i] = gsub("JerkMag", "JerkMagnitude", colNames[i])
   colNames[i] = gsub("GyroMag", "GyroMagnitude", colNames[i])
};

# reassigning the new descriptive column names
colnames(finalData) = colNames;

# Creating a second Independent data set by aggegrating the table by activity & subject id per participant

# Creating a new table, finalData2 without the activityType column
finalData2  = finalData[,names(finalData) != 'activityType'];

# Summarizing the finalData2 table
tidyData = aggregate(finalData2[ , names(finalData2) != c('activityId', 'subjectId')],
                        by = list(activityId = finalData2$activityId,
                                  subjectId = finalData2$subjectId),
                     mean);

# merging the tidyData with activityType to include descriptive acitvity names
tidyData = merge(tidyData, activityType, by='activityId', all.x=TRUE);

# Exporting the tidyData set 
write.table(tidyData, './tidyData.txt', row.names = TRUE, sep = ',');

