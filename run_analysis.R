# This script does the following
# 1.  Merges the training and the test sets to create one data set.
# 2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.	Uses descriptive activity names to name the activities in the data set
# 4.	Appropriately labels the data set with descriptive activity names. 
# 5.	Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# reshape2 is an R package written by Hadley Wickham that makes it easy 
# to transform data between wide and long formats.
library(reshape2)

# The function Inicio() indicates the local directory where the files are

Inicio <-function () { WorkDirStr<-"D:/A Data Science/Getting and Cleaning Data/Peer Assessment"; WorkDirStr}

# UCI dataset has X values, Y values and Subject IDs.

# Reading the x and y data
# Funtion LeDados has two parameters: subdirectory name: where the files are; and name of file: "test" or "train" 

LeDados <- function (diretorio, opcao) {
  
  # mouting the subdirectory + the name of the Y file
  # reading the Y file
  montagem<-paste0(Inicio(), "/", diretorio, "/y_", opcao, ".txt") 
  montagem<-file.path(montagem)
  dados_y<-read.table(montagem, header=F, col.names=c("ActivityID"))
  
  # mounting the subdirectory + the name of subject ids file
  # reading the subject ids file

  montagem<-paste0(Inicio(), "/", diretorio, "/subject_", opcao, ".txt")
  montagem<-file.path(montagem)
  dados_subject<- read.table(montagem, header=F, col.names=c("SubjectID"))
  
  # File "features.txt" has the 561 column names. Selecting columns MeasureID and MeasureName
  montagem<-paste0(Inicio(), "/features.txt") 
  montagem<-file.path(montagem)
  dados_columns <- read.table(montagem, header=F, as.is=T, col.names=c("MeasureID","MeasureName"))
  
  # mouting the subdirectory + the name of the X file
  # reading the X files

  montagem<-paste0(Inicio(), "/", diretorio, "/X_", opcao, ".txt") 
  montagem<-file.path(montagem)    
  separados<- read.table(montagem, header=F, col.names=dados_columns$MeasureName)
  
  # getting the subset of requied columns names
  subset_name_columns<- grep(".*mean\\(\\)|.*std\\(\\)", dados_columns$MeasureName)
  
  # subset the data (done early to save memory)
  separados<- separados[,subset_name_columns]
  
  # append the activity id and subject id columns
  separados$ActivityID <- dados_y$ActivityID
  separados$SubjectID  <- dados_subject$SubjectID
  
  # return the data mounted in the data frame "separados"
  separados  
}

# ------------------------------------------------------------------------------------------------

# Begin of script

# Read test data set, in a folder with name "/test", and all the files with names "test" on it
dirop<-c("test", "test")
LeDadosTeste <-LeDados(dirop[1], dirop[2])

# Read training data sets, in a folder with name "/train", and all the files with names "train" on it
dirop<-c("train", "train")
LeDadosTreino <-LeDados(dirop[1], dirop[2])

# Resolving "1" Merging the training and test sets to create one data set.
junta_dados <- rbind(LeDadosTeste, LeDadosTreino)
cn <- colnames(junta_dados)
cn <- gsub("\\.+mean\\.+", cn, replacement="Mean")
cn <- gsub("\\.+std\\.+", cn, replacement="Std")
colnames(junta_dados) <- cn
                     
# Resolving "3.": Using descriptive activity names to name the activities in the data set
# Resolving "4": Appropriately labels the data set with descriptive activity names. 
# Combine training+test data sets and add "activity" label as another column
montagem<-paste0(Inicio(), "/activity_labels",".txt")
montagem<-file.path(montagem)
nome_atividades<- read.table(montagem, header=F, as.is=T, col.names=c("ActivityID", "ActivityName"))
nome_atividades$ActivityName <- as.factor(nome_atividades$ActivityName)
poem_nome<- merge(junta_dados, nome_atividades)
               
# Resolving "5.":Creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject.   
# consolidating the dataset
ides<- c("ActivityID", "ActivityName", "SubjectID")
medidas<- setdiff(colnames(poem_nome), ides)
consolidado<- melt(poem_nome, id=ides, measure.vars=medidas)                     

# Finaly, a tidy data format!
consolidado<-dcast(consolidado, ActivityName + SubjectID ~ variable, mean)  

montagem<-paste0(Inicio(), "/jpa_tidy_data",".txt")
write.table(consolidado, montagem)

