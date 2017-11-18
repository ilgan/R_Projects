library(shiny)
library(ggplot2)
library(dplyr)


server <- function(input, output) {
	cwd <- read.csv("clean_wind_data", stringsAsFactors = FALSE)
	
	output$countryOutput <- renderUI({
		selectInput("countryInput", "Country",
					sort(unique(cwd$Country)),
					selected = "CANADA")
	})  
	
	filtered <- reactive({
		if (is.null(input$countryInput)) {
			return(NULL)
		}    
		
		bcl %>%
			filter(Price >= input$priceInput[1],
				   Price <= input$priceInput[2],
				   Type == input$typeInput,
				   Country == input$countryInput
			)
	})
	
	output$coolplot <- renderPlot({
		if (is.null(filtered())) {
			return()
		}
		ggplot(filtered(), aes(Alcohol_Content)) +
			geom_histogram()
	})
}