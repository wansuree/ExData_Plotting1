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

## convert char to time data
powerdata$DateTime <- paste(powerdata$Date, powerdata$Time)
powerdata$DateTime <- strptime(powerdata$DateTime, "%d/%m/%Y %H:%M:%S", tz = "")

dev.copy(png, './figure/plot1.png')
hist(powerdata$Global_active_power, 
     col = "red",
     main = "Global Active Power", 
     xlab = "Global Active Power [kW]")
dev.off()