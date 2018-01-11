library(RJSONIO)

timestamp <- "2016-12-07T13:30:25Z"
basereq <- "http://localhost:8080/log/"
fullreq <- paste0(basereq, timestamp, "/" )

logs <- fromJSON(fullreq)

print(logs)

logs

