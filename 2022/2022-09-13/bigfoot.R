# Get the Data

# Read in with tidytuesdayR package 
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2022-09-13')
tuesdata <- tidytuesdayR::tt_load(2022, week = 37)

bigfoot <- tuesdata$bigfoot

# Or read in the data manually

bigfoot <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-13/bigfoot.csv')

View(bigfoot)

library(ggplot2)
library(GGally)


#create a new dataframe

bigfoot_clean <- na.omit(bigfoot)
View(bigfoot_clean)

bigfoot2 <- bigfoot[, c("season", "temperature_mid", "humidity", "cloud_cover", "precip_type", "uv_index", "visibility", "wind_speed")]
View(bigfoot2)

bigfoot2_clean <- na.omit(bigfoot2)
View(bigfoot2_clean)

#correlations between variables

ggpairs(bigfoot2_clean,
        columns = 2:8,
        aes(color = season,
            alpha = 0.5),
        upper = list(continuous = wrap("cor", size = 2.5)),
        lower = list(continuous = "smooth")
)

#convert date

library(tidyr)

bigfoot_clean_date <- bigfoot_clean %>%
  separate(date, sep="-", into = c("year", "month", "day"))

View(bigfoot_clean_date)

#plot map 
library(mapdata)

usa <- map_data("usa")

ggplot() +
  geom_polygon(data = usa,
               aes(x = long, y = lat, group = group)) +
  coord_quickmap()+
  geom_point(data = bigfoot_clean_date,
             aes(x = longitude, y = latitude,
                 color = season))+
  scale_color_manual(values = c("Fall" = "brown", "Spring" = "green", "Summer" = "yellow", "Winter" = "grey"))+
  theme_void()+
  labs(title = "Bigfoot observations along years and season")+
  facet_wrap(~year)


ggsave("bigfoot.jpeg",
       path = "2022-09-13/",
       width = 18,
       height = 24,
       units = c("cm"),
       dpi = 300)
