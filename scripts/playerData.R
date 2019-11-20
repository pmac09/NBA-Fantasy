
# Initialise variabls
start <- 0
isNull <- FALSE
tmp_players <- tibble()

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
        initial   = substr(playerList[[i]]$name$first,1,1),
        last_name = playerList[[i]]$name$last,
        team      = playerList[[i]]$editorial_team_full_name,
        abbr      = playerList[[i]]$editorial_team_abbr,
        uniform   = as.numeric(playerList[[i]]$uniform_number),
        pos       = playerList[[i]]$display_position,
        prmy_pos  = playerList[[i]]$primary_position,
        ownership = playerList[[i]]$ownership$ownership_type
      )
      
      tmp_players <- bind_rows(tmp_players,new)
    }
  }  
  
  #Check for infinte loops
  print(start)
  
  # add to the counter
  start <- start + 25
  
}

write.csv(tmp_players, './data/players.csv', row.names = FALSE)






# # Get Team info from nabstatsR to get team id
# tmp_teams <- nba_teams() %>%
#   filter(isNonNBATeam == 0) %>%
#   select(idTeam, nameTeam, slugTeam)
# 
# # Get PLayer info from nabstatsR to get player id
# tmp_playerDetails <- seasons_players(seasons=2020) %>%
#   mutate(namePlayerFirst = trimws(namePlayerFirst)) %>%
#   select(idPlayer, namePlayer, namePlayerFirst, namePlayerLast, countSeasons)
# 
# # Get Roster info from nabstatsR to get link id
# tmp_rosters <- seasons_rosters(seasons=2020) 
# tmp_rosters2 <- tmp_rosters %>%
#   select(idPlayer, idTeam, numberJersey)
# 
# # Join all the nbastatR data
# tmp_full <- left_join(tmp_playerDetails, tmp_rosters2, by=c('idPlayer'='idPlayer'))
# tmp_full2 <- left_join(tmp_full, tmp_teams, by=c('idTeam'='idTeam'))
# 
# 
# 
# 
# tmp_fullDetails <- left_join(df_nbaPlayers, df_rosters, by=c('idPlayer'='idPlayer'))
# 
# 
# df_players <- left_join(df_players, tmp_teams, by= c('team'='nameTeam')) %>%
#   mutate(uniform = as.numeric(uniform))
# 
# 
# df_players2 <- left_join(df_players, tmp_fullDetails, by= c('last'='namePlayerLast',
#                                                             'idTeam'='idTeam',
#                                                             'uniform'='numberJersey'))
# 
# tmp <- nba_players()
# 
# 
# df_rosters %>%
#   group_by(idTeam, numberJersey) %>%
#   summarise(n = n()) %>%
#   arrange(desc(n))
# 
# df_rosters %>%
#   filter(idTeam == 1610612753 & numberJersey == 5)
