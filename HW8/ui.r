library(meme)
library(shinythemes)
library(DT)

ui <- fluidPage(
	theme = shinytheme("journal"),

	titlePanel("Wind Turbine's Variables"
			   ),
	
	sidebarLayout(
		sidebarPanel(
			img(src = "my_meme.jpg", width = "100%"),
			#sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
			radioButtons("varInput", "Select Variable",
						 choices = c("HRR_GearboxOilTemp", "HRR_GeneratorWindingTemp", "HRR_NacelleAirTemp", "HRR_kW"),
						 selected = "HRR_kW"),
			uiOutput("varOutput")
		),
		
		mainPanel(
			tabsetPanel(
				tabPanel("Simple Plot", plotOutput("simple_plot")),
				tabPanel("Interactive Plot", plotOutput("Var_vs_Wind")),
				tabPanel("Table", DT::dataTableOutput("table_head"))
			),
			h3("@created by IG")
		)
	)
)