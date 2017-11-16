library(tidyverse)
library(shiny)
library(stringr)

server <- function(input, output) {
	bcl_data <- read_csv("Data/bcl-data.csv")
	
	filtered_bcl <- reactive({
		bcl_data %>% 
		filter(Price >= input$priceIn[1], Price <= input$priceIn[2], Type == input$typeIn)
	})
		
	
	output$Hist_AlcCont <- renderPlot({
		bcl_data %>%
			filter(Price >= input$priceIn[1], Price <= input$priceIn[2], Type == input$typeIn) %>% 
			ggplot() +
			aes(x = Alcohol_Content) +
			geom_histogram()
	})
	
	output$Geom_P <- renderPlot({
		bcl_data %>%
			ggplot() +
			aes(x = Country, y=Price) +
			geom_point()
	})
	
	output$table_head <- renderTable({
		bcl_data %>%
			filter(Price >= input$priceIn[1], Price <= input$priceIn[2], Type == input$typeIn) %>% 
			head()
	}) 
}