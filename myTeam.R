ptions("httr_oob_default" = T)
options(stringsAsFactors = FALSE)
library(tidyverse)
library(httr)
library(XML)
library(Jmisc)

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

# Game Key for NBA
vGameKey <- getData(vToken, nbaURL)$game$game_key

# League ID
vLeagueID <- ".l.17932"

# Get League Data
#teamData <- getData(vToken, paste0(teamURL,vGameKey, vLeagueID, '.t.7', '/players'))
teamData <- getData(vToken, paste0(teamURL,vGameKey, vLeagueID, '.t.7', '/roster;week=3'))
playerData <- teamData$team$roster$players[1:length(teamData$team$roster$players)-1]

players <- tibble()
for (i in 1:length(playerData)){
  
  new <- tibble(
    id   = playerData[[i]]$player_id,
    name = playerData[[i]]$name$full,
    team = playerData[[i]]$editorial_team_full_name,
    abbrev = playerData[[i]]$editorial_team_abbr
  )

  players <- bind_rows(players,new)
}

write.csv(players, 'myTeam.csv', row.names = FALSE)





# 
# 
# isNull <- FALSE
# count <- 0
# players <- tibble()
# 
# # Get Player Data
# while (isNull == FALSE){
#   
#   data <- getData(vToken, paste0(leagueURL,vGameKey, vLeagueID, '/players',';start=',count))
#   
#   isNull <- is.null(data$league$players)
#   if(!isNull){
#     
#     playerData <- data$league$players    
#     for(i in 1:(length(playerData)-1)){
#       new <- tibble(
#         id   = playerData[[i]]$player_id,
#         name = playerData[[i]]$name$full
#       )
#       players <- bind_rows(players,new)
#     }
#     
#   }
#   
#   print(count)
#   count <- count + 25
# }
# 
# zz
