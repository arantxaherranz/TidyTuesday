```{r}

# Get the Data

# Read in with tidytuesdayR package 
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!
install.packages("tidytuesdayR")

tuesdata <- tidytuesdayR::tt_load('2022-08-09')
tuesdata <- tidytuesdayR::tt_load(2022, week = 32)

wheels <- tuesdata$wheels

# Or read in the data manually

wheels <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-08-09/wheels.csv')

View(wheels)

library(ggplot2)
library(showtext)
font_add(family = "VTKS Storm Font", regular = "https://www.1001freefonts.com/vtks-storm-2.font")
showtext_auto()

ggplot(wheels, aes(country, height))+
  geom_point(aes(size = number_of_cabins, colour = status, alpha = 0.7))+
  theme(axis.text.x = element_text(angle = 60))+
  labs(title = "Ain't no Ferris Wheels high enough",
        subtitle = "Countries with the highest Ferris Wheels and its status",
       caption = "#TidyTuesday week 32, data from {ferriswheels} package by Emil Hvitfeldt 
             | Author: Arantxa Herranz", x = "")

ggplot(wheels, aes(country, height))+
  geom_point(
    mapping = aes(fill = status, size = number_of_cabins, size = number_of_cabin),
    color = "white",
    stroke = 3,
    shape = 21,
    size = 4,
    alpha = 0.7,
  )  

