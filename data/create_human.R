# Author: Rigbe G Weldatsadik
# Date : November 29, 2017
# Description: data wrangling of the human data.
# data source : http://hdr.undp.org/en/content/human-development-index-hdi

# Reading in the data
library(dplyr)
library(stringr)


hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")


# exploring
str(hd)
dim(hd)


str(gii)
dim(gii)

# hd has 195 obs, and 8 variables while gii dataset has 195 obs and 10 variables


# summarizing
summary(hd) 
summary(gii)


# shorter variable names
colnames(hd) <- c("HdiR","Country","Hdi","LifeExp","EduExp","EduMean","Gni","GniMinusHdiR")
colnames(gii) <- c("GiiR","Country","Gii","MaMortalityR","AdBirthRate","ParPer","FemaleSecEdu","MaleSecEdu","FemaleLabor","MaleLabor")


# two new ratio variables
gii <- mutate(gii, FemMaleEdu = FemaleSecEdu / MaleSecEdu)
gii <- mutate(gii, FemMaleLabor = FemaleLabor / MaleLabor)


# innerjoin hd and gii datasets
human <- inner_join(hd, gii, by = "Country", suffix=c(".hd",".gii"))
str(human)
head(human)


# Writing to table

write.table(human,file="data/human.txt",sep="\t")

# read the human table

human = read.table("data/human.txt", sep="\t")

str(human)

# change the Gni variable to numeric (after removing the comma) and replace the original Gni variable with that
human$Gni <- str_replace(human$Gni, pattern=",", replace ="")%>%as.numeric

# we are selecting only these columns "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F"
# which in my wrangled version of the data are respectively "Country", "FemMaleEdu", "FemMaleLabor", "EduExp", "LifeExp", "Gni", "MaMortalityR", "AdBirthRate", "ParPer

selected_cols = c("Country", "FemMaleEdu", "FemMaleLabor", "EduExp", "LifeExp", "Gni", "MaMortalityR", "AdBirthRate", "ParPer")

selected_human = dplyr::select(human, one_of(selected_cols))

# remove all rows with NA by using the complete.cases method which outputs TRUE when a row doesn't contain NA (i.e the row is complete)
selected_human_withoutNA <- filter(selected_human, complete.cases(selected_human))

#Remove the observations which relate to regions instead of countries (from the NA removed human data), which are found in the last 7 observations

last <- nrow(selected_human_withoutNA) - 7

# choose everything until the last 7 observations
selected_human_withoutNA <- selected_human_withoutNA[1:last, ]

# add countries as rownames and remove the Country column
rownames(selected_human_withoutNA) <- selected_human_withoutNA$Country

selected_human_withoutNA <- dplyr::select(selected_human_withoutNA, -Country)

# the final dataset contains 155 obs of 8 variables
str(selected_human_withoutNA)

# saving the final data set as human.txt overriding the previous human data, rownames and colnames are by default True
write.table(selected_human_withoutNA,file="data/human.txt",sep="\t")


