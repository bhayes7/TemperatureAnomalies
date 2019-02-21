library(dplyr) 
library(tidyr) # for gather()

# Use gridded temp. anomaly data to find average global anomalies for each year

# import data cleaned in gatherData.R
data <- read.csv("spatial_noaa_data.csv", check.names = FALSE)

# compute yearly worldwide temperature anomalies
averages <- data %>%
  gather(key = date, value = anomaly, `1880-1`:`2018-1`) %>% # spatial format -> tidy format
  group_by(date) %>%
  summarise(avg = mean(anomaly, na.rm = TRUE)) %>% # find the average for each date period (year-month)
  separate(col = date, into = c('year', 'month'), sep = 5, convert = TRUE) %>%
  separate(col = year, into = c('year', 'dash'), sep = 4, convert = TRUE) %>%
  select(-dash) %>%
  group_by(year) %>%
  summarise(year_avg = mean(avg)) # average all the months within each year

# write.csv(averages, "yearly_temp_anoms.csv", row.names = FALSE)

# quick plot of the anomalies (clearly increasing)
ggplot(data = averages, aes(x = year, y = year_avg)) +
  geom_line(size = 1, color = 'blue') +
  geom_point(color = 'red') +
  labs(title = 'Global Average Temperature Anomalies, 1880-2018', x = 'Year', y = 'Average Temperature Anomaly')
