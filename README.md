# TemperatureAnomalies
R code for analyzing, visualizing and forecasting global temperature anomalies.
Originally written for a final project for a course in mathematical modeling.

NOAAGlobalTemp.asc
  - raw spatially gridded global temperature anomaly data (provided by course instructor)

gatherData.R
  - script for cleaning raw data and exporting to .csv
  
generateMap.R
  - provides a function for visualizing spatial data on a map
  
calculateAverages.R
  - script for converting spatial data into yearly average data
  
forecasting.R
  - contains a function for evaluating the performance of several forecasting models
    and executes that function on temperature anomaly data
