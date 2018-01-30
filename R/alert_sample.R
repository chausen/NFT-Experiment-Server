library(RJSONIO)
library(parsedate)
library(mailR)

sender <- ""
password <- ""
recipient <- ""

send.mail(from <- sender,
          to <- recipient,
          subject <- "Alert",
          msg <- "Test",
          smtp = list(host.name = "smtp.gmail.com", port = 465,
                      user.name = sender,
                      passwd = password, ssl = TRUE),
          authenticate = TRUE,
          send = TRUE)

