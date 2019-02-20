
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Vapor pressure of mercury"),
  sidebarLayout(
    sidebarPanel(
      helpText("Select the transition temperature:"),
      sliderInput("boundary", "Temperature: ",min = min(pressure$temperature), max = max(pressure$temperature)-1, value = 100),
      checkboxInput("ShowLoglogPlot", "Show/hide log-log plot", value = TRUE, width = NULL),
      checkboxInput("ShowFitParams", "Show/hide fit parameters", value = TRUE, width = NULL)),
    mainPanel(
      p("This application shows a dynamic fit of the vapour pressure of mercury as function of temperature. 
        The plot below shows the pressure as function of temperature for the pressure dataset within R. 
        The pressure can be approximated by a linear function for low temperatures, however this linear approximation breaks down as the temperature increases.
        Using the slider on the left, the boundary value of the linear approximation can be adjusted (shown by the blue vertical line). 
        "),
      p("The right part of the dataset is approximated by an exponential function a*T^n. "),
      plotOutput("presPlot"),
      textOutput("ParamsModel1"),
      textOutput("ParamsModel2"),
      plotOutput("LogPlot")
    )
  )
))
