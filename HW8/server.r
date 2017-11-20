library(shiny)
library(ggplot2)
library(dplyr)
library(meme)


server <- function(input, output) {
	cwd <- read.csv("clean_wind_data.csv", stringsAsFactors = FALSE)
	output$my_meme <- renderImage({
		outfile <- tempfile("angry.png")
		#outfile <- mmplot(pic) + mm_caption("Homework 8", "Yes! Give me more!", color="purple"),
		#jpg(outfile, width = 400, height = 300)
		#dev.off()
		})

	#output$simple_plot <- renderPlot({hist(cwd$HRR_WTCorrectedWindSpeed)})
	#output$simple_plot <- renderPlot({hist(as. (input$varInput))})
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
		cwd %>%
			ggplot() +
			#aes(x = primaryLovatoReadings.L1PhaseVoltage, y = input$varInput) +
			aes(x = HRR_WTCorrectedWindSpeed, y = input$varInput) +
			geom_point() +
			geom_smooth(se=FALSE)
	})

	output$table_head <- renderTable({
		cwd %>%
			head()
	}) 
}