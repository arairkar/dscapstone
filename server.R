#
# This is the server logic of a Shiny web application. 
#

require(shiny)
require(quanteda)
require(stringi)

source('prednextword.R')

# Define server logic to bring input and provide output
shinyServer(function(input, output) {
        
                
                inputstr <- function() ({
                        
                
                inputstr <- prednextword(input$txt1)
                
                })
                
                output$txt2 <- renderText(inputstr())
})