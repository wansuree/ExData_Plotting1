## check/create a dir called "data"
if(!file.exists("data")) {
    dir.create("data")
}

## download the zip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip", method = "curl")
unzip("./data/Dataset.zip", exdir = "./data/")

# select data from 2007-02-01 and 2007-02-02
library(sqldf)
powerdata <- read.csv.sql("./data/household_power_consumption.txt", 
                          sql = 'select * from file where Date == "1/2/2007"
                          or Date == "2/2/2007"', 
                          sep = ";", header = TRUE, stringsAsFactors = FALSE)

## convert char to date-time data
powerdata$DateTime <- paste(powerdata$Date, powerdata$Time)
powerdata$DateTime <- strptime(powerdata$DateTime, "%d/%m/%Y %H:%M:%S", tz = "")

## check/create a dir called "figure"
if(!file.exists("figure")) {
    dir.create("figure")
}

## write a png
png(filename = './figure/plot3.png', width = 480, height = 480, units = 'px')

## x-y plot of multiple lines
## get the range for the x and y axis
xrange <- range(powerdata$DateTime) 
yrange <- range(powerdata$Sub_metering_1, 
                powerdata$Sub_metering_2, 
                powerdata$Sub_metering_3)
## set up the plot
plot(xrange, yrange, type="n", xlab = "", ylab = "Energy sub metering")
colors <- cbind("black", "red", "blue")
## add lines
with(powerdata, lines(DateTime, Sub_metering_1, col = colors[1]))
with(powerdata, lines(DateTime, Sub_metering_2, col = colors[2]))
with(powerdata, lines(DateTime, Sub_metering_3, col = colors[3]))
## add a legend
legend("topright", lty = 1, col = colors, 
        legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## close all
dev.off()
closeAllConnections()
gc()
