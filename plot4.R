## plot4

# We start this script by checking if the txt file is in the current directory
# or in a subdirectory. If no, it is downloaded.
filename <- "household_power_consumption.txt"
datafile <- dir(pattern = filename, recursive = TRUE)

if(length(datafile) == 0){
        # The txt file is not in the directory or a subdirectory
        # It is thus downloaded, read and its content stored in 'data'
        temp <- tempfile()
        fileUrl <- paste("https://d396qusza40orc.cloudfront.net/",
                         "exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                         sep = "")
        download.file(fileUrl, temp, method = "curl")
        data <- read.table(unzip(temp), header = TRUE, sep = ";", dec = ".", 
                           stringsAsFactors = FALSE)
        unlink(temp)
        
} else {
        # The txt file is in the directory or a subdirectory
        # The file is read and its content stored in 'data'
        data <- read.table(datafile, header = TRUE, sep = ";", dec = ".", 
                           stringsAsFactors = FALSE)
}

# The 'Date' column is reformated and the appropriate subset selected, that is 
# the dates 2007-02-01 and 2007-02-02.
data$Date <- as.Date(data$Date,  format = "%d/%m/%Y")
datasub <- subset(data, Date == "2007-02-01" | Date == "2007-02-02")

# The 'Time' column is reformated using the 'Date' column
datasub$Time <- strptime(paste(datasub$Date, datasub$Time), 
                         format = "%Y-%m-%d %H:%M:%S")

# The 'Global_active_power' column is reformated and plotted
datasub$Global_active_power <- as.numeric(datasub$Global_active_power)
par(mfrow=c(2,2))
with(datasub, plot(Time, Global_active_power, type = "l",
     xlab = "" , ylab = "Global Active Power"))

# The 'Voltage' column is reformated and plotted
datasub$Voltage <- as.numeric(datasub$Voltage)
with(datasub, plot(Time, Voltage, type = "l", 
                   xlab = "datetime", ylab = "Voltage"))

# The 'Sub_metering_X' columns are reformated and plotted
datasub$Sub_metering_1 <- as.numeric(datasub$Sub_metering_1)
datasub$Sub_metering_2 <- as.numeric(datasub$Sub_metering_2)
datasub$Sub_metering_3 <- as.numeric(datasub$Sub_metering_3)
with(datasub, plot(Time, Sub_metering_1, type = "l", 
                   xlab = "" , ylab = "Energy sub melting"))
with(datasub, lines(Time, Sub_metering_2, col = "red"))
with(datasub, lines(Time, Sub_metering_3, col = "Blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = 1, lwd = 1, col = c("black", "red", "blue"), 
       y.intersp = 0.3, bty = "n", cex = 0.75)

# The 'Global_reactive_power' column is reformated and plotted
datasub$Global_reactive_power <- as.numeric(datasub$Global_reactive_power)
with(datasub, plot(Time, Global_reactive_power, type = "l", xlab = "datetime"))

# Export to png format
dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()