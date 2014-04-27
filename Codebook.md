Getting And Cleaning Data Project
=====================================================================================

This repository contains the R code and Codebook.md as part of the Coursera Getting and Cleaning Data in R Course.


##The Description Of The Project

The purpose of this project is to demonstrate the skills of collecting and cleaning a 
data set. The goal is to prepare tidy data that can be used for a further analysis.

The data linked to from the course website represent data collected from the accelerometers
from the Samsung Galaxy S smartphone. A full description is available at the site where the 
data was obtained under: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 


##Data Description
The data comes from the Human Activity Recognition Using Smartphones Experiment
A group of 30 volunteers within an age bracket of 19-48 years participated in this experiement 
Each person performed 6 activities namely, Walking, walking Upstairs, Walking Downstairs,
Sitting, Standing, and Laying while wearing a Samsung Galaxy SII on their waist. 
Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 
3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded to    
label the data manually. 
The obtained dataset was randomly partitioned into two sets, where70% of the volunteers was selected for generating the training data and 30% the test data.
In essence, a Gyroscope is a device for measuring or maintaining orientation, based on the 
principles of angular momentum & allows accurate recognition of movement within a 3D space
In contrast, an accelerometer is a compact device designed to measure non-gravitational
acceleration.

##UCI HAR Dataset Description
The dataset includes the following files,
     - 'README.txt'
     - 'features_info.txt': Shows information about the variables used on the feature vector
     - 'features.txt': List of all features.
     - 'activity_labels.txt': Links the class labels with their activity name.
     - 'train/X_train.txt': Training set.
     - 'train/y_train.txt': Training labels.
     - 'test/X_test.txt': Test set.
     - 'test/y_test.txt': Test labels.

Variable Description
For each participant, there are several things being measured along the XYZ axes,
     - Angular Velocity, Acceleration, Maginutude, Angle along with some derived values,
       e.g. Jerk is derived from Acceleration and Angular Velocity
        - tBodyAcc-XYZ | tGravityAcc-XYZ | tBodyAccJerk-XYZ | tBodyGyro-XYZ
        - tBodyGyroJerk-XYZ | tBodyAccMag | tGravityAccMag | tBodyAccJerkMag
        - tBodyGyroMag | tBodyGyroJerkMag | fBodyAcc-XYZ | fBodyAccJerk-XYZ
        - fBodyGyro-XYZ | fBodyAccMag | fBodyAccJerkMag
        - fBodyGyroMag | fBodyGyroJerkMag |
     - Using the Euclidean norm, the magnitude of the inputs listed above were calculated
     - The variable have a time (prefix t) and frequency (prefix f) domain component.
     - Variables are normalized and bounded within [-1,1]
     - These signals were used to estimate statistical variables [mean, std deviation, min, max, skew, 
       kurtosis etc.] for each of the feature vector pattern: '-XYZ' is used to denote 3-axial 
       signals in the X, Y and Z directions.
     - A listing of the statistical variables created is described under the file "FeatureInfo"
     - A complete list of the 561 variables is available in the file "Features.txt"

 As stated in the assumptions above, as part of the project, only mean() & stddev() estimates
 are included in the analysis.

## Working of the run_analysis.R script

runAnalysis.r File Description:
Setting the working directory where the UCI HAR Dataset is extracted using setwd() command
Using the "read.table" command we import the following files,
- features, activityType, subjectTrain, xTrain, yTrain
- features, subjectTest, xTest, yTest
Next, we assign column names in each of the files imported above
Using the "cbind" command, we merge to create the Training & Test data sets
Concatenating the training & test sets into a table "finalData"
Subsetting finalData so that it only contains relevant mean(), stddev() columns
A logicalVector is created using "grepl" expression: searching for a specific
pattern in the argument and return a TRUE/FALSE value accordingly.
Subsetting of the finalData using the logicalVector to include only relevant columns 

Merging activity_type with data from step 2. to include descriptive activity names 
Merging the finalData set is merged with the acitivityType table.
Updating the colNames vector to include the new column (mean & stdddev) names  after merge
Labeling the variables with descriptive names 
Creating a second independent data table by aggegrating the table by activity & subject id per participant
Merging the tidyData with activityType to include descriptive activity names
Exporting the tidyData set using the "write.table" command
tidyData.txt file is made as a comma delimited text file

## Tidy Data Description
The columns of the tidyData set are described below,
- activityId, subjectId, activityType are same as before.
- columns "timeBodyAccMagnitudeMean" , "timeBodyAccMagnitudeStdDev" represent the average
time domain magnitude of body acceleration of the mean and std deviation respectively
- columns "timeGravityAccMagnitudeMean" & "timeGravityAccMagnitudeStdDev" represent the 
average time domain magnitude of angular velocity of the mean and std deviation respectively
- columns "timeBodyAccJerkMagnitudeMean" , "timeBodyAccJerkMagnitudeStdDev" represent the 
average time domain magnitude of jerk body acceleration of the mean and std deviation respectively
- columns "timeBodyGyroJerkMagnitudeMean" & "timeBodyGyroJerkMagnitudeStdDev" represent the 
average time domain magnitude of jerk angular velocity of the mean and std deviationrespectively
- columns "freqBodyAccMagnitudeMean" , "freqBodyAccMagnitudeStdDev" represent the average
frequency domain magnitude of body acceleration of the mean and std deviation respectively
- columns "freqBodyAccJerkMagnitudeMean" & "freqBodyAccJerkMagnitudeStdDev" represent the 
average frequency domain magnitude of jerk acceleration of the mean and std deviation respectively
- columns "freqBodyGyroMagnitudeMean" & "freqBodyGyroMagnitudeStdDev" represent the 
average frequency domain magnitude of angular velocity of the mean and std deviation respectively
- columns "freqBodyAccJerkMagnitudeMean" & "freqBodyAccJerkMagnitudeStdDev" represent the 
average frequency domain magnitude of jerk angular velocity of the mean and std deviation respectively
