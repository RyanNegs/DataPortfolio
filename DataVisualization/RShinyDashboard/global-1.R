#import data and libraries

library(shiny)
library(shinydashboard)
library(tidyverse)
library(data.table)

ponies_raw <- readr:: read_csv("2019_Saratoga_Juveniles.csv", col_names = TRUE)
ponies <- readr::read_csv("ponies_tidy.csv", col_names = TRUE)

drops <- c("...1")
ponies <- ponies[, !(names(ponies) %in% drops)]
ponies$DATE <- as.Date(ponies$DATE, format = "%m/%d/%y")

ponies$W_P_S <- with(ponies, ifelse(FIN <= 3, 'Yes', 'No'))


choices <- names(ponies)
cat_choices <- ponies %>% 
  purrr:: discard(is.numeric) %>%
  purrr:: discard(lubridate::is.Date) %>%
  names()
  
cont_choices <- ponies%>% purrr:: keep(is.numeric) %>% names()

results_list <- c("DATE", "RACE","FIN","PP", "STARTER NAME","ODDS", "JOCKEY", "TIME", "TRAINER" )

results_df <- ponies[,names(ponies) %in% results_list]

race_info_list <- c("DATE", "RACE", "SURF", "DIST", "CLASS")
race_info_df <- ponies[, names(ponies) %in% race_info_list]
race_numbers <- ponies$RACE %>% unique() %>% sort()
stats_list <- c("DATE", "RACE", "JOCKEY", "STARTER NAME", "SURF", "DIST", "TIME_seconds", "FIN", "ODDS")
stats_df <- ponies[, names(ponies) %in% stats_list]

surfaces <- ponies$SURF %>% unique() 
distances <- ponies$DIST %>% unique()

#creating groups for stats

top_two_df <- 
  stats_df %>%
  filter(FIN <= 2) %>%
  select(RACE, DATE, DIST, TIME_seconds)
place_groups <- top_two_df %>%
  group_by(DATE,RACE)
print(place_groups)

margin_victory <- place_groups %>% 
  mutate(won_by = TIME_seconds[] - TIME_seconds[+1])
average_margin <- margin_victory %>% 
  summarise(avg_marg = mean(won_by))
avg_marg_stat <- mean(average_margin$avg_marg, ) %>% round(digits = 3)

horse_df <- stats_df %>%
  group_by(`STARTER NAME`,FIN) %>%
  select(`STARTER NAME`, FIN) %>%
  tally(sort = TRUE)


best_horse_df <-
  horse_df %>%
  ungroup(`STARTER NAME`) %>%
  arrange(FIN)

top_horse_list <- c(best_horse_df$`STARTER NAME`[1:5])

top_earners <- stats_df[stats_df$`STARTER NAME` %in% top_horse_list,]
by_odds <- top_earners %>% arrange(desc(ODDS))

total_distance <- sum(ponies$DIST)
in_miles <- total_distance / 8 %>% round(digits = 2)



jockey_tab_list <- c("JOCKEY", "ODDS", "TIME", "FIN", "Money_Won_10_usd", "SURF", "DIST")
jockey_df <- ponies[, names(ponies) %in% jockey_tab_list]


by_jockey <-
  jockey_df %>% group_by(JOCKEY) 

by_jockey$W_P_S <- with(by_jockey, ifelse(FIN <= 3, 'Yes', 'No'))

jockey_by_win <- jockey_df %>% 
  arrange(FIN)

trainer_names <- ponies$TRAINER %>% unique() %>% sort()


trainer_tab_list <- c("TRAINER","STARTER NAME", "ODDS","FIN", "Money_Won_10_usd", "SURF", "DIST")
trainer_df <- ponies[, names(ponies) %in% trainer_tab_list]


by_trainer <-
  trainer_df %>% group_by(TRAINER) 

trainer_by_win <- trainer_df %>% 
  arrange(FIN)

jockey_names <- ponies$JOCKEY %>% unique() %>% sort()













