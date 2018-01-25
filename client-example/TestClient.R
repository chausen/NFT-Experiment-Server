library(RJSONIO)
library(parsedate)

lastTimestamp <- format_iso_8601(Sys.time())

get.new.logs <- function(timestamp) {
  basereq <- "http://45.32.220.103:443/log/"
  fullreq <- paste0(basereq, timestamp, "/" )
  
  logs <- fromJSON(fullreq)  
}

while (TRUE) {
  logs <- get.new.logs(lastTimestamp)
  lastTimestamp <- format_iso_8601(Sys.time())
  print(logs)
}

