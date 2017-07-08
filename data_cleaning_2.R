data_cleaning_2 <- function(hourly_YYYY){
  # removes from the dataset the most extreme 3%
  
  cap <- quantile(abs(hourly_YYYY$duck_ramp_t_MWh), .97)
  
  # loop of dismissal
  for (i in 1:6500) { #7199
    if(abs(hourly_YYYY[i, "duck_ramp_t_MWh"]) >= cap) {
      hourly_YYYY <- hourly_YYYY[-c(i, i+1, i+2, i+3, i+4, i+5), ]
    }
    else {}
  }
  
  return(hourly_YYYY)
  
}