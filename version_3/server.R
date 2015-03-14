

shinyServer(
  function(input, output) 
  {
    
    #text options 
    output$text1 = renderText({
      paste("Selected distribution: ", input$select)
    })
    
    output$text2 = renderText({
      paste("Number of estimates per N: ", input$xruns)
    })

    # preset values (could make it so they can be changed)
    if (input$select == "Standard Normal")
    {
      true.mean = 0
      true.sd = 1
      }
      else if (input$select == "Uniform") {
        # as set now it does U(0,1), if change it would do (-0.5,0.5)
        true.mean = 0.5  # could set to 0
        true.sd = 1/sqrt(12) # setting the sd sets the width ( width = sd*sqrt(12) )
      }
    
    #######################################
    # functions 
    
    
    mytype_gen = function(N, type, mean, sd)
    {
      # returns ONE randomly generated sample of distribution I am using 
      # the distribution is specified via user input select 
      
      # Arguments: 
      # N = sample size 
      # type = type of distribution 
      
      if (type == "Standard Normal")
      {
       generate = rnorm(N, mean, sd)
       }
      else if (type == "Uniform")
      {
         max = mean + sqrt(3)*sd
         min = mean - sqrt(3)*sd
         generate = runif(N, max, min)
      }
      
      return(generate)
    }
    
    
    mycalc = function(type, weights)
    {
      # returns the value of different estimators based on the sample 
      
      # Arguments: 
      # type = type of distribution 
      # weights = vector of the size of the samples (N)
      
      # Returns: sample means, variances, and sd of sample 
      #           in the form of a named list 
      
      temp = sapply(weights, function(x) mytype_gen(N = x, type = type, true.mean, true.sd)) 
      
      
      result = list() 
      
      result$mean = sapply(1:length(temp), function(x) mean(temp[[x]]))
      result$var = sapply(1:length(temp), function(x) var(temp[[x]]))
      result$sd = sqrt(result$var)
      
      return(result) 
    }
    
    
    #######################################
    
    # operator code 
    

    Nvals = reactive({
      # x = how many estimated statistics user wants for each N 
      # Returns: index of N values to calculate estimators from 
      
      x = input$xruns
      numweights = c(rep(10, x), rep(100, x), rep(250, x), 
                rep(500, x), rep(1000, x), rep(2000, x))
      
      return(numweights)
      
    })

    
    results = reactive({
      # a list containing the estimator values for each individual sample 
      # plot with weights to form a graph 
      
      fin = mycalc(type = input$select, weights = Nvals())
      return(fin)
      
    })
    
    
    ###########################
    # graphs 
    
    
    output$meanplot = renderPlot({
      
      plot(Nvals(), results()$mean, xlab = "N", ylab = "mean value",
           main = "Mean of Distribution")
           abline(h = true.mean, col = "green") 
   })
    
    output$varplot = renderPlot({
      
      plot(Nvals(), results()$var, xlab = "N", ylab = "variance value",
           main = "Variance of Distribution")
     })
    
    output$SDplot = renderPlot({
      
      plot(Nvals(), results()$sd, xlab = "N", ylab = "SD value",
           main = "Standard Deviation of Distribution")
    })
    
    
  }
)
