options(stringsAsFactors = FALSE)
library(tidyverse)
library(nbastatR)

# source all functions
sourceAll('./functions')

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
