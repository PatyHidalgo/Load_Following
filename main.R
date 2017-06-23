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
source("calculate_ramps.R")

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

# append all months to have only one set for the year
hourly_2016 <- rbind(hourly_01_2016, 
                     hourly_02_2016,
                     hourly_03_2016,
                     hourly_04_2016,
                     hourly_05_2016,
                     hourly_06_2016,
                     hourly_07_2016,
                     hourly_08_2016,
                     hourly_09_2016,
                     hourly_10_2016,
                     hourly_11_2016,
                     hourly_12_2016)

# order by year, month, day, and hour
hourly_2016<- hourly_2016[order(hourly_2016$year, 
                                hourly_2016$month, 
                                hourly_2016$day,
                                hourly_2016$hour),]

# calculatin load and wind+solar ramps
hourly_2016 <- calculate_ramps(hourly_2016)


# linear regression with all hours. Just to look at it.
test_all_data <- lm(formula = net_load_ramp_t_MWh ~ weekday 
   + hour
   + month 
   + net_load_t_minus_1_MWh
   + net_load_t_minus_2_MWh
   + net_load_t_minus_3_MWh
   + net_load_ramp_t_minus_1_MWh
   + net_load_ramp_t_minus_2_MWh
   + net_load_ramp_t_minus_3_MWh
   + wind_solar_t_minus_1_MWh
   + wind_solar_t_minus_2_MWh
   + wind_solar_t_minus_3_MWh
   + wind_solar_ramp_t_minus_1_MWh
   + wind_solar_ramp_t_minus_2_MWh
   + wind_solar_ramp_t_minus_3_MWh,
   data = hourly_2016
   )
summary(test_all_data)


# picking an arbitrary training set
training_2016 <- subset(hourly_2016, day==4 | day==5 | day==6 | day==7 | day==8 | day==9 | day==10)
test_set_2016 <- subset(hourly_2016, day!=4 & day!=5 & day!=6 & day!=7 & day!=8 & day!=9 & day!=10)


# Ordinary least Squares #######################################################################################

# [Notes] Should we scale and center the data? scale(cars$speed, center=TRUE, scale=FALSE)
# OLS without weekday variable
ols_2016 <- lm(formula = net_load_ramp_t_MWh ~ hour
               + month 
               + net_load_t_minus_1_MWh
               + net_load_t_minus_2_MWh
               + net_load_t_minus_3_MWh
               + net_load_ramp_t_minus_1_MWh
               + net_load_ramp_t_minus_2_MWh
               + net_load_ramp_t_minus_3_MWh
               + wind_solar_t_minus_1_MWh
               + wind_solar_t_minus_2_MWh
               + wind_solar_t_minus_3_MWh
               + wind_solar_ramp_t_minus_1_MWh
               + wind_solar_ramp_t_minus_2_MWh
               + wind_solar_ramp_t_minus_3_MWh,
               data = hourly_2016
)
summary(ols_2016)


# OLS less variables so they are more meaningful
#ols_01_2016 <- lm(formula = net_load_ramp_t_MWh ~ net_load_ramp_t_minus_2_MWh
#                  + wind_solar_ramp_t_minus_2_MWh
#                  + wind_solar_ramp_t_minus_3_MWh,
#                  data = training_01_2016)
#summary(ols_01_2016)

test_set_2016$ramp_prediction_2016 <-  (4.045e+03 + (5.290e+01)*test_set_2016$hour 
                                            + (1.333e+02)*test_set_2016$month
                                            + (-1.932e-02)*test_set_2016$net_load_t_minus_1_MWh
                                            + (6.023e-02)*test_set_2016$net_load_t_minus_2_MWh
                                            + (-1.942e-01)*test_set_2016$net_load_t_minus_3_MWh
                                            + (1.866e-01)*test_set_2016$net_load_ramp_t_minus_3_MWh
                                            + (-3.800e-01)*test_set_2016$wind_solar_t_minus_1_MWh
                                            + (2.853e-01)*test_set_2016$wind_solar_t_minus_2_MWh
                                            + (2.387e-01)*test_set_2016$wind_solar_t_minus_3_MWh
                                            + (1.741e-01)*test_set_2016$wind_solar_ramp_t_minus_3_MWh)

plot_this <- subset(test_set_2016, select=c('timestamp.x', 
                                                      'net_load_ramp_t_MWh',
                                                      'ramp_prediction_2016'))
  
#write.csv(plot_this, "plot_this.csv")

# OLS with hour, month and weekday as factors (dummy variables)
ols_2016_discrete <- lm(formula = net_load_ramp_t_MWh ~ factor(hour)
                        + factor(weekday)
                        + factor(month) 
                        + net_load_t_minus_1_MWh
                        + net_load_t_minus_2_MWh
                        + net_load_t_minus_3_MWh
                        + net_load_ramp_t_minus_1_MWh
                        + net_load_ramp_t_minus_2_MWh
                        + net_load_ramp_t_minus_3_MWh
                        + wind_solar_t_minus_1_MWh
                        + wind_solar_t_minus_2_MWh
                        + wind_solar_t_minus_3_MWh
                        + wind_solar_ramp_t_minus_1_MWh
                        + wind_solar_ramp_t_minus_2_MWh
                        + wind_solar_ramp_t_minus_3_MWh,
               data = hourly_2016
)
summary(ols_2016_discrete)
#model_v1 <- summary(ols_2016_discrete)
#model_v1$coefficients["factor(month)12",1]

