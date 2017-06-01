filter_and_check <- function(wind_solar_MM_YYYY){
  # returns hourly real time market schedule for each hour in the month loaded in wind_solar_MM_YYYY
  # It also checks that all days of the month have 24 hours
  
  # split characters for timestamp
  wind_solar_MM_YYYY$year <- as.numeric(substr(wind_solar_MM_YYYY$INTERVALSTARTTIME_GMT, 0, 4))
  wind_solar_MM_YYYY$month <- as.numeric(substr(wind_solar_MM_YYYY$INTERVALSTARTTIME_GMT, 6, 7))
  wind_solar_MM_YYYY$day <- as.numeric(substr(wind_solar_MM_YYYY$INTERVALSTARTTIME_GMT, 9, 10))
  wind_solar_MM_YYYY$hour <- as.numeric(substr(wind_solar_MM_YYYY$INTERVALSTARTTIME_GMT, 12, 13))
  # min column has only zeros, but I included it to make sure that was the case
  wind_solar_MM_YYYY$min <- as.numeric(substr(wind_solar_MM_YYYY$INTERVALSTARTTIME_GMT, 15, 16))
  
  # filtering only for real time market data
  rtm_wind_solar_MM_YYYY <- subset(wind_solar_MM_YYYY, wind_solar_MM_YYYY$DATA_ITEM=='RTM_SCHEDULE')
  
  # creating list of day in the month
  days <- aggregate(rtm_wind_solar_MM_YYYY$day, by=list(rtm_wind_solar_MM_YYYY$day), FUN=length)
  names(days)[1]<-'day'
  names(days)[2]<-'num_of_hours'
  
  #checking there are 24 hours in each day
  for (d in 1:length(days$day))
  { if(days$num_of_hours[d] != 24) 
  {cat("Warning! only ",days$num_of_hours[d] , " hours in day: ", days$day[d], "of month", wind_solar_MM_YYYY$month[1], "\n") }
  }
  
  # new: adding timestamp and ordering
  rtm_wind_solar_MM_YYYY$timestamp <- paste(rtm_wind_solar_MM_YYYY$year, 
                                            rtm_wind_solar_MM_YYYY$month,
                                            rtm_wind_solar_MM_YYYY$day,
                                            rtm_wind_solar_MM_YYYY$hour, sep="-")
  
  rtm_wind_solar_MM_YYYY <- subset(rtm_wind_solar_MM_YYYY, select=c('timestamp', 
                                                                      'year',
                                                                      'month',
                                                                      'day',
                                                                      'hour',
                                                                      'VALUE'))
  names(rtm_wind_solar_MM_YYYY)[6]<-'MWh'
  
  #rtm_wind_solar_MM_YYYY <- rtm_wind_solar_MM_YYYY[with(rtm_wind_solar_MM_YYYY, order(year, month, day, hour)), ]
  rtm_wind_solar_MM_YYYY<- rtm_wind_solar_MM_YYYY[order(rtm_wind_solar_MM_YYYY$year, 
                                                        rtm_wind_solar_MM_YYYY$month, 
                                                        rtm_wind_solar_MM_YYYY$day,
                                                        rtm_wind_solar_MM_YYYY$hour),]
  
  rtm_wind_solar_MM_YYYY$wind_solar_ramp_t_MWh <- rtm_wind_solar_MM_YYYY$MWh - shift(rtm_wind_solar_MM_YYYY$MWh, type="lag", fill=0)
  rtm_wind_solar_MM_YYYY$wind_solar_ramp_t_minus_1_MWh <- shift(rtm_wind_solar_MM_YYYY$wind_solar_ramp_t_MWh, type="lag", fill=0)
  rtm_wind_solar_MM_YYYY$wind_solar_ramp_t_minus_2_MWh <- shift(rtm_wind_solar_MM_YYYY$wind_solar_ramp_t_minus_1_MWh, type="lag", fill=0)
  rtm_wind_solar_MM_YYYY$wind_solar_ramp_t_minus_3_MWh <- shift(rtm_wind_solar_MM_YYYY$wind_solar_ramp_t_minus_2_MWh, type="lag", fill=0)
  
  
  
  return(rtm_wind_solar_MM_YYYY)
}
