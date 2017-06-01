# Paty, May 2017.
# Reserve's project (Claire Tomlin and Duncan Callaway)
#
# Description: use machine learning (regression) to identify potential features that can predict ramping (reserves) needs
# Potential features: amount of wind and solar in each hour of day, day of month, subarea of transmission network, load,
# previous three hours of wind and solar 
# Training set: half? of days available in 2016, Test prediction of ramp (reserves) needed
# Data: real time dispatch per hour for 2016 http://oasis.caiso.com

rm(list = ls())
#setwd("C:/CAISO_OASIS/wind_solar_relational")
setwd("/Users/paty/Documents/Research/Load_following/CAISO_OASIS")
library("ggplot2")
library(data.table)

source("filter_and_check.R")
source("process_load.R")

# wind+solar data import
wind_solar_01_2016 <- read.csv("./wind_solar_relational/01_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
wind_solar_02_2016 <- read.csv("./wind_solar_relational/02_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
wind_solar_03_2016 <- read.csv("./wind_solar_relational/03_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
wind_solar_04_2016 <- read.csv("./wind_solar_relational/04_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
wind_solar_05_2016 <- read.csv("./wind_solar_relational/05_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
wind_solar_06_2016 <- read.csv("./wind_solar_relational/06_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
wind_solar_07_2016 <- read.csv("./wind_solar_relational/07_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
wind_solar_08_2016 <- read.csv("./wind_solar_relational/08_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
wind_solar_09_2016 <- read.csv("./wind_solar_relational/09_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
wind_solar_10_2016 <- read.csv("./wind_solar_relational/10_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
wind_solar_11_2016 <- read.csv("./wind_solar_relational/11_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
wind_solar_12_2016 <- read.csv("./wind_solar_relational/12_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 

# wind+solar data processing
rtm_wind_solar_01_2016 <- filter_and_check(wind_solar_01_2016)
rtm_wind_solar_02_2016 <- filter_and_check(wind_solar_02_2016)
rtm_wind_solar_03_2016 <- filter_and_check(wind_solar_03_2016)
rtm_wind_solar_04_2016 <- filter_and_check(wind_solar_04_2016)
rtm_wind_solar_05_2016 <- filter_and_check(wind_solar_05_2016)
rtm_wind_solar_06_2016 <- filter_and_check(wind_solar_06_2016)
rtm_wind_solar_07_2016 <- filter_and_check(wind_solar_07_2016)
rtm_wind_solar_08_2016 <- filter_and_check(wind_solar_08_2016)
rtm_wind_solar_09_2016 <- filter_and_check(wind_solar_09_2016)
rtm_wind_solar_10_2016 <- filter_and_check(wind_solar_10_2016)
rtm_wind_solar_11_2016 <- filter_and_check(wind_solar_11_2016)
rtm_wind_solar_12_2016 <- filter_and_check(wind_solar_12_2016)

# load data import
gen_01_2016 <- read.csv("./generation/01_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
gen_02_2016 <- read.csv("./generation/02_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
gen_03_2016 <- read.csv("./generation/03_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
gen_04_2016 <- read.csv("./generation/04_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
gen_05_2016 <- read.csv("./generation/05_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
gen_06_2016 <- read.csv("./generation/06_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
gen_07_2016 <- read.csv("./generation/07_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
gen_08_2016 <- read.csv("./generation/08_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
gen_09_2016 <- read.csv("./generation/09_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
gen_10_2016 <- read.csv("./generation/10_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
gen_11_2016 <- read.csv("./generation/11_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 
gen_12_2016 <- read.csv("./generation/12_2016.csv",stringsAsFactors=F, header = T , fill = TRUE, sep = ",", quote = "\"", dec = ".") 

# process load
net_load_hourly_01_2016 <- process_load(gen_01_2016)
net_load_hourly_02_2016 <- process_load(gen_02_2016)
net_load_hourly_03_2016 <- process_load(gen_03_2016)
net_load_hourly_04_2016 <- process_load(gen_04_2016)
net_load_hourly_05_2016 <- process_load(gen_05_2016)
net_load_hourly_06_2016 <- process_load(gen_06_2016)
net_load_hourly_07_2016 <- process_load(gen_07_2016)
net_load_hourly_08_2016 <- process_load(gen_08_2016)
net_load_hourly_09_2016 <- process_load(gen_09_2016)
net_load_hourly_10_2016 <- process_load(gen_10_2016)
net_load_hourly_11_2016 <- process_load(gen_11_2016)
net_load_hourly_12_2016 <- process_load(gen_12_2016)

# merge load and wind+solar data
hourly_01_2016 <- merge(net_load_hourly_01_2016, rtm_wind_solar_01_2016, by=c('year', 'month', 'day', 'hour'))
hourly_02_2016 <- merge(net_load_hourly_02_2016, rtm_wind_solar_02_2016, by=c('year', 'month', 'day', 'hour'))
hourly_03_2016 <- merge(net_load_hourly_03_2016, rtm_wind_solar_03_2016, by=c('year', 'month', 'day', 'hour'))
hourly_04_2016 <- merge(net_load_hourly_04_2016, rtm_wind_solar_04_2016, by=c('year', 'month', 'day', 'hour'))
hourly_05_2016 <- merge(net_load_hourly_05_2016, rtm_wind_solar_05_2016, by=c('year', 'month', 'day', 'hour'))
hourly_06_2016 <- merge(net_load_hourly_06_2016, rtm_wind_solar_06_2016, by=c('year', 'month', 'day', 'hour'))
hourly_07_2016 <- merge(net_load_hourly_07_2016, rtm_wind_solar_07_2016, by=c('year', 'month', 'day', 'hour'))
hourly_08_2016 <- merge(net_load_hourly_08_2016, rtm_wind_solar_08_2016, by=c('year', 'month', 'day', 'hour'))
hourly_09_2016 <- merge(net_load_hourly_09_2016, rtm_wind_solar_09_2016, by=c('year', 'month', 'day', 'hour'))
hourly_10_2016 <- merge(net_load_hourly_10_2016, rtm_wind_solar_10_2016, by=c('year', 'month', 'day', 'hour'))
hourly_11_2016 <- merge(net_load_hourly_11_2016, rtm_wind_solar_11_2016, by=c('year', 'month', 'day', 'hour'))
hourly_12_2016 <- merge(net_load_hourly_12_2016, rtm_wind_solar_12_2016, by=c('year', 'month', 'day', 'hour'))

lm(formula = net_load_ramp_t_MWh ~ weekday 
   + net_load_MWh 
   + net_load_ramp_t_minus_1_MWh
   + net_load_ramp_t_minus_2_MWh
   + net_load_ramp_t_minus_3_MWh
   + MWh
   + wind_solar_ramp_t_MWh
   + wind_solar_ramp_t_minus_1_MWh
   + wind_solar_ramp_t_minus_2_MWh
   + wind_solar_ramp_t_minus_3_MWh,
   data = hourly_01_2016
   )

# picking an arbitrary training set
training_01_2016 <- subset(hourly_01_2016, day==4 | day==5 | day==6 | day==7 | day==8 | day==9 | day==10)
test_set_01_2016 <- subset(hourly_01_2016, day!=4 & day!=5 & day!=6 & day!=7 & day!=8 & day!=9 & day!=10)

# OLS without weekday variable
ols_01_2016 <- lm(formula = net_load_ramp_t_MWh ~ net_load_MWh 
   + net_load_ramp_t_minus_1_MWh
   + net_load_ramp_t_minus_2_MWh
   + net_load_ramp_t_minus_3_MWh
   + MWh
   + wind_solar_ramp_t_MWh
   + wind_solar_ramp_t_minus_1_MWh
   + wind_solar_ramp_t_minus_2_MWh
   + wind_solar_ramp_t_minus_3_MWh,
   data = training_01_2016
)
summary(ols_01_2016)

# OLS less variables so they are more meaningful
#ols_01_2016 <- lm(formula = net_load_ramp_t_MWh ~ net_load_ramp_t_minus_2_MWh
#                  + wind_solar_ramp_t_minus_2_MWh
#                  + wind_solar_ramp_t_minus_3_MWh,
#                  data = training_01_2016)
#summary(ols_01_2016)

test_set_01_2016$ramp_prediction_01_2016 <-  (-3.267e+03 + (9.168e-02)*test_set_01_2016$net_load_MWh 
                                            + (9.500e-02)*test_set_01_2016$net_load_ramp_t_minus_1_MWh
                                            + (2.007e-01)*test_set_01_2016$net_load_ramp_t_minus_2_MWh
                                            + (-7.366e-02)*test_set_01_2016$net_load_ramp_t_minus_3_MWh
                                            + (-7.056e-02)*test_set_01_2016$MWh
                                            + (-6.687e-01)*test_set_01_2016$wind_solar_ramp_t_MWh
                                            + (4.085e-01)*test_set_01_2016$wind_solar_ramp_t_minus_1_MWh
                                            + (-1.768e+00)*test_set_01_2016$wind_solar_ramp_t_minus_2_MWh
                                            + (1.335e+00)*test_set_01_2016$wind_solar_ramp_t_minus_3_MWh)

plot_this <- subset(test_set_01_2016, select=c('timestamp.x', 
                                                      'net_load_ramp_t_MWh',
                                                      'ramp_prediction_01_2016'))
  
write.csv(plot_this, "plot_this.csv")
#############

ggplot(plot_this, aes(x = plot_this$timestamp.x)) + 
  geom_line(aes(y = plot_this$net_load_ramp_t_MWh), colour="blue") + 
  geom_line(aes(y = plot_this$ramp_prediction_01_2016), colour = "grey") + 
  ylab(label="Number of new members") + 
  xlab("Week")  
  


#ugh!!
plot_01_2016 <- ggplot(test_set_01_2016, aes(timestamp.x)) +
  geom_line(aes(y = ramp_prediction_01_2016, colour = "red")) 
+ geom_line(aes(y = net_load_ramp_t_MWh, colour =  "blue"))

#try 2
library("reshape2")
library("ggplot2")

test_data_long <- melt(test_set_01_2016, id="timestamp.x")  # convert to long format

ggplot(data=test_data_long,
       aes(x=timestamp.x, y=value, colour=variable)) +
  geom_line()

# try 3

ggplot(joinsByWeek, aes(x = week)) + 
  geom_line(aes(y = rolling), colour="blue") + 
  geom_line(aes(y = actual), colour = "grey") + 
  ylab(label="Number of new members") + 
  xlab("Week")








