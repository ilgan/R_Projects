library(meme)
library(shinythemes)
library(DT)

ui <- fluidPage(
	theme = shinytheme("journal"),

	titlePanel("Wind Turbine's Variables"),
	
	sidebarLayout(
		sidebarPanel(
			img(src = "turbine.png", width = "50%"),
			#sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
			radioButtons("varInput", "Select Variable",
						 choices = c("HRR_GearboxOilTemp", "HRR_GeneratorWindingTemp", "HRR_NacelleAirTemp", "HRR_kW"),
						 selected = "HRR_kW"),
			uiOutput("varOutput")
		),
		
		mainPanel(
			tabsetPanel(
				tabPanel("Project Scope",
						 img(src = "flow.jpg", width = "50%"),
						 "This project..."),
				tabPanel("Table", DT::dataTableOutput("table_head"),
						 br(),
						 # Button
						 radioButtons("filetype", "File type:", choices = c("csv", "tsv")),
						 downloadButton("downloadData", "Download")
				),
				tabPanel("Histogram", plotOutput("simple_plot")),
				tabPanel("Linear Regression", plotOutput("Var_vs_Wind")),
				tabPanel("PCA Analysis", 
						 h5("First two PCs modes explain more than 90% of the data variance."),
						 img(src = "Variance.png", width = "50%"),
						 h5("Two PCs and corresponding Eigenvectors."),
						 img(src = "EigPC.png", width = "50%")
						 ),
				tabPanel("Future Tasks",
						 "Neural Network...")
			),
			
			h6("@created by IG")
		)
	)
)