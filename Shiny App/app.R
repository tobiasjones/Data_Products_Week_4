#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("Motor Trend Car Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
          selectInput("variable", "Variable:",
                      list("Cylinders" = "cyl", 
                           "Transmission" = "am", 
                           "Gears" = "gear")),
          
          checkboxInput("outliers", "Show outliers", FALSE)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
          
          h3(textOutput("caption")),
          
          plotOutput("mpgPlot")
      )
   )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
    # Compute the forumla text in a reactive expression since it is 
    # shared by the output$caption and output$mpgPlot expressions
    formulaText <- reactive({
        paste("mpg ~", input$variable)
    })
    
    # Return the formula text for printing as a caption
    output$caption <- renderText({
        formulaText()
    })
    
    # Generate a plot of the requested variable against mpg and only 
    # include outliers if requested
    output$mpgPlot <- renderPlot({
        boxplot(as.formula(formulaText()), 
                data = mpgData,
                outline = input$outliers)
    })
})

# Run the application 
shinyApp(ui = ui, server = server)

