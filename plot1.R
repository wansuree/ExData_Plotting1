## check/create a dir called "data"
if(!file.exists("data")) {
    dir.create("data")
}

## download zip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip", method = "curl")
unzip("./data/Dataset.zip", exdir = "./data/")

## select data from 2007-02-01 and 2007-02-02
library(sqldf)
powerdata <- read.csv.sql("./data/household_power_consumption.txt", 
                           sql = 'select * from file where Date == "1/2/2007"
                                    or Date == "2/2/2007"', 
                           sep = ";", header = TRUE, stringsAsFactors = FALSE)

## check/create a dir called "figure"
if(!file.exists("figure")) {
    dir.create("figure")
}

## write a png
png(filename = './figure/plot1.png', width = 480, height = 480, units = 'px')

## histogram plot of Global Active Power
hist(powerdata$Global_active_power, 
     col = "red",
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")

## close all
dev.off()
closeAllConnections()
gc()
