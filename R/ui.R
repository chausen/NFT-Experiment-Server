library(shiny)
library(leaflet)

shinyUI(fluidPage(
        column(width=7,
                 plotOutput("timeseries_all",height = "500px"))))
            

