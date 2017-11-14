#Reads the wind turbine data CSV, cleans and prints it out.
#input <- "wind_data.csv"
library(stringr)

#rawData <- read.csv(file="wind_data.csv", header = TRUE, sep=",")
rawData <- read.csv("wind_data.csv")
dat <- within(rawData, rm("X.GV.SD_04","X.GV.SD_05","X.GV.SD_38", "X.GV.HRR_GeneratorWindingTemp.1"))
c_names <- colnames(dat, do.NULL = TRUE, prefix = "col")
raw_data <- str_replace(c_names, "X.GV.", "")
names(dat) <- raw_data

write.csv(dat, file = "clean_wind_data.csv")
