# Rigbe G. Weldatsadik
# 21.11.2017
# Logistic regression with the Student Performance Data Set   (https://archive.ics.uci.edu/ml/datasets/Student+Performance)

library(dplyr)

# reading the datasets
math <- read.table("data/student-mat.csv", sep = ";" , header=TRUE)
por <- read.table("data/student-por.csv", sep = ";" , header=TRUE)

# exploring
# the math dataset has 395 observation and 33 variables(of factor and int types), while the por dataset has the same 33 variables but 649 observations
str(math)
str(por)
dim(math)
dim(por)

# joining the two datasets based on the following columns
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")

math_por <- inner_join(math, por, by = join_by,suffix=c(".math",".por"))

# there are 382 common observations after the inner join
dim(math_por)
str(math_por)

# copied from the datacamp
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# for every column name not used for joining, select two columns from 'math_por' with the same original name
# and then select the first column vector of those two columns
# if that first column vector is numeric, take a rounded average of each row of the two columns and add the resulting vector to the alc data frame...
# otherwise if it's not numeric add the first column vector to the alc data frame

for(column_name in notjoined_columns) {
  two_columns <- select(math_por, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
  
  if(is.numeric(first_column)) {
    
    alc[column_name] <- round(rowMeans(two_columns))
  } else { 
    alc[column_name] <- first_column
  }
}

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use', which is TRUE for students for which 'alc_use' is greater than 
alc <- mutate(alc, high_use = alc_use > 2)


# glimpse of the joined and modified data, contains 382 observations and 35 variables as expected
glimpse(alc)

# saving the joined and modified data to alc.csv
write.table(alc,file = "data/alc.csv", sep = "\t")

