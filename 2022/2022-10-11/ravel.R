# Get the Data

# Read in with tidytuesdayR package 
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2022-10-11')
tuesdata <- tidytuesdayR::tt_load(2022, week = 41)

yarn <- tuesdata$yarn

# Or read in the data manually

yarn <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-11/yarn.csv')
View(yarn)
unique(yarn$yarn_weight_name)
unique(yarn$thread_size)

library(ggplot2)


mid <- mean(yarn$yarn_weight_ply)

plot <- ggplot(yarn, aes(rating_average, yarn_weight_name, 
                 color = yarn_weight_ply))+
  geom_jitter(position = position_jitter(0.2), na.rm = TRUE, shape = 4, size = 2)+
  scale_color_gradient(low = "#AB47BC",
                       high = "#FF6D00",
                       space = "Lab",
                       na.value = "#DAF7A6")+
  theme_minimal()+
  labs(x = "The average rating out of 5",
       y = "Name for the yarn weight category",
       title = "Yarn correlation weight & rating",
       subtitle = "are they whasable?",
       caption = "Data = {ravelRy} R package by Kaylin Pavlik |
       Author: Arantxa Herranz")+
  guides(color= guide_legend("Ply for the yarn weight category"))+
  facet_wrap(~yarn$machine_washable)

library(magick)
library(cowplot)
  
ggdraw()+
  draw_image("yarn-gd59cb0833_1280.png", x = 0.4, y = 0.2, scale = .4)+
  draw_plot(plot)