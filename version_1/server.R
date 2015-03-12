

shinyServer(
  function(input, output) 
  {

    #text options 
    output$text1 = renderText({
      paste("Selected distribution: ", input$select)
    })
    
    output$text2 = renderText({
      paste("Max N: ", input$maxN)
    })
      
    output$text3 = renderText({
      paste("In increasing increments of:", input$increment)
    })
    
    #######################################
    # graphs
    
    nval = reactive({
      seq(from = as.numeric(input$increment), 
                 to = as.numeric(input$maxN), 
                 by = as.numeric(input$increment))
    })
    
    result = reactive({
      # numeric vector
      
      if (input$select == "Standard Normal")
      {
        sapply(nval(), function(x) rnorm(n = x))
      }
      else if (input$select == "Uniform")
      {
        sapply(nval(), function(x) runif(n = x))
      }
    })
    
    
    output$meanplot = renderPlot({
      
      means = sapply(1:length(nval()), function(x) mean(result()[[x]] ))
      plot(nval(), means, type = "l", xlab = "N", ylab = "mean value",
           main = "Mean of Distribution")
    })
    
    output$varplot = renderPlot({
      
      vars = sapply(1:length(nval()), function(x) var(result()[[x]] ))
      plot(nval(), vars, type = "l", xlab = "N", ylab = "variance value",
           main = "Variance of Distribution")
    })
    
    
  }
)