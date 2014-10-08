#Part of code for Project-1 of Exploratory Data Analysis
#
#--------------------
# Written to plot the plot-2 of the project
#--------------------
# 1) Download and unzip Data from URL if not already downloaded
# 2) Read Data into R
#		For this, to make reading faster, do the following :
#		a) Capture the classes for data
#		b) Compute the number of rows of data using unix command wc. May not work on windows machine. 
# 3) Subset data to use only the rows corresponding to two specified dates
# 4) Launch png graphics device
# 5) plot required graph using neceaasry command/commands.
# 6) close the launched graphic device 
#####################

library(stringr)

#make sure the working directotry is set as per your need

# Take the file download link from Coursera Project page
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
datafile <- "household_power_consumption.txt"

#Download and unzip the data file if not already downloaded and unzipped
if(!file.exists(datafile)){
	print("Downloading and Unzipping the Data File...")		
	download.file(fileurl, destfile = "project1data.zip",method = "curl")
	unzip("project1data.zip", exdir = ".")
} else {
	print(paste0("The data file ",datafile," already exists. Using it to create plots instead of downloading again..."))}


#note that this is a large file with size ~133MB. Make sure you have enough RAM to read it.
#
# To read the file faster, get to know the number of rows in the file and classes of data columns
#
############
unixcommand <- paste("wc",datafile)
unixop <- system(unixcommand, intern = TRUE) # find out the length of the file
sizeof <- as.numeric(strsplit(str_trim(unixop)," ")[[1]][1]) # capture the length from the unix output created as list

print(paste0("The data file has ",sizeof," Records (including the header record)"))
print(paste0("Please wait while all the ",sizeof," records are being read into R as a data frame."))
print("It shall take about 20 seconds, or more/less based on your machine speed !...")

#To make the file reading faster also read the classes.  
tab5rows <- read.table(datafile,header = TRUE, sep = ";", nrow =5 )
tabclasses <- sapply(tab5rows, class)

###### Finally read all data into RAM.
timetaken <- system.time(alldata <- read.table(datafile, header = TRUE, sep = ";", nrow = sizeof, colClasses = tabclasses, na.string = "?", comment.char = ""))
print(paste0("It took ",timetaken[1]," seconds to read the file into R"))

# note above that if you don't mention na.string = "?" you will get an error when data encounters ?
# this error wont come if you dont mention classes.
# also setting comment.char will make the file reading faster. There are no comments in data file.(assumed)


# Now subset by only the data for "2007-02-01" and "2007-02-02" dates only.
smalldata <- alldata[alldata$Date %in% c("1/2/2007","2/2/2007"),]


##### PLOT-2
# combine date and time data in string form to form a datetime number in Date form using strptime function
datetimecol <- strptime(paste(smalldata[,1],smalldata[,2]),"%d/%m/%Y %H:%M:%S")
png(filename = "plot2.png", width = 480, height = 480, bg = "white") # bg = "transparent" would produce exact png file as available as reference in the assignment but I am using "white" for better viewability of peers when they are viewing individual files

plot(datetimecol, smalldata[,3],  type = "l", ylab = "Global Active Power (Kilowatts)", xlab ="")
dev.off()

