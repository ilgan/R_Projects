library(meme)
library(shinythemes)
library(DT)
library(lightsout)

share <- list(
	title = "Lights Out",
	url = "http://daattali.com/shiny/lightsout/",
	image = "http://daattali.com/shiny/img/lightsout.png",
	description = "Play the classic Lights Out puzzle game in R",
	twitter_user = "daattali"
)

ui <- fluidPage(
	# We can set up the theme for the whole page
	theme = shinytheme("journal"),
	
	titlePanel("Wind Turbine's Variables"),
	
	# Sedebar with the toggle menue and the wind turbine picture, or meme as an alternative
	sidebarLayout(
		sidebarPanel(
			img(src = "turbine.png", width = "50%"),
			#sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
			radioButtons("varInput", "Select Variable",
						 choices = c("HRR_GearboxOilTemp", "HRR_GeneratorWindingTemp", "HRR_NacelleAirTemp", "HRR_kW"),
						 selected = "HRR_kW"),
			uiOutput("varOutput")
		),
		
		# Main panel consist of the tabset Panels.
		mainPanel(
			tabsetPanel(
				tabPanel("Project Scope",
						 img(src = "flow.jpg", width = "50%"),
						 br(),
						 h4("Project statement"),
						 p("Wind turbines have been in use long before electricity was discovered to harness the power of the wind to do useful work and generate energy by converting the kinetic energy in wind into electrical energy. The current generated in the coils of a wind turbine creates an enormous amount of heat. This heat is directly proportional to the amount of power generated. The coils in the generator could get overheated if the wind speed goes above certain limits. Every ten degrees above temperature threshold of continuous operation, described in the spec sheet of the generator, reduces expected life of the generator in half."),
						 h4("Objective "),
						 p("The objective of this project would be to apply a predictive model on the wind turbine’s aggregated data and try to predict the generator’s winding temperature during its effective lifetime in a specific location and component configuration. We will build a model that will maximize energy production of the wind turbine (more specifically generator’s itself) through its effective lifetime.")
						   ),
				tabPanel("Table", DT::dataTableOutput("table_head"),
						 br(),
						 # Button
						 radioButtons("filetype", "File type:", choices = c("csv", "tsv")),
						 downloadButton("downloadData", "Download")
				),
				tabPanel("Histogram", plotOutput("simple_plot")),
				tabPanel("Linear Regression", plotOutput("Var_vs_Wind")),
				tabPanel("PCA Analysis", 
						 p("First two PCs modes explain more than 90% of the data variance."),
						 br(),
						 img(src = "Variance.png", width = "50%"),
						 br(),
						 p("Two PCs and corresponding Eigenvectors."),
						 br(),
						 img(src = "EigPC.png", width = "50%"),
						 br(),
						 p("Note: content was created using Matlab."),
						 br()
				),
				tabPanel("Future Tasks",
						 "Neural Network..."),
				
				tabPanel(
					title = "Lights Out",
					shinyjs::useShinyjs(),
					tags$head(
						tags$link(href = "style.css", rel = "stylesheet")
					),

					div(id = "header",
						div(id = "title",
							"Lights Out"
						)
					),
					fluidRow(
						column(4, wellPanel(
							id = "leftPanel",
							selectInput("boardSize", "Board size",
										unlist(lapply(allowed_sizes,
													  function(n) setNames(n, paste0(n, "x", n))))),
							selectInput("mode", "Game mode",
										c("Classic" = "classic",
										  "Variant" = "variant")),
							actionButton("newgame", "New Game", class = "btn-lg"),
							hr(),
							p("Lights Out is a puzzle game consisting of a grid of lights that",
							  "are either", em("on"), "(light green) or", em("off"), "(dark green). In", em("classic"), "mode, pressing any light will toggle",
							  "it and its adjacent lights. In", em("variant"), "mode, pressing a light will toggle all the lights in its",
							  "row and column. The goal of the game is to", strong("switch all the lights off."))
						)),
						column(8,
							   hidden(div(id = "congrats", "Good job, you won!")),
							   uiOutput("board"),
							   br(),
							   actionButton("solve", "Show solution")
						)
					)
				)
			),
			
			br(),
			br(),
			# Foot note
			h6("created by IG, 2017")
		)
	)
)