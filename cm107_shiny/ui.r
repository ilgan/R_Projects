ui <- fluidPage(
	
	# Application title
	titlePanel("My liquor webpage"),
	
	sidebarPanel("This is my sidebar",
				 img(src = "kitten.jpg", width = "100%")),
	
	sidebarPanel("Side Bar",
			   sliderInput("priceIn", "Price of booze",
			   			min = 0, max = 300, value = c(10,20), pre = "CAD")),
	
	radioButtons("typeIn", "What kind of booze?", 
				 choices = c("BEER", "SPIRITS", "WINE"), selected = "WINE"),
	
	mainPanel(plotOutput("Hist_AlcCont"),
			  br(),br(),
			  tableOutput("table_head"),
			  plotOutput("Geom_P")
			  )
)