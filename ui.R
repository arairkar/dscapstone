#
# App for predicting next word.
# For JHU data science specialization capstone 
# 
require(shiny)
require(shinythemes)

# Define UI for accepting text string and predicting next word
shinyUI(fluidPage(
        theme=shinytheme("superhero"),
  
  # Application title
  headerPanel("Data Science Capstone: Text prediction UI"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    
    
    sidebarPanel(
        textInput("txt1", label = h3("Please enter a few initial words"), 
                  value = "e.g. I am"),
        h5("Note: It may take a few minutes to initialize application")
       
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tags$head(
        tags$style(HTML("hr {border-top: 5px solid ;}"))
      ),
            tags$hr(),
            h4("The next possible words are: "),
            textOutput("txt2"),
            tags$hr(),
      h5("This web applicaton was created towards partial fulfilment of the capstone project of the 
               Johns Hopkins specialization on Coursera "),
      h5("Author expresses deepest gratitude towards the instructors, mentors and cohorts of
               the coursera community"),
      h5("The code repository can be found at:"),
      tags$a(href="https://github.com/arairkar/dscapstone", "github repository!")
    )
  )
)
)
