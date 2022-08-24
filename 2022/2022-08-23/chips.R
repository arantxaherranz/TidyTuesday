# Get the Data

# Read in with tidytuesdayR package 
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2022-08-23')
tuesdata <- tidytuesdayR::tt_load(2022, week = 34)

chips <- tuesdata$chips

# Or read in the data manually

chips <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-08-23/chips.csv')

View(chips)

total_chip <- read.csv("2022-08-23/chip_dataset.csv")

View(total_chip)
head(chips)
head(total_chip)

library(tidyverse)
library(dplyr)
library(lubridate)
library(ggplot2)

#group data by year
total_chip$Release.Date <- as.Date(total_chip$Release.Date)

total_chip$year <- year(as.Date(total_chip$Release.Date, "%y-%m-%d"))
View(total_chip)

#Plot
ggplot(chips, aes(x = year, y = process_size_nm))+
  geom_point(size)

ggplot(total_chip, aes(Release.Date, Transistors..million.))+
  geom_point(aes(color = Process.Size..nm.,
                 alpha = .1,
                 shape = Type)) +
  scale_y_log10()+
  scale_x_date(date_breaks = "1 year", date_labels = "%Y")+
  facet_wrap(~Vendor)+
  theme_light()

ggplot(total_chip, aes(year, Transistors..million.))+
  geom_point(aes(color = Process.Size..nm.,
                 alpha = .1,
                 shape = Type)) +
  scale_y_log10()+
  facet_wrap(~Vendor)+
  theme_light()

ggplot(total_chip, aes(Release.Date, Transistors..million.))+
  geom_point(aes(color = Vendor,
                 alpha = .1)) +
  scale_y_log10()+
  scale_x_date(date_breaks = "1 year", date_labels = "%Y")+
  facet_wrap(~Type)+
  theme_light()

ggplot(total_chip, aes(year, Transistors..million.))+
  geom_point(aes(color = Vendor,
                 alpha = .1,
                 size = Process.Size..nm.)) +
  scale_y_log10()+
  facet_wrap(~Type)+
  theme_light()

  
ggplot(total_chip, aes(year, Transistors..million.))+
  geom_point(aes(color = Type,
                 alpha = .3)) +
  scale_y_log10()+
  scale_x_date(date_breaks = "1 year", date_labels = "%Y")+
  facet_wrap(~Vendor)+
  theme_light()



