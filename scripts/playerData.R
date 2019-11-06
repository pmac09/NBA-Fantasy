
# Initialise variabls
start <- 0
isNull <- FALSE
playerData <- tibble()

while (!isNull){
  
  #Get raw data
  rawData <- getData(vToken, paste0(leagueURL,vLeagueKey, '/players;start=', start,'/ownership'))
  
  # Check for data
  isNull <- is.null(rawData$league$players)
  
  #if there is data
  if(!isNull){
    
    # Extract players
    playerList <- rawData$league$players[1:(length(rawData$league$players)-1)]
    
    # Convert to dataframe
    for (i in 1:length(playerList)){
      
      new <- tibble(
        yahoo_id  = playerList[[i]]$player_id,
        name      = playerList[[i]]$name$full,
        team      = playerList[[i]]$editorial_team_full_name,
        abbr      = playerList[[i]]$editorial_team_abbr,
        uniform   = playerList[[i]]$uniform_number,
        pos       = playerList[[i]]$display_position,
        prmy_pos  = playerList[[i]]$primary_position,
        ownership = playerList[[i]]$ownership$ownership_type
      )
      
      playerData <- bind_rows(playerData,new)
    }
  }  
  
  #Check for infinte loops
  print(start)
  
  # add to the counter
  start <- start + 25
  
}












teamData <- getData(vToken, paste0(teamURL,vGameKey, vLeagueID, '.t.7', '/roster;week=3'))



playerData <- teamData$team$roster$players[1:length(teamData$team$roster$players)-1]



schedule <- seasons_schedule(seasons = 2020)

weekStarting <- '2019-11-04'
current_week <- schedule %>%
  filter(dateGame >= weekStarting) %>%
  filter(dateGame <  as.Date(weekStarting)+7)

playerStats <- box_scores(game_ids = current_week$idGame,
                          box_score_types = 'Traditional',
                          result_types = 'player')

data <- playerStats$dataBoxScore[[1]]

write.csv(data, 'weeklyStats.csv', row.names = FALSE)
