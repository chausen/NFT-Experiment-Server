library(dplyr)
library(data.table)
library(ggplot2)
library(shiny)
library(RJSONIO)
library(parsedate)

## Data Retrieval



NodeData <- function() {
  
  lastTimestamp <- format_iso_8601(Sys.time())
  
  get.new.logs <- function(timestamp) {
    basereq <- "http://45.32.220.103:443/log/"
    fullreq <- paste0(basereq, timestamp, "/" )
    logs <- fromJSON(fullreq)  
  }
  
  while (T) {
  
  Sys.sleep(20)  
      
  logs <- get.new.logs(lastTimestamp)
  
  if (length(logs) == 0 ) {
    
    
  }
    else {
      
    lastTimestamp <- format_iso_8601(Sys.time())
    logsDF <- as.data.frame(unlist(logs))
    return(logsDF)
    }
  }

}

## Shiny UI 

# Define UI for app that draws a histogram ----
ui <- fluidPage(

  # App title ----
  titlePanel("Hello Shiny!"),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Line graph ----
      plotOutput(outputId = "distPlot")

    )
  )

## Shiny Server

server = function(input = logsDF, output, session) {
    autoInvalidate <- reactiveTimer(3000, session)
    output$distPlot <- renderPlot({
      autoInvalidate()
      # generate an rnorm distribution and plot it
      dist <- input$pH
      plot(dist)
    })

  }

### RUN THE APP 

shinyApp(ui = ui, server = server)
