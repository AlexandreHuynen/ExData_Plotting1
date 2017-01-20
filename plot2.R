## plot2

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

# The 'Global_active_power' column is reformated
datasub$Global_active_power <- as.numeric(datasub$Global_active_power)


# Plot
with(datasub, plot(Time, Global_active_power, type = "l",
     xlab = "" , ylab = "Global Active Power (kilowatts)"))


# Export to png format
dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()