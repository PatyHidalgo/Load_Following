# Paty, April 17th 2020.
# Masters' project analysis
# 2030/2050 pathways dependence in the WECC
#
# July 2016: edited to use stage1 results intead of frozen.


# BAU ANALYSIS

rm(list = ls())
setwd("/Volumes/switch/Models/Switch_Runs/WECCv2_2/2016_04_09_CEC_preliminary/")

library("ggplot2")

# READ DATA BAU #######################################################################################################################################
capacity_bau <- read.table("./9690_BAU_288tmpts/AMPL/results/gen_cap_0.txt",stringsAsFactors=F, header = T , fill = TRUE) 
#######################################################################################################################################################

rows <- nrow(capacity_bau)

# selecting only the columns of interest
capacity_bau <- subset(capacity_bau, select=c(period, project_id, load_area_id, load_area, technology, fuel, capacity))

# changing 2016 by 2020 and 2030 by 2030 and 2040 by 2040, 2050 by 2050
capacity_bau$period <- ifelse(capacity_bau$period == 2016, 2020, capacity_bau$period)
capacity_bau$period <- ifelse(capacity_bau$period == 2026, 2030, capacity_bau$period)
capacity_bau$period <- ifelse(capacity_bau$period == 2036, 2040, capacity_bau$period)
capacity_bau$period <- ifelse(capacity_bau$period == 2046, 2050, capacity_bau$period)

#cleaning the data from possible reading problems ("NA")
capacity_bau <- na.omit(capacity_bau)
rows2 <- nrow(capacity_bau)

#checking how many rows were discarded
rows-rows2

# aggregate
capacity_per_period_bau <- aggregate(capacity_bau$capacity, by = list(capacity_bau$fuel, capacity_bau$period), FUN=sum, na.rm=TRUE)
names(capacity_per_period_bau)[1]<-'fuel'
names(capacity_per_period_bau)[2]<-'period'
names(capacity_per_period_bau)[3]<-'capacity'
capacity_per_period_bau$fuel_plot <- ifelse(capacity_per_period_bau$fuel == "Bio_Gas" | 
                                              capacity_per_period_bau$fuel == "Bio_Liquid" | 
                                              capacity_per_period_bau$fuel == "Bio_Solid", "Biomass", capacity_per_period_bau$fuel)
capacity_per_period_bau$fuel_plot <- ifelse(capacity_per_period_bau$fuel == "DistillateFuelOil", 
                                          "Oil", capacity_per_period_bau$fuel_plot)

capacity_per_period_fuel_bau <- aggregate(capacity_per_period_bau$capacity, 
                                        by = list(capacity_per_period_bau$fuel_plot, capacity_per_period_bau$period),
                                        FUN=sum, na.rm=TRUE)
names(capacity_per_period_fuel_bau)[1]<-'fuel'
names(capacity_per_period_fuel_bau)[2]<-'period'
names(capacity_per_period_fuel_bau)[3]<-'capacity'

# Percentage ############################################################################################################################################################

# total capacity per period wo storage
tot_cap_per_period <- aggregate(capacity_per_period_fuel_bau$capacity, 
                                by = list(capacity_per_period_fuel_bau$period),
                                FUN=sum, na.rm=TRUE)
names(tot_cap_per_period)[1]<-'period'
names(tot_cap_per_period)[2]<-'capacity'

# capacity per fuel per period (to be able to calculate capacity percentages by fuel)
capacity_per_fuel_2020 <- subset(capacity_per_period_fuel_bau, capacity_per_period_fuel_bau$period==2020)
capacity_per_fuel_2030 <- subset(capacity_per_period_fuel_bau, capacity_per_period_fuel_bau$period==2030)
capacity_per_fuel_2040 <- subset(capacity_per_period_fuel_bau, capacity_per_period_fuel_bau$period==2040)
capacity_per_fuel_2050 <- subset(capacity_per_period_fuel_bau, capacity_per_period_fuel_bau$period==2050)


# adding percentages column to then plot
capacity_per_fuel_2020$percentage <- capacity_per_fuel_2020$capacity / subset(tot_cap_per_period$capacity, tot_cap_per_period$period == 2020)*100
capacity_per_fuel_2030$percentage <- capacity_per_fuel_2030$capacity / subset(tot_cap_per_period$capacity, tot_cap_per_period$period == 2030)*100
capacity_per_fuel_2040$percentage <- capacity_per_fuel_2040$capacity / subset(tot_cap_per_period$capacity, tot_cap_per_period$period == 2040)*100
capacity_per_fuel_2050$percentage <- capacity_per_fuel_2050$capacity / subset(tot_cap_per_period$capacity, tot_cap_per_period$period == 2050)*100

