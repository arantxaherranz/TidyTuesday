# Get the Data

# Read in with tidytuesdayR package 
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2022-08-30')
tuesdata <- tidytuesdayR::tt_load(2022, week = 35)

pell <- tuesdata$pell

# Or read in the data manually

pell <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-08-30/pell.csv')

View(pell)

#group by state
library(dplyr)

by_state <- pell %>%
  group_by(STATE, YEAR) %>%
  summarise(prize = sum(AWARD))

View(by_state)

library(ggplot2) 
library(usmap)
library(maps)

#change abbreviate by name
by_state$STATE <- state.name[match(by_state$STATE, state.abb)]

#change the name of the colum 
colnames(by_state)[1] <- "state"

#load US state map data
us_states <- map_data("state")
View(us_states)

#plot
plot_usmap(data = by_state, values = "prize", color = "grey80") + 
  scale_fill_gradient(low = "purple", high = "orange", 
                      name = "Awards") + 
  labs(title = "Pell Awards", subtitle = "by year and state",
       alt = "US map chart with pell awards by state and year",
       caption = "Data: US Department of Education") +
  theme(legend.position = "right") +
  facet_wrap(~YEAR) +
  ggsave("2022-08-30/pell_award.jpeg", 
         width = 18, height = 24}, units = "cm")





