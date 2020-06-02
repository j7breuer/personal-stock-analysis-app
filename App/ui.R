
#----------#
# Start UI #
#----------#

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

shinyUI(
  
  dashboardPage(
    
    dashboardHeader(title = "Mini Portfolio Analysis Tool"),
      
      dashboardSidebar(
        
        sidebarMenu(
          
          menuItem(
            
            "Select Stocks",
            tabName = "stocksPanel",
            icon = icon("usd"),
            
            menuSubItem(icon = NULL,
                        
                        selectInput(
                          
                          "selectMarket",
                          label = "Markets",
                          choices = unique(stockPortfolio$Sector),
                          selected = "Tech"
                          
                        )
                        
                        ),
            
            menuSubItem(icon = NULL,
                        
                        uiOutput(
                          "selectStocksFrontEnd"
                        )
                        
            ),
                                   
            menuSubItem(icon = NULL,
                        
                        textInput(
                          
                          "selectManualStock",
                          label = "Search Stock Ticker",
                          value = ""
                          
                        )
                        
            )
            
          ),

          menuItem(
            
            "Select Dates",
            tabName = "datePanel",
            icon = icon("calendar"),
                                  
            menuSubItem(icon = NULL,
                        
                        textInput(
                          
                          "selectDate1",
                          label = "Select Start Date",
                          value = "2018-01-01"
                          
                        )
                        
            ),
            
            menuSubItem(icon = NULL,
                        
                        textInput(
                          
                          "selectDate2",
                          label = "Select End Date",
                          value = Sys.Date()
                          
                        )
                        
            )
            
          ),
          
          menuItem(

            "General Analyses",
            tabName = "GenearlFinancialAddons",
            icon = icon("signal"),

            menuSubItem(icon = NULL,

                        checkboxGroupInput(

                          "financialGeneral",
                          label = NA,
                          choices = c(faIndex$Indicator[faIndex$Group == "General"]),
                          selected = ""

                        )

            )

          ),

          menuItem(

            "Moving Average Analyses",
            tabName = "MovingAverageAddons",
            icon = icon('signal'),
            
            menuSubItem(icon = NULL,

                        checkboxGroupInput(

                          "financialMovingAverage",
                          label = NA,
                          choices = c(faIndex$Indicator[faIndex$Group == "Moving Average"]),
                          selected = ""

                        )

            )

          ),

          menuItem(

            "Index Analyses",
            tabName = "IndicesAddons",
            icon = icon('signal'),
            
            menuSubItem(icon = NULL,

                        checkboxGroupInput(

                          "financialIndex",
                          label = NA,
                          choices = c(faIndex$Indicator[faIndex$Group == "Index"]),
                          selected = ""

                        )

            )

          ),

          menuItem(

            "Other Analyses",
            tabName = "OtherAddons",
            icon = icon('signal'),
            
            menuSubItem(icon = NULL,

                        checkboxGroupInput(

                          "financialOther",
                          label = NA,
                          choices = c(faIndex$Indicator[faIndex$Group == "Other"]),
                          selected = ""

                        )

            )

          ),
                    
          br(),
          
          uiOutput(
            "goButtonFrontEnd"
          )
          
        )
        
      ),
    
    dashboardBody(
      tags$style(type="text/css",
                 ".shiny-output-error { visibility: hidden; }",
                 ".shiny-output-error:before { visibility: hidden; }"
      ),

      shinyDashboardThemes(
        theme = "grey_dark"
      ),
      
      tabsetPanel(
        
       
        
        tabPanel(
          
          "Time-Series Analysis",
          
          fluidPage(
            
            fluidRow(
              
              column(6,
                
                fluidRow(
                  br(),
                  box(
                    status = "info",
                    width = 12,
                    plotOutput("chart1")
                  )
                  
                )
              ),
              
              column(6,
                
                fluidRow(
                  br(),
                  box(
                    status = "info",
                    width = 12,
                    plotOutput("chart2")
                  )
                  
                )
                
              )
              
            )
            
          )
          
        ),
        
        tabPanel(
          
          "Technical Financial Analysis",
          
          fluidPage(
            
            fluidRow(
              br(),
              # Enter shit here
              box(
                
                status = "info",
                width = 12,
                plotOutput("chart3")
                
              )
              
            )
            
          )
          
        )
        
      )
      
    )
    
  )
  
)

















