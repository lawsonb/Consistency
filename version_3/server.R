

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

    
    #######################################
    # functions 
    
    
    mytype_gen = function(N, type)
    {
      # returns ONE randomly generated sample of distribution I am using 
      # the distribution is specified via user input select 
      
      # Arguments: 
      # N = sample size 
      # type = type of distribution 
      
      if (type == "Standard Normal")
      {
        generate = rnorm(N)
      }
      else if (type == "Uniform")
      {
        generate = runif(N)
      }
      
      return(generate)
    }
    
    
    mycalc = function(type, weights)
    {
      # returns the value of different estimators based on the sample 
      
      # Arguments: 
      # type = type of distribution 
      # weights = vector of the size of the samples (N)
      
      # Returns: mean, variance, and sd of sample 
      #           in the form of a named list 
      
      temp = sapply(weights, function(x) mytype_gen(N = x, type = type)) 
      
      
      result = list() 
      
      result$mean = sapply(1:length(temp), function(x) mean(temp[[x]]))
      result$var = sapply(1:length(temp), function(x) var(temp[[x]]))
      result$sd = sqrt(result$var)
      
      return(result) 
    }
    
    
    #######################################
    
    # operator code 
    
    # x = how many estimated statistics user wants for each N 

    Nvals = reactive({
      x = input$xruns
      numweights = c(rep(10, x), rep(100, x), rep(250, x), 
                rep(500, x), rep(1000, x), rep(2000, x))
      
      return(numweights)
      
    })

    
    
    results = reactive({
      # a dataset containing #increments worth of samples 
      # each sample has N data points with selected distribution 
      
      fin = mycalc(type = input$select, weights = Nvals())
      
      return(fin)
      
    })
    
    
    ###########################
    # graphs 
    
    
    output$meanplot = renderPlot({
      
      plot(Nvals(), results()$mean, xlab = "N", ylab = "mean value",
           main = "Mean of Distribution")
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