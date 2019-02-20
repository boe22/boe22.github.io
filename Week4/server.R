
library(shiny)

# Add 1 to fix problems with zeros
pressure[,"pressureLogCorrected"] <- pressure[,"pressure"]+1
pressure[,"temperatureLogCorrected"] <- pressure[,"temperature"]+1

shinyServer(function(input, output) {
  
  # Fit left curve
  Model1 <- reactive({
    lm(pressure ~ temperature, data = pressure[pressure$temperature<=input$boundary,])
  })
  # Get fit values
  Model1Pred <- reactive({
    Pred <- data.frame(temperature = c(pressure[pressure$temperature<=input$boundary,'temperature'],input$boundary))
    Pred[,'pressure'] <- predict(Model1(), newdata = Pred)
    Pred
  })
  # Fit right curve
  Model2 <- reactive({
    lm(log(pressure) ~ log(temperature), data = pressure[pressure$temperature>input$boundary,])
  })
  # Get Fit values
  Model2Pred <- reactive({
    Pred <- data.frame(temperature = c(input$boundary,pressure[pressure$temperature>input$boundary,'temperature']))
    Pred[,'pressure'] <- Pred[,'temperature']^Model2()$coefficients[2]*exp(Model2()$coefficients[1])
    Pred
  })
  
  output$presPlot <- renderPlot({
    plot(pressure$temperature, pressure$pressure, xlab = "Temperature (deg C)", ylab = "Pressure (mm of Hg)", main='Normal plot')
    lines(Model1Pred()$temperature, Model1Pred()$pressure, col = "red")
    lines(Model2Pred()$temperature, Model2Pred()$pressure, col = "green")
    abline(v=input$boundary, col="blue")
  })
  
  output$ParamsModel1 <- renderText({ 
    if(input$ShowFitParams == TRUE){
      paste0("Left fit formula (red): P=", sprintf(fmt="%.2eT+%.2e",Model1()$coefficients[2],Model1()$coefficients[1]))
    }
  })
  
  output$ParamsModel2 <- renderText({ 
    if(input$ShowFitParams == TRUE){
      paste0("Right fit formula (green): P=", sprintf(fmt="T^%.2e*%.2e",Model2()$coefficients[2],exp(Model2()$coefficients[1])))
    }
  })
  
  output$LogPlot <- renderPlot({
    if(input$ShowLoglogPlot == TRUE){
      # draw the log-log plot
      plot(pressure$temperatureLogCorrected, pressure$pressureLogCorrected, log = "xy", xlab = "log(Temperature)", ylab = "log(Pressure)", main='Log-log plot')
      abline(v=input$boundary, col="blue")
      segments(min(pressure$temperatureLogCorrected),1,input$boundary,1,col="red")
      lines(Model2Pred()$temperature, Model2Pred()$pressure, col = "green")
    }
  })
  
})
