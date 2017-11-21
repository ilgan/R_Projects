library(shiny)
library(ggplot2)
library(dplyr)
library(meme)
library(DT)
library(shinyjs)
library(lightsout)
library(ggmap)

server <- function(input, output) {
	# Read the cleaned data
	cwd <- read.csv("clean_wind_data.csv", stringsAsFactors = FALSE)
	#map_in <- get_map(location = c(lon = input$lon, lat = input$lat), zoom = "auto", scale = "auto", maptype = "terrain")
	
	output$map <- renderPlot({
		map_in <- get_map(location = c(lon = input$lon, lat = input$lat), zoom = "auto", scale = "auto", maptype = "terrain")
		ggmap(map_in)+geom_point(aes_string(x=input$lat, y=input$lon), colour = "red")
	})
	
	# Create meme out of downloaded image
	output$my_meme <- renderImage({
		plot(m <- "www/turbine.png")
		})
	
	# Histogram plot
	output$simple_plot <- renderPlot({ #shinyjs::colourOutput() ({
		dist <- switch(input$varInput,
					   norm = rnorm,
					   unif = runif,
					   lnorm = rlnorm,
					   exp = rexp,
					   rnorm)
		hist(dist(500))
	})
	
	# Interactive graph with Linear Regression
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
	
	# Rendering interactive table
	output$table_head <- renderDataTable({ #renderTable({
		cwd
	}) 
	
	# Download csv file button
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
	
	#Lights out game
	values <- reactiveValues(
		size = NULL,     # Number of rows/columns
		board = NULL,    # The board matrix
		showHint = NULL, # Whether or not to show hints on the board
		solution = NULL, # The solution matrix
		active = NULL    # Whether or not a game is currently in session
	)
	
	# New game button is clicked (this also runs when the app first loads)
	observeEvent(input$newgame, ignoreNULL = FALSE, {
		values$size <- as.numeric(input$boardSize)
		values$board <- random_board(values$size, input$mode == "classic")
		values$showHint <- FALSE
		values$solution <- NULL
		values$active <- TRUE
	})
	
	# When the board changes or hints are turned on/off, redraw the board
	output$board <- renderUI({
		values$board
		values$showHint
		
		isolate({
			size <- values$size
			
			div(
				id = "board-inner",
				class = ifelse(values$active, "active", "inactive"),
				div(id = "board-shield"),
				
				lapply(seq(size), function(row) {
					tagList(
						div(
							class = "board-row",
							lapply(seq(size), function(col) {
								value <- board_entries(values$board)[row, col]
								visClass <- ifelse(value == 0, "off", "on")
								solutionClass <-
									ifelse(
										values$showHint && (values$solution[row, col] == 1),
										"solution",
										""
									)
								id <- sprintf("cell-%s-%s", row, col)
								
								actionLink(
									id, NULL,
									class = paste("board-cell", visClass, solutionClass),
									`data-row` = row,
									`data-col` = col
								)
							})
						),
						div()
					)
				})
			)
		})
	})
	
	# Define click handlers for clicking on any possible cell on the board
	# (this could also be done dynamically with each board creation, but there's
	# no need to do that since we know the board can have a maximum size)
	lapply(seq(max(allowed_sizes)), function(row) {
		lapply(seq(max(allowed_sizes)), function(col) {
			id <- sprintf("cell-%s-%s", row, col)
			observeEvent(input[[id]], {
				suppressMessages(
					values$board <- play(values$board, row = row, col = col)
				)
				if (values$showHint) {
					values$solution <- solve_board(values$board)
				}
				
				if (is_solved(values$board)) {
					values$active <- FALSE
				}
			})
		})
	})
	
	# User clicked on the "Show solution" button
	observeEvent(input$solve, {
		values$showHint <- !values$showHint
		if (values$showHint) {
			values$solution <- solve_board(values$board)
		}
	})
	
	# Show the solutions button is pressed after it's clicked
	observe({
		toggleClass(id = "solve", class = "active", condition = values$showHint)
	})
	
	# Show/disable elements when the game is over
	observe({
		toggle(id = "congrats", condition = !values$active)
		toggleState(id = "solve", condition = values$active)
	})
}