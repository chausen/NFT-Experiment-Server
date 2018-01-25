library(RJSONIO)

timestamp <- "2016-12-07T13:30:25Z"
basereq <- "http://45.32.220.103:443/log/"
fullreq <- paste0(basereq, timestamp, "/" )

logs <- fromJSON(fullreq)

print(logs)
