library(readr)
library(seasonal)

# Read the CSV (make sure your Date column is properly formatted: Jan-11, Feb-11 etc.)
df <- read_csv("C:/MDAE/Macroeconomic Forecasting/InflationRawData.csv")

# Convert Date to proper R date (first day of each month)
df$Date <- as.Date(paste0("01-", df$Date), format="%d-%b-%y")

food_ts <- ts(df$`Food and beverages`, start = c(2011, 1), frequency = 12)

sa_food <- seas(food_ts)
plot(sa_food)             # shows raw + SA series
food_sa <- final(sa_food) # seasonally adjusted series

cols <- names(df)[-1]  # all columns except Date
sa_results <- list()

for (col in cols) 
  {
  series_ts <- ts(df[[col]], start=c(2011,1), frequency=12)
  sa_model <- seas(series_ts)
  sa_results[[col]] <- final(sa_model)
  }

# Convert back into data.frame with Date
sa_df <- data.frame(Date = df$Date, do.call(cbind, sa_results))

# Combine all seasonally adjusted series into a data frame
sa_df <- data.frame(Date = seq(as.Date("2011-01-01"), by = "month", length.out = nrow(df)),
                    do.call(cbind, sa_results))

# Save to CSV
write.csv(sa_df, "seasonally_adjusted_inflation.csv", row.names = FALSE)

