library(shiny)
library(Jmisc)
library(httr)
library(XML)
library(tidyverse)

## GLOBAL ----
sourceAll('./functions')


## UI ----
ui <- fluidPage(
   
   # Application title
   titlePanel("NBA Fantasy Team Manager"),
   
   sidebarLayout(
      sidebarPanel(
         
        actionButton(inputId= 'btnConnect', label= 'Connect'),
        actionButton(inputId = 'btnGetData', label= 'Get Data')
        
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         textOutput('txtGameKey')
      )
   )
)

## SERVER ----
server <- function(input, output) {
   
  ## REACTIVE VALUES ----
  rv <- reactiveValues(
  #rv <- list(    
    auth = list(key = cKey,
                secret = cSecret,
                password = cPassword,
                connection = NULL,
                passcode = NULL,
                token = NULL),
    
    url = list(nba    = 'https://fantasysports.yahooapis.com/fantasy/v2/game/nba',
               league = 'https://fantasysports.yahooapis.com/fantasy/v2/league/',
               team   = 'https://fantasysports.yahooapis.com/fantasy/v2/team/',
               player = 'https://fantasysports.yahooapis.com/fantasy/v2/player/')
  )
  
  ## OBSERVES ----
  observeEvent(input$btnConnect,{
    rv$auth$connection <- authRequest(rv$auth$key, rv$auth$secret)
    showModal(authModal(rv$auth))
  }) # Connect Button 
  observeEvent(input$btnAuthConnect,{
    rv$auth$passcode <- input$txtPasscode
    removeModal()
    if(input$txtPassword == rv$auth$password){
      rv$auth$token <- authConnect(rv$auth$connection, rv$auth$passcode)
    }
  }) # authModal Connect Button

  ## FUNCTIONS ----
  gameKey_r <- reactive({
    if(is.null(rv$auth$token)){
      vGameKey <- NULL
    } else {
      vGameKey <- getData(rv$auth$token, rv$url$nba)$game$game_key
    }
    return(vGameKey)
  })
  leagueKey_r <- reactive({
    vGameKey <- gameKey_r()
    if(is.null(vGameKey)){
      vLeagueKey <- NULL
    } else {
      vLeagueKey <- paste0(vGameKey,".l.17932")
    }
    return(vLeagueKey)
  })
  
  ## OUTPUTS ----
  output$txtGameKey <- renderText({
    paste0('Game Key: ', gameKey_r())
    paste0('League Key: ', leagueKey_r())
  })
  
}

## RUN ----
shinyApp(ui = ui, server = server)

