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

#Charts(plot4)
png("plot4.png")
Sys.setlocale("LC_TIME", "English") #For system not using US time locale
parmfrowbackup<-par("mfrow") #backup mfrow setting
par(mfrow=c(2,2)) #Setting layout
#Topleft
with(dfa.sub, plot(Dates, Global_active_power, ylab="Global Active Power (kilowatts)", 
                   xlab="", type="l"))
#Topright
with(dfa.sub, plot(Dates, Voltage, ylab="Global Active Power (kilowatts)", 
                   xlab="datetime", type="l"))
#Bottomleft
plotn3<-function(){
  with(dfa.sub, plot(Dates, Sub_metering_1, xlab="", ylab="Energy sub metering", type="l"))
  with(dfa.sub, lines(Dates, Sub_metering_2, col="red"))
  with(dfa.sub, lines(Dates, Sub_metering_3, col="blue"))
  legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=1,
         bty="n", col=c("black", "red","blue"))
}
plotn3()
#Bottomright
with(dfa.sub, plot(Dates, Global_reactive_power, xlab="datetime", type="l"))

par(mfrow=parmfrowbackup) #Recovering layout

dev.off()