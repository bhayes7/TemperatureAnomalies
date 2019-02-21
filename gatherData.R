library(dplyr)

# Read and wrangle raw NOAA global temperature anomaly data, then write cleaned data to csv

# read source data as numeric vector
raw_data = scan("NOAAGlobalTemp.asc") 

# the raw data is spatially gridded temperature data by month
num_datapoints <- length(raw_data)
num_cols <- 2594                      # (180 latitudinal degrees/5 degree squares)*(360 longitudinal degrees/5 degree squares)
                                      # + 2 columns for month and year
num_rows <- num_datapoints / num_cols # this gives the number of months of data

lats <- seq(from = -87.5, to = 87.5, by = 5) %>% # covers latitudinal coordinates as specified by data
  rep(times = 72) %>%                            # repeat each latitudinal coordinate for each longitudinal coordinate
  sort()                                         # coordinate matrix will go latitude-longitude

longs <- (seq(from = 2.5, to = 357.5, by = 5) - 180) %>% # covers longitudinal coordinates as specified by data; 
                                                         # convert to -180/+180 scale for easier plotting later
  rep(times = 36)                                        # repeat each longitudinal coordinate for each latitudinal coordinate  

coords <- cbind(lats, longs) # coordinate matrix will be added to data

# shape the data vector into a spatial/temporal matrix
spatial <- raw_data %>%
  matrix(nrow = num_rows, byrow = T) %>%
  t() # transpose so that each column is a unique time point

dates <- paste(spatial[2,], spatial[1,], sep = '-') # vector of time points in YYYY-M format, to be used as col names

labelled <- cbind(coords, spatial[-c(1, 2), ]) # drop old date rows and add new coordinate columns
colnames(labelled) <- c('lat', 'long', dates)  # standardize colnames

labelled[labelled == -999.9] <- NA # flag missing values

# the resulting csv is ~25 MB
# write.csv(labelled, "spatial_noaa_data.csv", row.names = FALSE)
  


