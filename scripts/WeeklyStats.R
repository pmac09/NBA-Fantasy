
schedule <- seasons_schedule(seasons = 2020)

weekStarting <- '2019-11-11'
current_week <- schedule %>%
  filter(dateGame >= weekStarting) %>%
  filter(dateGame <  as.Date(weekStarting)+7)

tmp <- c(21900110,21900111)

playerStats <- box_scores(game_ids = tmp, #current_week$idGame,
                          box_score_types = 'Traditional',
                          result_types = 'player')

data <- playerStats$dataBoxScore[[1]]

write.csv(data, 'box_scores.csv', row.names = FALSE)
