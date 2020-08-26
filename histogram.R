library(dplyr)
library(tidyverse)
library(lubridate)
# Download the file
if (!file.exists("./Week1")) {
  dir.create("./Week1")
}
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile = "./Week1/Dataset.zip")
download <- date()

unzip(zipfile = "./Week1/Dataset.zip", exdir = "./Week1")

consumption <- read.table("./week1/household_power_consumption.txt", header = TRUE, sep = ";")[c(23438:24876,68077:69516),]
consumption$DT <- with(consumption, mdy(Date) + hms(Time))
consumption$DT <- as.POSIXct(consumption$DT)
dateTime <- consumption$DT
global_active <- as.numeric(consumption$Global_active_power)
global_reactive <- as.numeric(consumption$Global_reactive_power)
voltage <- as.numeric(consumption$Voltage)
intensity <- as.numeric(consumption$Global_intensity)
sub1 <- as.numeric(consumption$Sub_metering_1)
sub2 <- as.numeric(consumption$Sub_metering_2)
sub3 <- as.numeric(consumption$Sub_metering_3)
hist(global_active, xlab = "Global Active Power (kilowatts)", col="red", main = "Global Active Power")
dev.copy(png, file = "./week1/Global Active.png")
dev.off()
