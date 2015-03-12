

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
      paste("Number of trials:", input$increment)
    })
    
    #######################################
    # function 
    
    mycalc = function(N, type)
    {
      # returns the value of different estimators based on the sample 
      
      # N = number of data in sample 
      # type = type of distribution, specified through the selection 
      
      # Returns: mean, variance, and sd of sample 
      
      if (type == "Standard Normal")
      {
        generate = rnorm(n = N)
      }
      else if (type == "Uniform")
      {
        generate = runif(n = N)
      }
      
      result = vector(length = 3)
      names(result) = c("Mean", "Variance", "Standard Deviation")
      
      result[1] = mean(generate)
      result[2] = var(generate) 
      result[3] = sqrt(result[2])
      
      return(result) 
    }
    
    
    #######################################
    
    # graphs
    
    result = reactive({
      # a dataset containing #increments worth of samples 
      # each sample has N data points with selected distribution 
      sapply(1:input$increment, function(x) 
        mycalc(input$maxN, input$select))
    })

    
    #####
    
    output$meanplot = renderPlot({
      
      plot(result()["Mean", ], type = "l", ylab = "mean value",
           main = "Mean of Distribution", col = "red")
    })
    
    output$varplot = renderPlot({
      
      plot(result()["Variance", ], type = "l", ylab = "variance value",
           main = "Variance of Distribution", col = "dark blue")
    })
    
    output$SDplot = renderPlot({
      
      plot(result()["Standard Deviation", ], type = "l", ylab = "SD value",
           main = "Standard Deviation of Distribution", col = "black")
    })
    
  }
)