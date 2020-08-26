library(dplyr)
library(tidyverse)
library(lubridate)
library(gridExtra)
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
dates <- consumption$Date
dateTime <- consumption$DT
global_active <- as.numeric(consumption$Global_active_power)
global_reactive <- as.numeric(consumption$Global_reactive_power)
voltage <- as.numeric(consumption$Voltage)
intensity <- as.numeric(consumption$Global_intensity)
sub1 <- as.integer(consumption$Sub_metering_1)
sub2 <- as.integer(consumption$Sub_metering_2)
sub3 <- as.integer(consumption$Sub_metering_3)
consumption <- data.frame(dates, dateTime, global_active, global_reactive, voltage, intensity, sub1, sub2, sub3)
plot1 <- ggplot(consumption) + geom_line(aes(x=dateTime, y=global_active)) + labs(y="Global Active Power") +
  theme_bw() + theme(element_blank()) + scale_x_datetime(date_breaks = "day", date_labels = "%a")
plot2 <- ggplot(consumption) + geom_line(aes(x=dateTime, y=voltage)) + labs(y="Voltage") +
  theme_bw() + theme(element_blank()) + scale_x_datetime(date_breaks = "day", date_labels = "%a")
plot3 <- ggplot(consumption, aes(x=dateTime)) +geom_line(aes(y=sub1,color = "Sub Meter 1")) + geom_line(aes(y=sub2,color = "Sub Meter 2")) +
  geom_line(aes(y=sub3, color = "Sub Meter 3")) + labs(y="Energy Sub Metering") + 
  theme_bw() + 
  theme(element_blank(), legend.title = element_blank(), 
        legend.position = c(.995,.995), legend.justification = c("right","top")) + ylim(0,30) +
  scale_x_datetime(date_breaks = "day", date_labels = "%a")
plot4 <- ggplot(consumption) + geom_line(aes(x=dateTime, y=global_reactive)) + labs(y="Global Reactive Power") +
  theme_bw() + theme(element_blank()) + scale_x_datetime(date_breaks = "day", date_labels = "%a")
grid.arrange(plot1, plot2, plot3, plot4, ncol=2, nrow=2)
dev.copy(png, file = "./week1/Combined Graphs.png")
dev.off()
