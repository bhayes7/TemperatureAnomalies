library(dplyr)
library(ggplot2)

# Create a series of plots to visualize worsening temperature anomalies worldwide

# import data cleaned in gatherData.R
data <- read.csv("spatial_noaa_data.csv", check.names = FALSE)

# pre-selected evenly-spaced (almost) time points to display
target_dates = c('1880-1', '1905-1', '1930-1', '1955-1', '1980-1', '2015-1')

# world map plot overlay
worldMapData <- map_data("world")

# function for building global temperature anomaly plots
temp_anom_map <- function(colname){
  year <- data[,c("lat", "long", colname)]
  filtered <- year[!is.na(year[,colname]),] # missing values mess with the scale, so exclude 
  title <- paste('Global Temperature Anomalies,', colname)
  # world map ggplot object needs to be declared within function so it can access the environment()
  mapPlot<- ggplot(environment = environment()) +
    geom_polygon(data = worldMapData, aes(x = long, y = lat, group = group), fill = NA, color = 'black') +
    coord_fixed(2) +
    coord_cartesian(xlim = c(-180, 180), ylim = c(-90, 90))
  plot <- mapPlot +
    geom_tile(data = filtered, aes(x = filtered[,2], y = filtered[,1], fill = filtered[,3]), alpha = 0.75) +
    labs(title = title, x = 'Longitude', y = 'Latitude', fill = 'Anomaly') +
    scale_fill_gradient2(low = 'blue', high = 'red')
  return(plot)
}

# generate plots from list of target dates
plots <- lapply(target_dates, temp_anom_map)

