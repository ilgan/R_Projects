ui <- fluidPage(
	h1("This is blah"),
	h2("Subtitle"),
	"body script",
	textInput("My_text_in", "Enter text here"),
	"This is my output text",
	br(), #brake the line
	textOutput("Your_text"),
	br(), #brake the line
	plotOutput("Hist_AlcCont"),
	
	sidebarPanel(),
	mainPanel(plotOutput("Hist_AlcCont"))
	
)
