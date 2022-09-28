# Get the Data

# Read in with tidytuesdayR package 
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2022-09-27')
tuesdata <- tidytuesdayR::tt_load(2022, week = 39)

artists <- tuesdata$artists

# Or read in the data manually

artists <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-27/artists.csv')

View(artists)
unique(artists$race)
unique(artists$type)

library(ggplot2)
library(ggridges)
library(viridis)
library(hrbrthemes)
library(showtext)
font_add_google(name = "Gochi Hand", family = "Arvos")
showtext_auto()

ggplot(artists, aes(x = artists_share, y = type, fill = ..x..))+
  geom_density_ridges_gradient(scale =3,rel_min_height = 0.01) +
  scale_fill_viridis_c(option = "H" , alpha = 0.3) +
  labs(title = '% artists in the US workforce',
       subtitle = "by type and race",
       caption = "Source: Data is Plural | Author: Arantxa Herranz") +
  theme_ipsum() +
  theme(text = element_text(family = "Gochi Hand"),
    legend.position="none",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 8)
  ) +
  facet_wrap(~race)

ggsave("artists.png")

library(dplyr)
race <- artists %>% group_by(race)%>%
  summarise(total = sum(artists_n, na.rm = TRUE))

type <- artists %>% group_by(type) %>%
  summarise(total = sum(artists_n, na.rm = TRUE))

state <- artists %>% group_by(state)%>%
  summarise(total = sum(artists_n, na.rm = TRUE))

state <- as_tibble(state)

ggplot(state, aes(state))+
  geom_bar()
