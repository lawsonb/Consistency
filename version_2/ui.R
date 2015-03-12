shinyUI(fluidPage
        (
          titlePanel(title = "Consistency of Estimators [Ver. 2]"), 
          
          sidebarLayout(
            sidebarPanel(
              selectInput("select", label = h3("Select a distribution"),
                          choices = list("Standard Normal" = "Standard Normal",
                                         "Uniform" = "Uniform")), 
              br(), 
              br(), 
              textInput("maxN", label = h3("Value of N"), 
                        value = "1000"),
              textInput("increment", label = h3("Number of Trials"),
                        value = "10")
              
            ),
            
            mainPanel(
              
              textOutput("text1"),
              br(),
              textOutput("text2"),
              br(), 
              textOutput("text3"),
              
              
              plotOutput("meanplot"),
              br(),
              plotOutput("varplot"),
              br(),
              plotOutput("SDplot")
              
            ),
          )
          
          
          
        ))
