process_prices <- function(price_MM_YYYY){
  # returns hourly real time market schedule for each hour in the month loaded in price_MM_YYYY
  # It also checks that all days of the month have 24 hours
  
  # split characters for timestamp
  price_MM_YYYY$year <- as.numeric(substr(price_MM_YYYY$INTERVALSTARTTIME_GMT, 0, 4))
  price_MM_YYYY$month <- as.numeric(substr(price_MM_YYYY$INTERVALSTARTTIME_GMT, 6, 7))
  price_MM_YYYY$day <- as.numeric(substr(price_MM_YYYY$INTERVALSTARTTIME_GMT, 9, 10))
  price_MM_YYYY$hour <- as.numeric(substr(price_MM_YYYY$INTERVALSTARTTIME_GMT, 12, 13))
  # min column has only zeros, but I included it to make sure that was the case
  price_MM_YYYY$min <- as.numeric(substr(price_MM_YYYY$INTERVALSTARTTIME_GMT, 15, 16))
  
  # filtering only for real time market data
  price_MM_YYYY <- subset(price_MM_YYYY, price_MM_YYYY$ANC_TYPE=='SR')
  

  
  # new: adding timestamp and ordering
  price_MM_YYYY$timestamp <- paste(price_MM_YYYY$year, 
                                            price_MM_YYYY$month,
                                            price_MM_YYYY$day,
                                            price_MM_YYYY$hour, sep="-")
  
  price_MM_YYYY <- subset(price_MM_YYYY, select=c('timestamp', 
                                                                    'year',
                                                                    'month',
                                                                    'day',
                                                                    'hour',
                                                                    'MW'))
  names(price_MM_YYYY)[6]<-'Price_dollars_per_MWh'
  
  price_MM_YYYY<- price_MM_YYYY[order(price_MM_YYYY$year, 
                                                        price_MM_YYYY$month, 
                                                        price_MM_YYYY$day,
                                                        price_MM_YYYY$hour),]
  
  
  return(price_MM_YYYY)
}
