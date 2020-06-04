# Mini Stock Analysis App
This R Shiny app is a quick-and-dirty personal app for technical analysis of stocks.  The purpose of this app is to allow the user to analyze the technical components of stocks by drawing inferences from charts.  There are a preset list of technical analytics from the TTR package incorporated in this application.

## Installation
To get started with this Shiny app, please clone repo and navigate to the /Run folder and run the app_run.R script.  The run script's code is below.  Please alter app_wd to whatever path the repo has been designated.

```R
require(shiny)

app_wd = "~/GitHub/personal-stock-analysis-app/App"
runApp(app_wd, launch.browser = TRUE)
```
## R Dependencies
```R
install.packages(shiny)
install.packages(shinydashboard)
install.packages(ggplot2)
install.packages(dygraphs)
install.packages(shinyBS)
install.packages(quantmod)
install.packages(plyr)
install.packages(dashboardthemes)
install.packages(shinyjs)
install.packages(shinycssloaders)
```

## Preset Tracked Stocks
The /Data/user_stocks_source.txt file is comprised of stocks that are tracked in the initial load of app.  All other stocks must be added to the /Data/user_stocks_source.txt file as a new row.  Please include company names and sector category if creating your own list of stocks to track.

## App Usage and User Interface
The user interace is very basic and simple, the purpose is to navigate through preset stocks the user tracks or owns and view technical components.  

### Select Stocks
This tab allows the user to either select predefined stocks by category or searching for a stock ticker.  Searching for a stock ticker take priority over whatever preset stock is selected.

### Select Dates
This tab allows the user to specify the date range to perform analyses on.  Input should be in YYYY-mm-dd format.

## Analyses
The following analyses can be altered in the /Data/fin_analysis_index_source.txt file by adding in new analyses and corresponding information from the [TTR package](https://github.com/joshuaulrich/TTR).
### General Analyses
- Price Envelope
- Options and Futures Expiration
- Momentum
- Rate of Change
- Volume
- Williams %R
- ZLEMA
### Moving Average Analyses
- Double Exponential Moving Average
- Exponential Moving Average
- Exponential Volume Weighted Moving Average
- Moving Average Convergence Divergence
- Simple Moving Average
- Weighted Moving Average
### Index Analyses
- Commodity Channel Index
- Relative Strength Indicator
- Stochastic Momentum Index
### Other Analyses
- Chaiken Money Flow
- Chande Momentum Oscillator
- Detrended Price Oscillator
- Parabolic Stop and Reverse 
- Triple Smoothed Exponential Oscillator

## Author
J Breuer - j7breuer@gmail.com.  Please reach out with any questions.

## Updates
Updates will be few and far between as this currently serves the purpose I intended it to. 
