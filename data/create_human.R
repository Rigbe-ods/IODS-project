# Author: Rigbe G Weldatsadik
# Date : November 29, 2017
# Description: data wrangling of the human data.


# Reading in the data
library(dplyr)


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














