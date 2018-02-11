library(dplyr)
library(data.table)
library(ggplot2)
library(shiny)
library(RJSONIO)
library(parsedate)
library(magrittr)
library(lubridate)
library(scales)

Sys.setenv(TZ = "UTC")

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
    
    if (length(logs) != 0 ) {
    
      #print(names(sapply(logs, names)))
      logsDF <- as.data.frame(t((unlist(logs))))
      return(logsDF)
    }
  }


  # Initialize my_data
  lastTimestamp <<- now() - minutes(3)
  my_data <<- get_new_data(lastTimestamp)
  my_data <<- as.data.frame(lapply(split(as.list(my_data), names(my_data)), unlist))
  colnames(my_data)[1] <<- "_id"
  View(my_data)
  lastTimestamp <<- now()
  
  # Function to update my_data
  update_data <- function(){
    newdata <- get_new_data(lastTimestamp)
      if (!is.null(newdata)) {
        my_data <<- rbind(newdata, my_data)
        lastTimestamp <<- now()
      }
  }
  
  print(mode(my_data$timestamp)) ; print(class(my_data$timestamp)) ; print(typeof(my_data$timestamp))
  print(as.POSIXct(my_data$timestamp,format ="%x"))
  
  # Line plot of values
  output$first_column <- renderPlot({
    #print("Render")
    invalidateLater(5000, session)
    update_data()
    # Line plot with multiple groups
    ggplot(data=my_data, aes(x=timestamp, 
                             y=as.numeric(levels(my_data$rH))[my_data$rH], 
                             group = 1)) +
       ylab('Relative Humidity (rH)') + xlab("Timepoint") +
       geom_line(linetype="dashed", color="blue", size=1.2) +
       geom_point(color="red", size=3) +
       theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
  })
})

shinyApp(ui=ui,server=server)
