library(seasonal)
library(readr) 

# Read the CSV (make sure your Date column is properly formatted: Jan-11, Feb-11 etc.)
df <- read_csv("C:/MDAE/Macroeconomic Forecasting/CPISeasonallyAdjustment.csv")

# Convert Date to proper R date (first day of each month)
df$Date <- as.Date(paste0("01-", df$Date), format="%d-%b-%y")

# 2. Define which columns you want to seasonally adjust
cols <- names(df)[-1]   # all except Date
# Or manually: cols <- c("Food and beverages", "Cereals and products", ...)

# 3. Create an empty list to store results
sa_results <- list()

# 4. Run seasonal adjustment for each column
for (col in cols) {
  series_ts <- ts(df[[col]], start = c(2011, 1), frequency = 12)
  sa_model <- seas(series_ts, outlier.types = c("ao", "tc"))  # with outlier adjustments
  sa_results[[col]] <- final(sa_model)
}

# 5. Combine into a data frame
sa_df <- data.frame(
  Date = seq(as.Date("2011-01-01"), by = "month", length.out = nrow(df)),
  do.call(cbind, sa_results)
)

# 6. Save to CSV
write.csv(sa_df, "C:/MDAE/Macroeconomic Forecasting/seasonally_adjusted_2017excluded_covidadjusted.csv", row.names = FALSE)