# capacity and percentage per period per fuel as a single table
capacity_bau <- rbind(subset(capacity_per_fuel_2020), 
                    capacity_per_fuel_2030, 
                    capacity_per_fuel_2040,
                    capacity_per_fuel_2050)


# STAGE 1 #################################################################################################################################################################
# READ DATA stg1 #######################################################################################################################################
capacity_stg1 <- read.table("./9701_BAU_stage1/AMPL/results/gen_cap_0.txt",stringsAsFactors=F, header = T , fill = TRUE) 
#######################################################################################################################################################
#  9705_BAU_frozen
rows <- nrow(capacity_stg1)

# selecting only the columns of interest
capacity_stg1 <- subset(capacity_stg1, select=c(period, project_id, load_area_id, load_area, technology, fuel, capacity))

# changing 2016 by 2020 and 2030 by 2030 and 2040 by 2040, 2050 by 2050
capacity_stg1$period <- ifelse(capacity_stg1$period == 2016, 2020, capacity_stg1$period)
capacity_stg1$period <- ifelse(capacity_stg1$period == 2026, 2030, capacity_stg1$period)
capacity_stg1$period <- ifelse(capacity_stg1$period == 2036, 2040, capacity_stg1$period)
capacity_stg1$period <- ifelse(capacity_stg1$period == 2046, 2050, capacity_stg1$period)

#cleaning the data from possible reading problems ("NA")
capacity_stg1 <- na.omit(capacity_stg1)
rows2 <- nrow(capacity_stg1)

#checking how many rows were discarded
rows-rows2

# aggregate

capacity_per_period_stg1 <- aggregate(capacity_stg1$capacity, by = list(capacity_stg1$fuel, capacity_stg1$period), FUN=sum, na.rm=TRUE)
names(capacity_per_period_stg1)[1]<-'fuel'
names(capacity_per_period_stg1)[2]<-'period'
names(capacity_per_period_stg1)[3]<-'capacity'
capacity_per_period_stg1$fuel_plot <- ifelse(capacity_per_period_stg1$fuel == "Bio_Gas" | 
                                               capacity_per_period_stg1$fuel == "Bio_Liquid" | 
                                               capacity_per_period_stg1$fuel == "Bio_Solid", "Biomass", capacity_per_period_stg1$fuel)
capacity_per_period_stg1$fuel_plot <- ifelse(capacity_per_period_stg1$fuel == "DistillateFuelOil", 
                                             "Oil", capacity_per_period_stg1$fuel_plot)

capacity_per_period_fuel_stg1 <- aggregate(capacity_per_period_stg1$capacity, 
                                           by = list(capacity_per_period_stg1$fuel_plot, capacity_per_period_stg1$period),
                                           FUN=sum, na.rm=TRUE)
names(capacity_per_period_fuel_stg1)[1]<-'fuel'
names(capacity_per_period_fuel_stg1)[2]<-'period'
names(capacity_per_period_fuel_stg1)[3]<-'capacity'

# Percentage ############################################################################################################################################################

# total capacity per period wo storage
tot_cap_per_period <- aggregate(capacity_per_period_fuel_stg1$capacity, 
                                by = list(capacity_per_period_fuel_stg1$period),
                                FUN=sum, na.rm=TRUE)
names(tot_cap_per_period)[1]<-'period'
names(tot_cap_per_period)[2]<-'capacity'

# capacity per fuel per period (to be able to calculate capacity percentages by fuel)
capacity_per_fuel_2020 <- subset(capacity_per_period_fuel_stg1, capacity_per_period_fuel_stg1$period==2020)
capacity_per_fuel_2030 <- subset(capacity_per_period_fuel_stg1, capacity_per_period_fuel_stg1$period==2030)

# adding percentages column to then plot
capacity_per_fuel_2020$percentage <- capacity_per_fuel_2020$capacity / subset(tot_cap_per_period$capacity, tot_cap_per_period$period == 2020)*100
capacity_per_fuel_2030$percentage <- capacity_per_fuel_2030$capacity / subset(tot_cap_per_period$capacity, tot_cap_per_period$period == 2030)*100

# capacity and percentage per period per fuel as a single table
capacity_stg1 <- rbind(subset(capacity_per_fuel_2020), 
                       capacity_per_fuel_2030)

# COMPARISON #############################################################################################################################################################

capacity_2020_2030_bau <- subset(capacity_bau, capacity_bau$period <= 2030)
capacity_2020_2030_bau$capacity_stg1 <- capacity_stg1$capacity
capacity_2020_2030_bau$percentage_stg1 <- capacity_stg1$percentage

# new column, and the one to use instead of the relative % change.
capacity_2020_2030_bau$diff_percent <- (capacity_2020_2030_bau$capacity_stg1 - capacity_2020_2030_bau$capacity)/capacity_2020_2030_bau$capacity*100

