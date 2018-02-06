library(dplyr)
library(data.table)
library(ggplot2)
library(shiny)
library(RJSONIO)
library(parsedate)
library(magrittr)

## Data Retrieval

## Shiny UI 

ui <- shinyServer(fluidPage(
  plotOutput("first_column")
))

server <- shinyServer(function(input, output, session){
  
  # Get new data
  get_new_data <- function(timestamp) {
    
    basereq <- "http://45.32.220.103:443/log/"
    fullreq <- paste0(basereq, timestamp, "/" )
    logs <- fromJSON(fullreq)  
    
    if (length(logs) == 0 ) {
    
    }
    
    else {
      logsDF <- t(as.data.frame(unlist(logs)))
      return(logsDF)
    }
    
  }

  # Initialize my_data
  lastTimestamp <<- "2018-02-06T02:05:26+00:00" #format_iso_8601(Sys.time())
  my_data <<- get_new_data(lastTimestamp)

  # Function to update my_data
  update_data <- function(){
    my_data <<- rbind(get_new_data(lastTimestamp), my_data)
    lastTimestamp <<- format_iso_8601(Sys.time())
  }

  # Plot the 30 most recent values
  output$first_column <- renderPlot({
    print("Render")
    invalidateLater(30000, session)
    update_data()
    print(my_data)
    plot(my_data[,4], ylim=c(23,24), las=1, type="l")
  })
})

shinyApp(ui=ui,server=server)
