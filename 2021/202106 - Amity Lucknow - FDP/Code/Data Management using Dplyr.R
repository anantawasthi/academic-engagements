
# References
# Tutorial : https://www.youtube.com/watch?v=jWjqLW-u3hc
# Website : https://www.r-bloggers.com/2014/09/hands-on-dplyr-tutorial-for-faster-data-manipulation-in-r/
# R for Excel users : https://jules32.github.io/r-for-excel-users/

# Installing Tidyverse
install.packages('tidyverse', dependencies = T)
install.packages('readxl', dependencies = T)
install.packages('writexl', dependencies = T)

# Loading Tidyverse
library(tidyverse)
library(readxl)
library(writexl)

# Setting working directory
setwd('C:/Users/Anant Awasthi/Documents/GitHub/academic-engagements/2021/202106 - Amity Lucknow - FDP')


# Getting working directory
getwd()

# List sub-folders and files
dir()


# Import Raw Data
rdata <- readxl::read_excel('Data/Attendance Data.xlsx', sheet = 'Attendance_Data')
rdata <- rdata %>% mutate(Date = as.Date(Date))
holidays <- readxl::read_excel('Data/Attendance Data.xlsx', sheet = 'Holidays')
holidays <- holidays %>% mutate(Date = as.Date(Date))

# Examining the dataset
str(rdata)

# Dimention of Data
dim(rdata)

# Number of rows
nrow(rdata)

# Number of Columns
ncol(rdata)

# Field Names
names(rdata)

# Top 10 Rows of the Data
head(rdata)
head(rdata, 10)

# Bottom 10 Rows of the Data
tail(rdata)
tail(rdata, 10)

writexl::write_xlsx(rdata, 'Output/excel_export.xlsx')

# dplyr verbs	  Description
# select()	    select columns
# filter()	    filter rows
# arrange()	    re-order or arrange rows
# mutate()	    create new columns
# summarise()	  summarise values
# group_by()	  allows for group operations in the "split-apply-combine" concept

# Selecting Columns
colselection <- rdata %>% select(Date, Roll_Number)

# Remove an object from Environment
rm(colselection)

# Selecting Rows
# Filtering
# Sampling

# Filtering
rdata %>% select(Class) %>% unique()

data_class_1 <- rdata %>% filter(Class == 1)

data_class_1 %>% select(Class) %>% unique()

data_senior_class <- rdata %>% filter(Class>5)

data_senior_class %>% select(Class) %>% unique()

# Filtering using a vector
holiday_filter <- holidays$Date
clean_data <- rdata %>% filter(Date %in% holiday_filter)
unique(clean_data$Date)
clean_data <- rdata %>% filter(!Date %in% holiday_filter)
unique(clean_data$Date)

# Sampling 
random_sample <- rdata %>% sample_n(120)
random_sample_WR <- rdata %>% sample_frac(0.1, replace = T)
random_sample_WOR <- rdata %>% sample_frac(0.1, replace = F)
set.seed(1234)

# Summarize Data
# Categorical Variables (Frequency Table)

# Unique Values
# One Variable
rdata %>% select(Class) %>% unique()

# frequency table on one variable
student_count = rdata %>% group_by(Class) %>% summarise(Count = n())
writexl::write_xlsx(student_count, 'Output/student_count.xlsx')

# frequency table on multiple variables
student_count = rdata %>% group_by(Date, Class) %>% summarise(Count = n())
View(student_count)
student_count <- student_count %>% arrange(-Count)

# Create New Variable
student_count <- student_count %>% arrange(Date, Class)
student_count <- student_count %>% mutate(Total_Students = 30)
student_count <- student_count %>% mutate(Attendance_Percentage = (Count/Total_Students)*100)

# Average Attendance per day
View(attendance_analysis)
attendance_analysis = student_count %>% 
  group_by(Date) %>% 
  summarize(Total_Attendance = sum(Count),
            Total_Strength = sum(Total_Students)) %>% 
  mutate(Attendance_Percentage = (Total_Attendance/Total_Strength)*100)

attendance_analysis <- attendance_analysis %>% arrange(Attendance_Percentage)
