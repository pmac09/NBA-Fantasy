
# Create Fantasy Schedule
fantasy_schedule <- tibble(week = seq(1:21)) %>%
  mutate(start_date = leagueStartDate + (week - 1)*7) %>%
  mutate(end_date   = leagueStartDate + (week)*7 - 1) %>%
  filter(start_date <= leagueCurrentDate & end_date >= leagueCurrentDate)

gameDays <- seq.Date(fantasy_schedule$start_date[1], fantasy_schedule$end_date[1], by=1)

# Initialise variabls
tmp_players <- tibble()

for (k in 1:10){
  
  for (j in 1:length(gameDays)){
    
    rawData <- getData(vToken, paste0(teamURL,vLeagueKey, ".t.", k, '/roster;date=',gameDays[j]))
    
    # Extract players
    playerList <- rawData$team$roster$players[1:(length(rawData$team$roster$players)-1)]
    
    # Convert to dataframe
    for (i in 1:length(playerList)){
      
      new <- tibble(
        fantasy_team = rawData$team$name,
        date      = playerList[[i]]$selected_position$date,
        yahoo_id  = playerList[[i]]$player_id,
        name      = playerList[[i]]$name$full,
        initial   = substr(playerList[[i]]$name$first,1,1),
        last_name = playerList[[i]]$name$last,
        team      = playerList[[i]]$editorial_team_full_name,
        abbr      = playerList[[i]]$editorial_team_abbr,
        uniform   = as.numeric(playerList[[i]]$uniform_number),
        pos       = playerList[[i]]$display_position,
        selected  = playerList[[i]]$selected_position$position
      )
      
      tmp_players <- bind_rows(tmp_players,new) %>%
        arrange(yahoo_id)
    }
    
  }
  
  #watch progress
  print(k)
  

}



write.csv(tmp_players, './data/roster.csv', row.names = FALSE)

myTeam <- unique(tmp_players[,c('fantasy_team','yahoo_id','name','abbr','uniform','pos')]) %>%
  arrange(fantasy_team, yahoo_id)

write.csv(myTeam, './data/team.csv', row.names = FALSE)





