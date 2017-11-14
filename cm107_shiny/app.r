library(shiny)
library(stringr)

my_ui <- fluidPage(
	h1("This is blah"),
	h2("Subtitle"),
	"body script",
	textInput("My_text_in", "Enter text here"),
	"This is my output text",
	br(), #brake the line
	textOutput("Your_text")
)

my_server <- function(input, output){
	output$Your_text <- renderText({
		str_to_upper(input$My_text_in)
	})
}

shinyApp (ui = my_ui, server = my_server)