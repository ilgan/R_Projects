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
			uiOutput("varOutput")
		),
		
		mainPanel(
			#imageOutput("my_meme"),
			#img(src="angry.jpg", height = 22, width = 100),"mytitle"),
			img(src = "angry.png", width = "20%"),
			br(),
			plotOutput("simple_plot"),
			br(),
			plotOutput("Var_vs_Wind"),
			br(), 
			br(),
			tableOutput("table_head")
		)
	)
)