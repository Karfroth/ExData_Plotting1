#Import Data
filename<-"household_power_consumption.txt"
if(!file.exists(filename)) {
  zipname<-"exdata%2Fdata%2FNEI_data.zip"
  if(!file.exists(zipname)) {
    fileurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileurl, destfile = zipname)
  }
  unzip(zipname)
}
dfa<-read.table(filename, sep=";", header=T, na.strings = "?", stringsAsFactors = F)

#Data subsetting
Dates<-as.POSIXlt(paste(dfa$Date, dfa$Time), format="%d/%m/%Y %H:%M:%S")
dfa<-cbind(dfa,Dates)
dfa$Global_active_power<-as.numeric(dfa$Global_active_power)
date.using<-as.POSIXlt(c("2007-02-01","2007-02-03"))
dfa.sub<-subset(dfa, Dates >= date.using[1] & Dates < date.using[2])

#run chart(plot2)
png("plot2.png")
Sys.setlocale("LC_TIME", "English") #For system not using US time locale
with(dfa.sub, plot(Dates, Global_active_power, ylab="Global Active Power (kilowatts)", 
                   xlab="", type="l"))
dev.off()