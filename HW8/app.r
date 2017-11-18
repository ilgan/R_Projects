library(shiny)
library(ggplot2)
library(dplyr)
library(stringr)
library(downloader)

# load the data (retrieve and clean raw data if this is the first time)
filename <- file.path("clean_wind_data.csv")
if (file.exists(filename)) {
	bcl <- read.csv(filename, stringsAsFactors = FALSE)
} else {
	download(url = "https://raw.githubusercontent.com/ilgan/STAT545-hw-ganelin-ilya/master/HW6/10.0.103.10.csv", destfile = "wind_data.csv")
	rawData <- read.csv("wind_data.csv")
	dat <- within(rawData, rm("X.GV.SD_04","X.GV.SD_05","X.GV.SD_38", "X.GV.HRR_GeneratorWindingTemp.1"))
	c_names <- colnames(dat, do.NULL = TRUE, prefix = "col")
	raw_data <- str_replace(c_names, "X.GV.", "")
	names(dat) <- raw_data
	
	write.csv(dat, file = "clean_wind_data.csv")
	
}

shinyApp(ui = ui, server = server)
