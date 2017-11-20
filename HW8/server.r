library(shiny)
library(ggplot2)
library(dplyr)
library(meme)


server <- function(input, output) {
	cwd <- read.csv("clean_wind_data.csv", stringsAsFactors = FALSE)
	output$my_meme <- renderImage({
		plot(m <- "www/angry.png")
		})

	output$simple_plot <- renderPlot({
		dist <- switch(input$varInput,
					   norm = rnorm,
					   unif = runif,
					   lnorm = rlnorm,
					   exp = rexp,
					   rnorm)
		
		hist(dist(500))
	})
	
	output$Var_vs_Wind <- renderPlot({
		my_y <- switch(input$varInput)
		my_y <- (input$varInput)
		
		cwd %>%
			ggplot() +
			aes(x = HRR_WTCorrectedWindSpeed, y = cwd[,my_y]) +
			geom_point() +
			labs(title = "Wind Speed vs Chosen Variable")+
			theme_classic() +
			geom_smooth(se=FALSE)
	})

	output$table_head <- renderTable({
		cwd %>%
			head()
	}) 
}