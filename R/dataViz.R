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
  tabsetPanel(
    type = "tabs",
    tabPanel("Relative Humidity", plotOutput("rH")),
    tabPanel("pH", plotOutput("pH"))
    )
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
  my_data <<- as.data.frame(get_new_data(lastTimestamp))
  lastTimestamp <<- now()
  
  # Function to update my_data
  update_data <- function(){
    newdata <- get_new_data(lastTimestamp)
    print(newdata)
      if (!is.null(newdata)) {
        my_data <<- rbind(newdata, my_data)
        lastTimestamp <<- now()
      }
    print(my_data)
    return(my_data)
  }
  
  # TRYING TO FIGURE OUT TIMESTAMPS
  #print(mode(my_data$timestamp)) ; print(class(my_data$timestamp)) ; print(typeof(my_data$timestamp))
  #print(as.POSIXct(my_data$timestamp,format ="%x"))
  
  # Line plot of values
  
  observe({
     invalidateLater(5000, session)
     sensors <<- update_data()
  })
  

  output$rH <- renderPlot({
    # Line plot of relative humidity
    ggplot(data=sensors, aes(x=timestamp, 
                             y=as.numeric(levels(sensors$rH))[sensors$rH], 
                             group = 1)) +
       ylab('Relative Humidity (rH)') + xlab("Timepoint") +
       geom_line(linetype="solid", color="skyblue2", size=2) +
       geom_point(color="slategray4", size=2) +
       theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })
  
  output$pH <- renderPlot({
    # Line plot of relative humidity
    ggplot(data=sensors, aes(x=timestamp,
                             y=as.numeric(levels(sensors$pH))[sensors$pH],
                             group = 1)) +
       ylab('pH') + xlab("Timepoint") +
       geom_line(linetype="solid", color="skyblue2", size=2) +
       geom_point(color="slategray4", size=2) +
       theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })
})

shinyApp(ui=ui,server=server)
