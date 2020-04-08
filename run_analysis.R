##### Getting the Data from the URL 
###Downloadng the file from URL
if(!file.exists("./Projectdata1")){
	dir.create("./Projectdata1")
}

fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Projectdata1/Dataset.zip",method="curl")

##Unzipping the file downloaded

unzip(zipfile="./Projectdata1/Dataset.zip",exdir="./Projectdata1")

###Listing the files list

path_rf = file.path("./Projectdata1" , "UCI HAR Dataset")
files=list.files(path_rf, recursive=TRUE)
files


###Reading the activity files

dataActivityTest  = read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain = read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)


###Reading the subject files

dataSubjectTrain = read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  = read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)


##Reading the Feature Files

dataFeaturesTest  = read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain = read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)


##Checking the Properties

str(dataActivityTest)

str(dataActivityTrain)

str(dataSubjectTrain)

str(dataSubjectTest)

str(dataFeaturesTest)


str(dataFeaturesTrain)

###Merging and Creating a Dataset


dataSubject = rbind(dataSubjectTrain, dataSubjectTest)
dataActivity = rbind(dataActivityTrain, dataActivityTest)
dataFeatures = rbind(dataFeaturesTrain, dataFeaturesTest)



names(dataSubject)=c("subject") ###naming the variables
names(dataActivity)= c("activity")
dataFeaturesNames = read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)= dataFeaturesNames$V2

dataCombine = cbind(dataSubject, dataActivity)
Data = cbind(dataFeatures, dataCombine)

##Extracts only the measurements on the mean and standard deviation for each measurement

subdataFeaturesNames = dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

selectedNames = c(as.character(subdataFeaturesNames), "subject", "activity" )

Data = subset(Data,select=selectedNames)

str(Data)###Checking the data frame structure

activityLabels = read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

head(Data$activity,30)

##Labelling with variable names

names(Data) = gsub("^t", "time", names(Data))
names(Data) = gsub("^f", "frequency", names(Data))
names(Data) = gsub("Acc", "Accelerometer", names(Data))
names(Data) = gsub("Gyro", "Gyroscope", names(Data))
names(Data) = gsub("Mag", "Magnitude", names(Data))
names(Data) = gsub("BodyBody", "Body", names(Data))

names(Data) ###Check Data

###From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr);
Data2 = aggregate(. ~subject + activity, Data, mean)
Data2 = Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

str(Data2) ### check final dataset

###CodeBook

codebook::new_codebook_rmd()
