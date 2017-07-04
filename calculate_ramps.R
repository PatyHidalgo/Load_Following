calculate_ramps <- function(hourly_MM_YYYY){
 
  #calculating duck curve (for t only because t-1...t-6 are linear combinations of net laod and WindSolar)
  hourly_MM_YYYY$duck_t_MWh <- hourly_MM_YYYY$net_load_MWh - hourly_MM_YYYY$Wind_Solar_MWh
  
  #calculating duck ramps
  hourly_MM_YYYY$duck_ramp_t_MWh <- hourly_MM_YYYY$duck_t_MWh - shift(hourly_MM_YYYY$duck_t_MWh, type="lag", fill=0)
  hourly_MM_YYYY$duck_ramp_t_minus_1_MWh <- shift(hourly_MM_YYYY$duck_ramp_t_MWh, type="lag", fill=0)
  hourly_MM_YYYY$duck_ramp_t_minus_2_MWh <- shift(hourly_MM_YYYY$duck_ramp_t_minus_1_MWh, type="lag", fill=0)
  hourly_MM_YYYY$duck_ramp_t_minus_3_MWh <- shift(hourly_MM_YYYY$duck_ramp_t_minus_3_MWh, type="lag", fill=0) 
  
  #caluclating wind and solar ramps
  hourly_MM_YYYY$wind_solar_ramp_t_MWh <- hourly_MM_YYYY$Wind_Solar_MWh - shift(hourly_MM_YYYY$Wind_Solar_MWh, type="lag", fill=0)
  hourly_MM_YYYY$wind_solar_ramp_t_minus_1_MWh <- shift(hourly_MM_YYYY$wind_solar_ramp_t_MWh, type="lag", fill=0)
  hourly_MM_YYYY$wind_solar_ramp_t_minus_2_MWh <- shift(hourly_MM_YYYY$wind_solar_ramp_t_minus_1_MWh, type="lag", fill=0)
  hourly_MM_YYYY$wind_solar_ramp_t_minus_3_MWh <- shift(hourly_MM_YYYY$wind_solar_ramp_t_minus_2_MWh, type="lag", fill=0)
  
  #including t-1, etc values for load and wind+solar
  hourly_MM_YYYY$net_load_t_minus_1_MWh <- shift(hourly_MM_YYYY$net_load_MWh, type="lag", fill=0)
  hourly_MM_YYYY$net_load_t_minus_2_MWh <- shift(hourly_MM_YYYY$net_load_t_minus_1_MWh, type="lag", fill=0)
  hourly_MM_YYYY$net_load_t_minus_3_MWh <- shift(hourly_MM_YYYY$net_load_t_minus_2_MWh, type="lag", fill=0)
  hourly_MM_YYYY$net_load_t_minus_4_MWh <- shift(hourly_MM_YYYY$net_load_t_minus_3_MWh, type="lag", fill=0)
  hourly_MM_YYYY$net_load_t_minus_5_MWh <- shift(hourly_MM_YYYY$net_load_t_minus_4_MWh, type="lag", fill=0)
  hourly_MM_YYYY$net_load_t_minus_6_MWh <- shift(hourly_MM_YYYY$net_load_t_minus_5_MWh, type="lag", fill=0)
  
  hourly_MM_YYYY$wind_solar_t_minus_1_MWh <- shift(hourly_MM_YYYY$Wind_Solar_MWh, type="lag", fill=0)
  hourly_MM_YYYY$wind_solar_t_minus_2_MWh <- shift(hourly_MM_YYYY$wind_solar_t_minus_1_MWh, type="lag", fill=0)
  hourly_MM_YYYY$wind_solar_t_minus_3_MWh <- shift(hourly_MM_YYYY$wind_solar_t_minus_2_MWh, type="lag", fill=0)
  hourly_MM_YYYY$wind_solar_t_minus_4_MWh <- shift(hourly_MM_YYYY$wind_solar_t_minus_3_MWh, type="lag", fill=0)
  hourly_MM_YYYY$wind_solar_t_minus_5_MWh <- shift(hourly_MM_YYYY$wind_solar_t_minus_4_MWh, type="lag", fill=0)
  hourly_MM_YYYY$wind_solar_t_minus_6_MWh <- shift(hourly_MM_YYYY$wind_solar_t_minus_5_MWh, type="lag", fill=0)

  return(hourly_MM_YYYY)

}