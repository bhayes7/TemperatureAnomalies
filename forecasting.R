library(forecast)

# use forecasting tools to model future temperature anomalies

# read in yearly average data
yearly_temp_anoms <- read.csv("yearly_temp_anoms.csv")

# store the data as a timeseries
anoms_ts <- ts(yearly_temp_anoms$year_avg, start = 1880)

# split into train and test data
anoms_train <- window(anoms_ts, start = 1969, end = 2008)
anoms_test <- window(anoms_ts, start = 2009)

# determine which forecasting method has the best performance for the provided data
evaluate_forecasts <- function(train, test){
  h <- length(test) # num. of forecast periods
  
  forecasts <- list()
  
  # simple linear forecast with Holt's method
  forecasts[['holt']] <- holt(train, h = h)
  
  # fitted exponential model
  forecasts[['ets']] <- forecast(ets(train), h = h)
  
  # ARIMA model
  forecasts[['arima']] <- forecast(
    auto.arima(train, approximation = FALSE, stepwise = FALSE), # disable approx. params for better forecast
    h = h
  )
  
  # TBATS model
  forecasts[['tbats']] <- forecast(tbats(train), h = h)
  
  # neural net model
  forecasts[['nnetar']] <- forecast(nnetar(train), h = h)
  
  # combined model, simple average of all other forecasts
  combined <- lapply(forecasts, function(fc){return(fc[['mean']])}) %>%
    unlist() %>%
    matrix(nrow = 5, ncol = h, byrow = TRUE) %>%
    colMeans() %>%
    ts(start = time(train)[length(train)] + 1)
  
  # combine accuracy metrics of all forecasts into a df
  accuracies <- lapply(forecasts, function(fc){return(accuracy(fc, test)['Test set',])}) %>%
    as.data.frame() %>%
    t() %>%
    as.data.frame() %>% # have to re-cast to df after taking transpose
    mutate(model = names(forecasts))
  
  # combined needs to be added separately, since accuracy() doesn't produce MASE column w/out training data
  combined_accuracy <- accuracy(combined, test) %>%
    as.data.frame() %>%
    mutate(MASE = NA, model = 'combined')
  
  best_model <- rbind(accuracies, combined_accuracy) %>%
    slice(which.min(MAPE))
  
  return(best_model$model)
}

evaluate_forecasts(anoms_train, anoms_test) # here, the ets model has the best performance

forecast <- forecast(ets(window(anoms_ts, start = 1979)), h = 10)

# quick visualization of the 10-year forecast
autoplot(forecast) +
  xlab("Year") + ylab("Temperature Anomaly") +
  ggtitle("Global Average Temperature Anomalies")
