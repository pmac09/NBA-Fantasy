options("httr_oob_default" = T)
options(stringsAsFactors = FALSE)

library(tidyverse)
library(httr)
library(XML)
library(Jmisc)
library(nbastatR)

# source all functions
sourceAll('./functions')

# Create yahoo login token
vToken <- getToken(cKey, cSecret)

## API DOCUMENTATION 
# https://developer.yahoo.com/fantasysports/guide/league-resource.html

# API base URLs
nbaURL    <- paste0('https://fantasysports.yahooapis.com/fantasy/v2/game/nba')
leagueURL <- paste0("https://fantasysports.yahooapis.com/fantasy/v2/league/")
teamURL   <- paste0("https://fantasysports.yahooapis.com/fantasy/v2/team/")
playerURL <- paste0("https://fantasysports.yahooapis.com/fantasy/v2/player/")

# Keys for NBA
vGameKey <- getData(vToken, nbaURL)$game$game_key
vLeagueKey <- paste0(vGameKey,".l.17932")
vTeamKey <- paste0(vLeagueKey, ".t.7")

# Get League Info
rawData <- getData(vToken, paste0(leagueURL,vLeagueKey))

leagueStartDate <- as.Date(rawData$league$start_date) -1
leagueCurrentDate <- as.Date(rawData$league$edit_key)

# Get players
source('./scripts/playerData.R')

# Get my team
source('./scripts/teamData.R')

