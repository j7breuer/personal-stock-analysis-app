
#--------------#
# Start Server #
#--------------#

require(shinydashboard)
require(ggplot2)
require(dygraphs)
require(shinyBS)
require(quantmod)
require(plyr)
require(dashboardthemes)
require(shinyjs)
require(shinycssloaders)

stockPortfolio <- read.table("~/GitHub/personal-stock-analysis-app/Data/user_stocks_source.txt", sep = '\t', header = TRUE, stringsAsFactors = FALSE)
faIndex <- read.table("~/GitHub/personal-stock-analysis-app/Data/fin_analysis_index_source.txt", sep = '\t', header = TRUE, stringsAsFactors = FALSE)
symbols <- stockPortfolio$StockTicker

stockList <- list()

for (i in 1:length(symbols)){

	curSymbol <- symbols[i]

	x <- getSymbols(curSymbol, auto.assign = FALSE)

	stockList[[i]] <- x

}

shinyServer(function(input, output, session){


	output$selectStocksFrontEnd <- renderUI({

		selectInput(
		  
		  "selectStock",
		  label = "Stocks",
		  choices = unique(stockPortfolio$Stocks[stockPortfolio$Sector %in% input$selectMarket]),
		  selected = unique(stockPortfolio$Stocks[stockPortfolio$Sector %in% input$selectMarket])[1]
		  
		)

	})

	# Update Button
	output$goButtonFrontEnd <- renderUI({
    
    	actionButton("goButton", "Go")
  	
  	})

  	# Function that pulls the stored stocks 
	pullXts <- reactive({

		input$goButton
		newStock <- isolate(input$selectManualStock)
		if (newStock != ""){

			x <- getSymbols(newStock, auto.assign = FALSE)
			
			stockList[[nrow(stockPortfolio)+1]] <- x
			stockPortfolio[nrow(stockPortfolio)+1,] <- NA
			stockPortfolio$StockTicker[nrow(stockPortfolio)] <- toupper(newStock)
			stockPortfolio$Position[nrow(stockPortfolio)] = 0
			stockPortfolio$Sector[nrow(stockPortfolio)] <- "Watchlist"
			stockPortfolio$Stocks[nrow(stockPortfolio)] <- newStock
			stockPortfolio$Index[nrow(stockPortfolio)] <- (nrow(stockPortfolio))
			write.csv(stockPortfolio, "my_stocks.csv", row.names = FALSE)

			cur_xts <- x

		} else {
			
			selectedStock <- isolate(input$selectStock)

			if (is.null(selectedStock)){
				selectedStock <- "Microsoft"
			}

			index <- stockPortfolio$Index[stockPortfolio$Stocks == selectedStock]

			cur_xts <- stockList[[index]]

		}
		

		return(cur_xts)

	})

	getFinancialAddOns <- reactive({

		input$goButton
		x <- isolate(c(input$financialGeneral, input$financialMovingAverage, input$financialIndex, input$financialOther))
		x <- x[x != ""]

		if (length(x) > 0){

		  for (i in 1:length(x)){
		    curAddOn <- x[i]
		    curAddOn <- faIndex$quantmod.Name[faIndex$Indicator == curAddOn]
		    
		    if (i == 1){
		      
		      addThis <- paste0(curAddOn, "()")
		      
		    }
		    if (i > 1){
		      
		      addThis <- paste0(addThis, ";", curAddOn, "()")
		    
		    }
		    
		  }

		} else {

		  addThis <- NA

		}

		return(addThis)

	})

	# Charting Function
	output$chart1 <- renderPlot({

		stockTicker <- pullXts()

		# Pull dates
	    d1 <- isolate(input$selectDate1)
	    d2 <- isolate(input$selectDate2)
	    d <- paste0(d1, "::", d2)

	    useD <- paste0("2018-01-01::", Sys.Date())

	    # Get Title
	    useTitle <- colnames(stockTicker)[1]
	    useTitle <- strsplit(useTitle, "\\.")
	    useTitle <- useTitle[[1]][1]

	    if (nchar(d) == 22){
	      
	      candleChart(stockTicker, subset=d, TA="addSMA(n = c(20, 50, 200))", name = useTitle)
	      
	    } else {

	    	candleChart(stockTicker, subset=useD, TA="addSMA(n = c(20, 50, 200))", name = useTitle)

	    }


	})

	output$chart2 <- renderPlot({

		stockTicker <- pullXts()

		# Pull date
	    d1 <- isolate(input$selectDate1)
	    d2 <- isolate(input$selectDate2)
	    d <- paste0(d1, "::", d2)

	    useD <- paste0("2018-01-01::", Sys.Date())

	    # Get Title
	    useTitle <- colnames(stockTicker)[1]
	    useTitle <- strsplit(useTitle, "\\.")
	    useTitle <- useTitle[[1]][1]

	    if (nchar(d) == 22) {
	      
	      chartSeries(stockTicker, TA="addVo();addBBands();addCCI()", subset=d,  name = useTitle)
	      
	    } else {

	    	chartSeries(stockTicker, TA="addVo();addBBands();addCCI()", subset=useD, name = useTitle)

	    }

	})

	output$chart3 <- renderPlot({

		input$goButton

		stockTicker <- pullXts()

		# Pull date
	    d1 <- isolate(input$selectDate1)
	    d2 <- isolate(input$selectDate2)
	    d <- paste0(d1, "::", d2)

	    useD <- paste0("2018-01-01::", Sys.Date())

	    # Get Title
	    useTitle <- colnames(stockTicker)[1]
	    useTitle <- strsplit(useTitle, "\\.")
	    useTitle <- useTitle[[1]][1]

	    stockAnalyses <- getFinancialAddOns()

		if (is.na(stockAnalyses)){
		  
		  if (nchar(d) == 22){
		    
		    chartSeries(stockTicker, subset=d, name = useTitle)
		    
		  } else {
		    
		    chartSeries(stockTicker, subset=useD, name = useTitle)
		    
		  }
		  
		} else {
		        
		  if (nchar(d) == 22) {
		    
		    chartSeries(stockTicker, subset=d,  name = useTitle, TA = stockAnalyses)
		    
		  } else {
		    
		    chartSeries(stockTicker, subset = useD, name = useTitle, TA = stockAnalyses)
		    
		  }
		  
		}

	})


})