test_set_2016$ramp_prediction_dummy <- predict(ols_2016_discrete, test_set_2016)
#ols_2016
#test_set_2016$test <- predict(ols_2016, test_set_2016)

plot_this <- subset(test_set_2016, select=c('timestamp.x', 
                                            'net_load_ramp_t_MWh',
                                            'ramp_prediction_2016',
                                            'ramp_prediction_dummy'))

write.csv(plot_this, "plot_this_discrete.csv")

# OLS with 3 weeks or training set and 1 week for predictions (per month for 2016) ###########################################################

# picking an arbitrary training set
test_set_2016_v2 <- subset(hourly_2016, day==4 | day==5 | day==6 | day==7 | day==8 | day==9 | day==10)
training_set_2016_v2 <- subset(hourly_2016, day!=4 & day!=5 & day!=6 & day!=7 & day!=8 & day!=9 & day!=10)

ols_2016_discrete_v2 <- lm(formula = net_load_ramp_t_MWh ~ factor(hour)
                        + factor(weekday)
                        + factor(month) 
                        + net_load_t_minus_1_MWh
                        + net_load_t_minus_2_MWh
                        + net_load_t_minus_3_MWh
                        + net_load_ramp_t_minus_1_MWh
                        + net_load_ramp_t_minus_2_MWh
                        + net_load_ramp_t_minus_3_MWh
                        + wind_solar_t_minus_1_MWh
                        + wind_solar_t_minus_2_MWh
                        + wind_solar_t_minus_3_MWh
                        + wind_solar_ramp_t_minus_1_MWh
                        + wind_solar_ramp_t_minus_2_MWh
                        + wind_solar_ramp_t_minus_3_MWh,
                        data = training_set_2016_v2
)
summary(ols_2016_discrete_v2)

test_set_2016_v2$ramp_prediction_dummy <- predict(ols_2016_discrete_v2, test_set_2016_v2)

plot_this <- subset(test_set_2016_v2, select=c('timestamp.x', 
                                            'net_load_ramp_t_MWh',
                                            'ramp_prediction_dummy'))

write.csv(plot_this, "plot_this_discrete_v2.csv")

# plot worked (fix x axis display): 
#df <- data.frame(plot_this$timestamp.x, plot_this$net_load_ramp_t_MWh, plot_this$ramp_prediction_dummy)
#ggplot(df, aes(plot_this$timestamp.x, y = value, color = variable)) + 
#  geom_point(aes(y = plot_this$net_load_ramp_t_MWh, col = "net_load_ramp_t_MWh")) + 
#  geom_point(aes(y = plot_this$ramp_prediction_dummy, col = "ramp_prediction_dummy"))


# OLS with 6 hours of past features ##################################################################################

ols_2016_discrete_v3 <- lm(formula = net_load_ramp_t_MWh ~ factor(hour)
                           + factor(weekday)
                           + factor(month) 
                           + net_load_t_minus_1_MWh
                           + net_load_t_minus_2_MWh
                           + net_load_t_minus_3_MWh
                           + net_load_t_minus_4_MWh
                           + net_load_t_minus_5_MWh
                           + net_load_t_minus_6_MWh
                           + net_load_ramp_t_minus_1_MWh
                           + net_load_ramp_t_minus_2_MWh
                           + net_load_ramp_t_minus_3_MWh
                           + wind_solar_t_minus_1_MWh
                           + wind_solar_t_minus_2_MWh
                           + wind_solar_t_minus_3_MWh
                           + wind_solar_t_minus_4_MWh
                           + wind_solar_t_minus_5_MWh
                           + wind_solar_t_minus_6_MWh
                           + wind_solar_ramp_t_minus_1_MWh
                           + wind_solar_ramp_t_minus_2_MWh
                           + wind_solar_ramp_t_minus_3_MWh,
                           data = training_set_2016_v2
)
summary(ols_2016_discrete_v3)

test_set_2016_v2$ramp_prediction_dummy_6hrs <- predict(ols_2016_discrete_v3, test_set_2016_v2)

plot_this <- subset(test_set_2016_v2, select=c('timestamp.x', 
                                               'net_load_ramp_t_MWh',
                                               'ramp_prediction_dummy',
                                               'ramp_prediction_dummy_6hrs'))

write.csv(plot_this, "plot_this_discrete_v3.csv")

# Lasso (1-norm) ######################################################################################################

# install.packages("glmnet", repos = "http://cran.us.r-project.org")

library(glmnet)


#############
# 



