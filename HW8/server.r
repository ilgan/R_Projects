library(shiny)
library(ggplot2)
library(dplyr)
library(meme)
library(DT)
library(shinyjs)

server <- function(input, output) {
	
	cwd <- read.csv("clean_wind_data.csv", stringsAsFactors = FALSE)
	
	output$my_meme <- renderImage({
		plot(m <- "www/angry.png")
		})

	output$simple_plot <- renderPlot({ #shinyjs::colourOutput() ({
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

	output$table_head <- renderDataTable({ #renderTable({
		cwd
	}) 
	
	output$downloadData <- downloadHandler(
		# This function returns a string which tells the client
		# browser what name to use when saving the file.
		filename = function() {
			paste(input$dataset, input$filetype, sep = ".")
		},
		
		# This function should write data to a file given to it by
		# the argument 'file'.
		content = function(file) {
			sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
			
			# Write to a file specified by the 'file' argument
			write.table(datasetInput(), file, sep = sep,
						row.names = FALSE)
		}
	)
}