capacity_2020_2030_bau$diff_percent_from_percent <- (capacity_2020_2030_bau$percentage_stg1 - capacity_2020_2030_bau$percentage)/capacity_2020_2030_bau$percentage_stg1*100
# absolute percentage difference (not normalized by the share of the total capacity that fuel represents)
capacity_2020_2030_bau$absolute_percent_diff <- (capacity_2020_2030_bau$percentage_stg1 - capacity_2020_2030_bau$percentage)
# GW difference
capacity_2020_2030_bau$capacity_diff_GW <- (capacity_2020_2030_bau$capacity_stg1 - capacity_2020_2030_bau$capacity)/1000

#remove oil because it is basically zero and it's making a bar twice the size in the CPP scenarios because there is no data in 2040 period.
capacity_2020_2030_bau <- subset(capacity_2020_2030_bau, capacity_2020_2030_bau$fuel != "Oil")

#periods as factors so the legend realizes it's a discrete variable
capacity_2020_2030_bau$period <- as.factor(capacity_2020_2030_bau$period)



# PLOTS #####

# Second set of plots #####################################################################################################################

#new plot:
def_diff_GW_BAU <- ggplot(data=subset(capacity_2020_2030_bau, capacity_2020_2030_bau$period == 2030), aes(x=fuel, y=capacity_diff_GW, fill=fuel)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") +  
  scale_fill_manual(values = c("Biomass" = "springgreen4", "Coal" = "tan4", "Gas" = "cornsilk3","Geothermal" = "red","Solar" = "gold","Uranium" = "blueviolet",
                               "Water" = "dodgerblue","Wind" = "deepskyblue1", "Oil" = "black")) +
  labs(x="Fuel") + labs(y="Change in capacity [GW] ('short' - 'long')") + labs(fill="")+   theme(text=element_text(size=16))  #+ ylim(-14, 14)

def_diff_GW_BAU

#save plot as .bmp
bmp(file = "./R_analysis_stage1/comparison_capacity/def_diff_GW_BAU.bmp", width = 560, height = 550)
def_diff_GW_BAU
dev.off()

# TWh to put all in the same plot
def_diff_GW_Yfixed_BAU <- ggplot(data=subset(capacity_2020_2030_bau, capacity_2020_2030_bau$period == 2030), aes(x=fuel, y=capacity_diff_GW, fill=fuel)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") +  
  scale_fill_manual(values = c("Biomass" = "springgreen4", "Coal" = "tan4", "Gas" = "cornsilk3","Geothermal" = "red","Solar" = "gold","Uranium" = "blueviolet",
                               "Water" = "dodgerblue","Wind" = "deepskyblue1", "Oil" = "black")) +
  labs(x="Fuel") + labs(y="Change in capacity [GW] ('short' - 'long')") + labs(fill="")+   theme(text=element_text(size=16))  + ylim(-13.3, 13)

def_diff_GW_Yfixed_BAU

#save plot as .bmp
bmp(file = "./R_analysis_stage1/comparison_capacity/def_diff_GW_Yfixed_BAU.bmp", width = 560, height = 550)
def_diff_GW_Yfixed_BAU
dev.off()

#new plot: fixed ylim
def_percent_diff_BAU <- ggplot(data=subset(capacity_2020_2030_bau, capacity_2020_2030_bau$period == 2030), aes(x=fuel, y=diff_percent, fill=fuel)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") +  
  scale_fill_manual(values = c("Biomass" = "springgreen4", "Coal" = "tan4", "Gas" = "cornsilk3","Geothermal" = "red","Solar" = "gold","Uranium" = "blueviolet",
                               "Water" = "dodgerblue","Wind" = "deepskyblue1", "Oil" = "black")) +
  labs(x="Fuel") + labs(y="Change in capacity [%] ('short'-'long')/'long'") + labs(fill="")+   theme(text=element_text(size=16))  + ylim(-55, 260)

def_percent_diff_BAU

#save plot as .bmp
bmp(file = "./R_analysis_stage1/comparison_capacity/def_percent_diff_BAU.bmp", width = 560, height = 550)
def_percent_diff_BAU
dev.off()


#new plot: zoom
def_percent_diff_zoom_BAU <- ggplot(data=subset(capacity_2020_2030_bau, capacity_2020_2030_bau$period == 2030), aes(x=fuel, y=diff_percent, fill=fuel)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") +  
  scale_fill_manual(values = c("Biomass" = "springgreen4", "Coal" = "tan4", "Gas" = "cornsilk3","Geothermal" = "red","Solar" = "gold","Uranium" = "blueviolet",
                               "Water" = "dodgerblue","Wind" = "deepskyblue1", "Oil" = "black")) +
  labs(x="Fuel") + labs(y="Change in capacity [%] ('short'-'long')/'long'") + labs(fill="")+   theme(text=element_text(size=16))  #+ ylim(-25, 260)

def_percent_diff_zoom_BAU

#save plot as .bmp
bmp(file = "./R_analysis_stage1/comparison_capacity/def_percent_diff_zoom_BAU.bmp", width = 560, height = 550)
def_percent_diff_zoom_BAU
dev.off()

## First set of plots ##################


# new
new_comparison_capacity_bau <- ggplot(data=capacity_2020_2030_bau, aes(x=fuel, y=diff_percent, fill=period)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") + 
  labs(x="Fuel") + labs(y="Change in capacity [%] ('short' - 'long')/'long'") + labs(fill="")+ ylim(-30, 30) + theme(text=element_text(size=16))

new_comparison_capacity_bau

#save plot as .bmp
bmp(file = "./R_analysis_stage1/comparison_capacity/new_comparison_capacity_bau.bmp", width = 550, height = 550)
new_comparison_capacity_bau
dev.off()

comparison_capacity_bau <- ggplot(data=capacity_2020_2030_bau, aes(x=fuel, y=diff_percent_from_percent, fill=period)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") + 
  labs(x="Fuel") + labs(y="Relative difference in capacity [%] ('short' - 'long')") + labs(fill="")+ ylim(-30, 30) + theme(text=element_text(size=16))

comparison_capacity_bau

#save plot as .bmp
bmp(file = "./R_analysis_stage1/comparison_capacity/comparison_capacity_bau.bmp", width = 550, height = 550)
comparison_capacity_bau
dev.off()

#absolute percentage difference
absolute_percent_diff_capacity_bau <- ggplot(data=capacity_2020_2030_bau, aes(x=fuel, y=absolute_percent_diff, fill=period)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") + 
  labs(x="Fuel") + labs(y="Difference in capacity share [%] ('short' - 'long')") + labs(fill="")+ ylim(-0.75, 0.75) + theme(text=element_text(size=16))

absolute_percent_diff_capacity_bau

#save plot as .bmp
bmp(file = "./R_analysis_stage1/comparison_capacity/absolute_percent_diff_capacity_bau.bmp", width = 550, height = 550)
absolute_percent_diff_capacity_bau
dev.off()


# GW difference
capacity_diff_GW_bau <- ggplot(data=capacity_2020_2030_bau, aes(x=fuel, y=capacity_diff_GW, fill=period)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") + 
  labs(x="Fuel") + labs(y="Difference in capacity [GW] ('short' - 'long')") + labs(fill="")+ ylim(-1.5, 1.5) +  theme(text=element_text(size=16))

capacity_diff_GW_bau

#save plot as .bmp
bmp(file = "./R_analysis_stage1/comparison_capacity/capacity_diff_GW_bau.bmp", width = 550, height = 550)
capacity_diff_GW_bau
dev.off()


# TOTAL CAPACITY 2020, 2030 #####################################################################################################################################################

# Creating dataframe for absolute capacity
capacity_abs_long <- subset(capacity_2020_2030_bau, select = c(fuel, period, capacity))
capacity_abs_long$optim <- "long"

capacity_abs_short <- subset(capacity_2020_2030_bau, select = c(fuel, period, capacity_stg1))
capacity_abs_short$optim <- "short"
names(capacity_abs_short)[3] <- "capacity"

capacity_abs <- rbind(capacity_abs_long, capacity_abs_short)

# absolute capacity 2020
absolute_capacity_GW_2020_bau <- ggplot(data=subset(capacity_abs, period == 2020), aes(x=fuel, y=capacity/1000, fill=optim)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") + 
  labs(x="Fuel") + labs(y="Capacity in 2020 [GW]") + labs(fill="")+ ylim(0, 110) +  theme(text=element_text(size=16))

absolute_capacity_GW_2020_bau

#save plot as .bmp
bmp(file = "./R_analysis_stage1/comparison_capacity/absolute_capacity_GW_2020_bau.bmp", width = 550, height = 550)
absolute_capacity_GW_2020_bau
dev.off()

# absolute capacity 2030
absolute_capacity_GW_2030_bau <- ggplot(data=subset(capacity_abs, period == 2030), aes(x=fuel, y=capacity/1000, fill=optim)) +
  geom_bar(stat="identity", position=position_dodge(), colour="black") + 
  labs(x="Fuel") + labs(y="Capacity in 2030 [GW]") + labs(fill="")+ ylim(0, 150) +  theme(text=element_text(size=16))

absolute_capacity_GW_2030_bau

#save plot as .bmp
bmp(file = "./R_analysis_stage1/comparison_capacity/absolute_capacity_GW_2030_bau.bmp", width = 550, height = 550)
absolute_capacity_GW_2030_bau
dev.off()

