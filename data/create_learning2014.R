# Rigbe G. Weldatsadik
# 14.11.2017
# Regression and model validation with the data JYTOPKYS3  (http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-meta.txt)

library(dplyr)

JYTOPKYS3 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", header = T, sep = '\t')

# the data has 183 observation and 60 variables, all of the variables are of data type numeric except gender which is a factor
# we can check these using the str and dim methods
# read. table functions forced gender to be a factor, we can remove that if we want

str(JYTOPKYS3)
dim(JYTOPKYS3)

# here we are combining questions questions in to deep, surf and stra
deep <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surf <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
stra <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# since the Attitude variable was a combined one,i.e. a sum of 10 questions, here we are scaling it back by dividing by 10
JYTOPKYS3$attitude <- JYTOPKYS3$Attitude / 10

# the same as in the Attitude variable we are scaling the deep, surf and stra combined variables by taking their means
deep_columns <- select(JYTOPKYS3, one_of(deep))
JYTOPKYS3$deep <- rowMeans(deep_columns)

surf_columns <- select(JYTOPKYS3, one_of(surf))
JYTOPKYS3$surf <- rowMeans(surf_columns)

stra_columns <- select(JYTOPKYS3, one_of(stra))
JYTOPKYS3$stra <- rowMeans(stra_columns)

# after the scaling, we will use the scaled variables and also the additional variables gender, age and points  to make a new data frame called d1

vars <- c('gender', 'Age', 'attitude','deep','stra','surf','Points')

d1 <- select(JYTOPKYS3,one_of(vars))

# we are removing rows that have points less than or equal to 0 from d1 and reassigning it ot d1_nonzero
d1_nonzero <- d1[d1$Points > 0,]

# checking the dim of d1_nonzero
dim(d1_nonzero)

# set the working directory
setwd("~/GitHub/IODS-project")

# write dl_nonzero to a file
write.table(d1_nonzero,file = "data/learning2014.csv", sep = "\t")

# read it again to make sure it is written correctly

l2014_test <- read.table("data/learning2014.csv", header = T, sep = "\t")

# check the written file has correct dimensions and so on
str(l2014_test)

head(l2014_test)