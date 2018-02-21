library(dplyr)
library(data.table)
library(ggplot2)
library(shiny)
library(RJSONIO)
library(parsedate)
library(magrittr)
library(lubridate)
library(scales)
library(rJava)
library(mailR)

Sys.setenv(TZ = "UTC")

## Data Retrieval

## Shiny UI 

ui <- shinyServer(fluidPage(
  tabsetPanel(
    tabPanel("rH", plotOutput("rH")),
    tabPanel("pH", plotOutput("pH")),
    tabPanel("aTemp", plotOutput("aTemp")),
    tabPanel("wTemp", plotOutput("wTemp")),
    tabPanel("ec", plotOutput("ec"))
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
  lastTimestamp <<- now() - minutes(10)
  my_data <<- get_new_data(lastTimestamp)
  my_data <<- as.data.frame(lapply(split(as.list(my_data), names(my_data)), unlist))
  colnames(my_data)[1] <<- "_id"
  View(my_data)
  lastTimestamp <<- now()
  
  # Function to update my_data
  update_data <- function(){
    newdata <- get_new_data(lastTimestamp)
      if (!is.null(newdata)) {
        my_data <<- rbind(my_data, newdata)
        lastTimestamp <<- now()
      }
  }
  
  sensors <- reactive({
    invalidateLater(5000, session)
    update_data()
    my_data
  })
  
  # Line plot of values
  output$rH <- renderPlot({
    # Line plot with multiple groups
    ggplot(data=sensors(), aes(x=timestamp, 
                             y=as.numeric(levels(sensors()$rH))[sensors()$rH], 
                             group = 1)) +
       ylab('Relative Humidity (rH)') + xlab("Timepoint") +
         geom_line(linetype="solid", color="skyblue3", size=2) +
         geom_point(color="slategray2", size=3) +
         theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })

  
  output$pH <- renderPlot({
      # Line plot with multiple groups
      ggplot(data=sensors(), aes(x=timestamp, 
                               y=as.numeric(levels(sensors()$pH))[sensors()$pH], 
                               group = 1)) +
         ylab('pH') + xlab("Timepoint") +
         geom_line(linetype="solid", color="skyblue3", size=2) +
         geom_point(color="slategray2", size=3) +
         theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })
  
    output$aTemp <- renderPlot({
      # Line plot with multiple groups
      ggplot(data=sensors(), aes(x=timestamp, 
                               y=as.numeric(levels(sensors()$aTemp))[sensors()$aTemp], 
                               group = 1)) +
         ylab('aTemp') + xlab("Timepoint") +
         geom_line(linetype="solid", color="skyblue3", size=2) +
         geom_point(color="slategray2", size=3) +
         theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })
    
      output$wTemp <- renderPlot({
      # Line plot with multiple groups
      ggplot(data=sensors(), aes(x=timestamp, 
                               y=as.numeric(levels(sensors()$wTemp))[sensors()$wTemp], 
                               group = 1)) +
         ylab('wTemp') + xlab("Timepoint") +
         geom_line(linetype="solid", color="skyblue3", size=2) +
         geom_point(color="slategray2", size=3) +
         theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })
      
        output$ec <- renderPlot({
      # Line plot with multiple groups
      ggplot(data=sensors(), aes(x=timestamp,
                               y=as.numeric(levels(sensors()$ec))[sensors()$ec],
                               group = 1)) +
         ylab('ec') + xlab("Timepoint") +
         geom_line(linetype="solid", color="skyblue3", size=2) +
         geom_point(color="slategray2", size=3) +
         theme(axis.text.x = element_text(angle = 90, hjust = 1))
  })
})

shinyApp(ui=ui,server=server)
