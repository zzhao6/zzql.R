# input:
# double: option quotes
# bool: OTM or not
# int: time to expiration in minutes
# Strike prices
# underlying prices

library(quantmod)       # get vix data from yahoo
library(lubridate)      # date calculation

setwd("C:\\Users\\zzhao\\GitRepos\\zzql.R")
source("get_option_chain.R")        # option chain from yahoo


filterCalls <- function(optdf, underlying_last, rf){
    if(is.null(optdf$Strike) | is.null(optdf$Bid) | is.null(optdf$Ask))
        stop("Option data frame missing column: Strike, Bid or Ask!")
    # extract OTM option
    optdf <- optdf[optdf$Strike > underlying_last * (1+rf), ]
    # filter by bid prices
    # bids after 2 consecutive 0s are discarded
    idx <- nrow(optdf)
    for(i in 1:(nrow(optdf)-1)){
        if(all(optdf$Bid[i:(i+1)] == 0))
        {
            idx <- i-1
            if(idx==0)  stop("idx = 0!")
            break
        }
    }
    optdf <- optdf[1:idx,]
    # remove 0 bids before returning
    return(optdf[which(optdf$Bid != 0), ])
}

filterPuts <- function(optdf, underlying_last, rf){
    if(is.null(optdf$Strike) | is.null(optdf$Bid) | is.null(optdf$Ask))
        stop("Option data frame missing column: Strike, Bid or Ask!")
    # extract OTM option
    optdf <- optdf[optdf$Strike <= underlying_last * (1+rf), ]
    # filter by bid prices
    # bids after 2 consecutive 0s are discarded
    idx <- 1
    for(i in nrow(optdf):2){
        if(all(optdf$Bid[i:(i-1)] == 0))
        {
            idx <- i+1
            if(idx==0)  stop("idx = 0!")
            break
        }
    }
    optdf <- optdf[idx:nrow(optdf),]
    # remove 0 bids before returning
    return(optdf[which(optdf$Bid != 0), ])
}