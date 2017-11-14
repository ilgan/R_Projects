library(shiny)
library(tidyverse)

server <- function(input, output){
	bcl_data <- read_csv("Data/bcl-data.csv")
	output$Hist_alcCont <- renderPlot({
	bcl_data %>% 
		ggplot() + 
		aes(x = Alcohol_content) +
		geom_histogram()
	})
}
	