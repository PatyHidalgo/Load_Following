process_load <- function(gen_MM_YYYY){
  
  #filtering caiso_totals
  rtm_5min_gen_MM_YYYY <- subset(gen_MM_YYYY, gen_MM_YYYY$TAC_ZONE_NAME=="Caiso_Totals")
  
  
  # reading month, day, hour, min and adding as column
  rtm_5min_gen_MM_YYYY$year <- as.numeric(substr(rtm_5min_gen_MM_YYYY$INTERVALSTARTTIME_GMT, 0, 4))
  rtm_5min_gen_MM_YYYY$month <- as.numeric(substr(rtm_5min_gen_MM_YYYY$INTERVALSTARTTIME_GMT, 6, 7))
  rtm_5min_gen_MM_YYYY$day <- as.numeric(substr(rtm_5min_gen_MM_YYYY$INTERVALSTARTTIME_GMT, 9, 10))
  rtm_5min_gen_MM_YYYY$hour <- as.numeric(substr(rtm_5min_gen_MM_YYYY$INTERVALSTARTTIME_GMT, 12, 13))
  rtm_5min_gen_MM_YYYY$min <- as.numeric(substr(rtm_5min_gen_MM_YYYY$INTERVALSTARTTIME_GMT, 15, 16))
  
  
  
  
  # mw per hour = 12 5 min interval = sum(1/12 * 5min) = 1/12 * sum(5min)
  rtm_hourly_gen_MM_YYYY <- aggregate((1/12)*rtm_5min_gen_MM_YYYY$MW, by=list(rtm_5min_gen_MM_YYYY$year, 
                                                                              rtm_5min_gen_MM_YYYY$month, 
                                                                              rtm_5min_gen_MM_YYYY$day,
                                                                              rtm_5min_gen_MM_YYYY$hour,
                                                                              rtm_5min_gen_MM_YYYY$SCHEDULE), FUN=sum)
  names(rtm_hourly_gen_MM_YYYY)[1]<-'year'
  names(rtm_hourly_gen_MM_YYYY)[2]<-'month'
  names(rtm_hourly_gen_MM_YYYY)[3]<-'day'
  names(rtm_hourly_gen_MM_YYYY)[4]<-'hour'
  names(rtm_hourly_gen_MM_YYYY)[5]<-'SCHEDULE'
  names(rtm_hourly_gen_MM_YYYY)[6]<-'MWh'
  
  rtm_hourly_gen_MM_YYYY$timestamp <- paste(rtm_hourly_gen_MM_YYYY$year, 
                                            rtm_hourly_gen_MM_YYYY$month,
                                            rtm_hourly_gen_MM_YYYY$day,
                                            rtm_hourly_gen_MM_YYYY$hour, sep="-")
  
  # hourly gen
  rtm_hourly_MM_YYYY_gen <- subset(rtm_hourly_gen_MM_YYYY, rtm_hourly_gen_MM_YYYY$SCHEDULE=="Generation")
  length(rtm_hourly_MM_YYYY_gen$year) - 24*31
  #paste("Hello", "world", sep="-")
  
  # hourly import
  rtm_hourly_MM_YYYY_imp <- subset(rtm_hourly_gen_MM_YYYY, rtm_hourly_gen_MM_YYYY$SCHEDULE=="Import")
  length(rtm_hourly_MM_YYYY_imp$year) - 24*31
  
  # hourly export
  rtm_hourly_MM_YYYY_exp <- subset(rtm_hourly_gen_MM_YYYY, rtm_hourly_gen_MM_YYYY$SCHEDULE=="Export")
  length(rtm_hourly_MM_YYYY_exp$year) - 24*31
  
  net_load_hourly_MM_YYYY <- merge(rtm_hourly_MM_YYYY_gen, rtm_hourly_MM_YYYY_imp,
                                   by.x = 'timestamp', by.y = 'timestamp')
  
  net_load_hourly_MM_YYYY <- merge(net_load_hourly_MM_YYYY, rtm_hourly_MM_YYYY_exp,
                                   by.x = 'timestamp', by.y = 'timestamp')
  
  names(net_load_hourly_MM_YYYY)[1]<-'timestamp'
  names(net_load_hourly_MM_YYYY)[2]<-'year'
  names(net_load_hourly_MM_YYYY)[3]<-'month'
  names(net_load_hourly_MM_YYYY)[4]<-'day'
  names(net_load_hourly_MM_YYYY)[5]<-'hour'
  names(net_load_hourly_MM_YYYY)[7]<-'Generation_MWh'
  names(net_load_hourly_MM_YYYY)[13]<-'Import_MWh'
  names(net_load_hourly_MM_YYYY)[19]<-'Export_MWh'
  
  net_load_hourly_MM_YYYY$net_load_MWh <- net_load_hourly_MM_YYYY$Generation_MWh-net_load_hourly_MM_YYYY$Export_MWh+net_load_hourly_MM_YYYY$Import_MWh
  
  net_load_hourly_MM_YYYY <- subset(net_load_hourly_MM_YYYY, select=c('timestamp', 
                                                                      'year',
                                                                      'month',
                                                                      'day',
                                                                      'hour',
                                                                      'net_load_MWh',
                                                                      'Generation_MWh',
                                                                      'Import_MWh',
                                                                      'Export_MWh'))
  net_load_hourly_MM_YYYY$weekday <- weekdays(as.Date(net_load_hourly_MM_YYYY$timestamp))
  
  #net_load_hourly_MM_YYYY <- net_load_hourly_MM_YYYY[with(net_load_hourly_MM_YYYY, order(year, month, day, hour)), ]
  net_load_hourly_MM_YYYY<- net_load_hourly_MM_YYYY[order(net_load_hourly_MM_YYYY$year, 
                                net_load_hourly_MM_YYYY$month, 
                                net_load_hourly_MM_YYYY$day,
                                net_load_hourly_MM_YYYY$hour),]

  
  return(net_load_hourly_MM_YYYY)
}
