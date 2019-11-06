options("httr_oob_default" = T)
options(stringsAsFactors = FALSE)

library(tidyverse)
library(data.table)
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


# Game Key for NBA
vGameKey <- getData(vToken, nbaURL)$game$game_key

# League Key
vLeagueKey <- paste0(vGameKey,".l.17932")








# Get nba schedule
nba_schedule <- as_tibble(read.csv('./data/nba-2019-EasternStandardTime.csv')) %>%
  mutate(Date = as.Date(substr(Date,1,8), '%d/%m/%y')) 

%>%
  rename(team = Home.Team, opponent = Away.Team)

# Fix team names
nba_schedule$team[nba_schedule$team == 'LA Clippers'] <- 'Los Angeles Clippers'
nba_schedule$opponent[nba_schedule$opponent == 'LA Clippers'] <- 'Los Angeles Clippers'

# Create full schedule
homeTeam <- nba_schedule %>%
  select(Date, team, opponent) %>%
  mutate(home_flag = 1)

awayTeam <- nba_schedule %>%
  select(Date, opponent, team) %>%
  rename(temp = opponent, opponent = team) %>%
  rename(team = temp) %>%
  mutate(home_flag = 0)
  
full_schedule <- bind_rows(homeTeam, awayTeam)


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
leagueData <- getData(vToken, paste0(leagueURL,vGameKey, vLeagueID))

# Create Fantasy schedule
fantasy_schedule <- tibble(week = seq(1:21)) %>%
  mutate(start_date = as.Date(leagueData$league$start_date) + (week - 1)*7) %>%
  mutate(end_date   = as.Date(leagueData$league$start_date) + (week)*7 - 1) 


# Create Fantasy schedule
fantasy_schedule <- tibble(week = seq(1:21)) %>%
  mutate(start_date = as.Date(leagueData$league$start_date) + (week - 1)*7) %>%
  mutate(end_date   = as.Date(leagueData$league$start_date) + (week)*7 - 1) 


































# Get nba schedule
nba_schedule <- as_tibble(read.csv('./data/nba-2019-EasternStandardTime.csv')) %>%
  mutate(Date = as.Date(substr(Date,1,8), '%d/%m/%y')) %>%
  mutate(home_flag = 1) %>%
  rename(team = Home.Team, opponent = Away.Team)

# Fix team names
nba_schedule$team[nba_schedule$team == 'LA Clippers'] <- 'Los Angeles Clippers'
nba_schedule$opponent[nba_schedule$opponent == 'LA Clippers'] <- 'Los Angeles Clippers'

# Build full schedule
full_schedule <- bind_rows(
  nba_schedule[, c('Date', 'team', 'opponent', 'home_flag')],
  nba_schedule[, c('Date', 'team', 'opponent')]
) %>%
  mutate(home_flag = ifelse(is.null(home_flag), 0, 1))

# Get Team info
nba_teams <- nba_teams() %>%
  filter(isNonNBATeam == 0)



temp <- left_join(nba_schedule, nba_teams, by= c('Home.Team' = 'nameTeam'))
