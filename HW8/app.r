library(shiny)
library(ggplot2)
library(dplyr)
library(stringr)
library(downloader)
library(meme)

# load the data (retrieve and clean raw data if this is the first time)
filename_csv <- file.path("clean_wind_data.csv")
filename_jpg <- file.path("my_meme.jpg")
jpg_name <- "angry.jpg"
meme_name <- "my_meme.jpg"

if (file.exists(filename_csv)) {
	bcl <- read.csv(filename_csv, stringsAsFactors = FALSE)
} else {
	download(url = "https://raw.githubusercontent.com/ilgan/STAT545-hw-ganelin-ilya/master/HW6/10.0.103.10.csv", destfile = "wind_data.csv")
	rawData <- read.csv("wind_data.csv")
	dat <- within(rawData, rm("X.GV.SD_04","X.GV.SD_05","X.GV.SD_38", "X.GV.HRR_GeneratorWindingTemp.1"))
	c_names <- colnames(dat, do.NULL = TRUE, prefix = "col")
	raw_data <- str_replace(c_names, "X.GV.", "")
	names(dat) <- raw_data
	
	write.csv(dat, file = "clean_wind_data.csv")
}

if (file.exists(filename_jpg)){
	#Do nothing for now
} else{
	download.file(url = "http://www.happyfamilyneeds.com/wp-content/uploads/2017/08/angry8.jpg", destfile = "angry.jpg", mode="wb")
	pic <- mmplot(jpg_name) + mm_caption("Homework 8", "Yes! Give me more!", color="purple")
	ggsave("my_meme.jpg", plot = pic)
}

shinyApp(ui = ui, server = server)