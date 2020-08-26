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

consumption <- read.table("./week1/household_power_consumption.txt", header = TRUE, sep = ";")
consumption <- consumption[consumption$Date=="2/1/2007"|consumption$Date=="2/2/2007",]
consumption$DT <- with(consumption, mdy(Date) + hms(Time))
consumption$DT <- as.POSIXct(consumption$DT)
consumption$dayOfWeek <- weekdays(as.Date(consumption$dates, format = "%m/%d/%Y"))
dates <- consumption$Date
dateTime <- consumption$DT
days <- consumption$dayOfWeek
global_active <- as.numeric(consumption$Global_active_power)
global_reactive <- as.numeric(consumption$Global_reactive_power)
voltage <- as.numeric(consumption$Voltage)
intensity <- as.numeric(consumption$Global_intensity)
sub1 <- as.integer(consumption$Sub_metering_1)
sub2 <- as.integer(consumption$Sub_metering_2)
sub3 <- as.integer(consumption$Sub_metering_3)
consumption <- data.frame(dates, days, dateTime, global_active, global_reactive, voltage, intensity, sub1, sub2, sub3)
ggplot(consumption, aes(x=dateTime)) +geom_line(aes(y=sub1,color = "Sub Meter 1")) + geom_line(aes(y=sub2,color = "Sub Meter 2")) +
  geom_line(aes(y=sub3, color = "Sub Meter 3")) + labs(x="DateTime", y="Energy Sub Metering") + 
  theme_bw() + 
  theme(element_blank(), legend.title = element_blank(), 
        legend.position = c(.97,.99), legend.justification = c("right","top")) + ylim(0,25)
dev.copy(png, file = "./week1/Meter Time Series.png")
dev.off()
