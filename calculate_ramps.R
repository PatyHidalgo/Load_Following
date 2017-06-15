calculate_ramps <- function(hourly_MM_YYYY){
 
  #calculating load ramps
  hourly_MM_YYYY$net_load_ramp_t_MWh <- hourly_MM_YYYY$net_load_MWh - shift(hourly_MM_YYYY$net_load_MWh, type="lag", fill=0)
  hourly_MM_YYYY$net_load_ramp_t_minus_1_MWh <- shift(hourly_MM_YYYY$net_load_ramp_t_MWh, type="lag", fill=0)
  hourly_MM_YYYY$net_load_ramp_t_minus_2_MWh <- shift(hourly_MM_YYYY$net_load_ramp_t_minus_1_MWh, type="lag", fill=0)
  hourly_MM_YYYY$net_load_ramp_t_minus_3_MWh <- shift(hourly_MM_YYYY$net_load_ramp_t_minus_2_MWh, type="lag", fill=0) 
  
  #caluclating wind and solar ramps
  hourly_MM_YYYY$wind_solar_ramp_t_MWh <- hourly_MM_YYYY$Wind_Solar_MWh - shift(hourly_MM_YYYY$Wind_Solar_MWh, type="lag", fill=0)
  hourly_MM_YYYY$wind_solar_ramp_t_minus_1_MWh <- shift(hourly_MM_YYYY$wind_solar_ramp_t_MWh, type="lag", fill=0)
  hourly_MM_YYYY$wind_solar_ramp_t_minus_2_MWh <- shift(hourly_MM_YYYY$wind_solar_ramp_t_minus_1_MWh, type="lag", fill=0)
  hourly_MM_YYYY$wind_solar_ramp_t_minus_3_MWh <- shift(hourly_MM_YYYY$wind_solar_ramp_t_minus_2_MWh, type="lag", fill=0)
  
  #including t-1, etc values for load and wind+solar
  hourly_MM_YYYY$net_load_t_minus_1_MWh <- shift(hourly_MM_YYYY$net_load_MWh, type="lag", fill=0)
  hourly_MM_YYYY$net_load_t_minus_2_MWh <- shift(hourly_MM_YYYY$net_load_t_minus_1_MWh, type="lag", fill=0)
  hourly_MM_YYYY$net_load_t_minus_3_MWh <- shift(hourly_MM_YYYY$net_load_t_minus_2_MWh, type="lag", fill=0)
  
  hourly_MM_YYYY$wind_solar_t_minus_1_MWh <- shift(hourly_MM_YYYY$Wind_Solar_MWh, type="lag", fill=0)
  hourly_MM_YYYY$wind_solar_t_minus_2_MWh <- shift(hourly_MM_YYYY$wind_solar_t_minus_1_MWh, type="lag", fill=0)
  hourly_MM_YYYY$wind_solar_t_minus_3_MWh <- shift(hourly_MM_YYYY$wind_solar_t_minus_2_MWh, type="lag", fill=0)

  return(hourly_MM_YYYY)

}