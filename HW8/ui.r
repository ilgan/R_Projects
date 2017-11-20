library(meme)

ui <- fluidPage(

	titlePanel("Wind Turbine's Variables",
			   h1("Created by IG")
			   ),
	
	sidebarLayout(
		sidebarPanel(
			#sliderInput("priceInput", "Price", 0, 100, c(25, 40), pre = "$"),
			radioButtons("varInput", "Select Variable",
						 choices = c("HRR_GearboxOilTemp", "HRR_GeneratorWindingTemp", "HRR_NacelleAirTemp", "HRR_kW"),
						 selected = "HRR_kW"),
			uiOutput("varOutput"),
			img(src = "my_meme.jpg", width = "100%")
		),
		
		mainPanel(
			plotOutput("simple_plot"),
			br(),
			plotOutput("Var_vs_Wind"),
			br(), 
			br(),
			tableOutput("table_head")
		)
	)
)