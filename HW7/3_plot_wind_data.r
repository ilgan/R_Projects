library(tidyverse)
library(ggplot2)
library(stringr)

plot_and_save <- function(df, var1, var2, save_flag=TRUE){
	my_plot <- ggplot(df, aes(df[[var1]], df[[var2]])) +
		geom_point() +
		geom_smooth(se=FALSE)
	
	if(save_flag == TRUE){
		#mkdirs(media)
		ggsave("media/my_plot.png", plot = my_plot)
	}
}

input_csv <- read.csv(file="clean_wind_data.csv", header=TRUE, sep=",")
plot_and_save(input_csv, "HRR_WTCorrectedWindSpeed", "HRR_kW", TRUE)