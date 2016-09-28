rm(list = ls())
source("vix_formula.R")

symbol <- "GOOG"

optdf <- getOptionChain(symbol)
call <- optdf$calls
put <- optdf$puts
last <- getQuote(symbol)$Last
rf <- 0.0015

print(filterCalls(call, last, rf))
print(filterPuts(put, last, rf))

sample(c(1, 0))