library(RJSONIO)
library(parsedate)

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
  print(logsDF)
  }
}

