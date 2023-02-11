# Get the Data

# Read in with tidytuesdayR package 
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2023-02-07')
tuesdata <- tidytuesdayR::tt_load(2023, week = 6)

big_tech_stock_prices <- tuesdata$big_tech_stock_prices
big_tech_companies <- tuesdata$big_tech_companies

# Or read in the data manually

big_tech_stock_prices <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-02-07/big_tech_stock_prices.csv')
big_tech_companies <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-02-07/big_tech_companies.csv')

View(big_tech_companies)
View(big_tech_stock_prices)

library(ggplot2)
library(tidyverse)
library(ggthemes)
library(directlabels)
library(ggpubr)

head(big_tech_stock_prices$date)
#2010-01-04
tail(big_tech_stock_prices$date)
#2022-12-29

#set the brand color for each stock
stock_color <- c( "AAPL" = "#555555", "ADBE" = "#ED2224", 
                  "AMZN" = "#FF9900", "CRM" = "#009EDB", 
                  "CSCO" = "#00BCEB", "GOOGL" = "#4285F4", 
                  "IBM" = "#006699", "INTC" = "#0071c5", 
                  "META" = "#4267B2", "MSFT" = "#737373",
                  "NFLX" = "#E50914", "NVDA" = "#76B900", 
                  "ORCL" = "#f80000", "TSLA" = "#333333")

#WSJ style
ggplot(big_tech_stock_prices, aes(x = date, y = open,
                                  color = stock_symbol))+
  geom_line()+
  guides(color = guide_legend(title = "Stock Symbol and Color"))+
  scale_color_manual(values = stock_color)+
  coord_fixed(5)+
  ggtitle("Tech stock open")+
  theme_wsj()

#different plots for each variable (open, close, high, low)
close <- ggplot(big_tech_stock_prices, aes(x = date, y = close,
                                  color = stock_symbol))+
  geom_line(show.legend = FALSE)+
  scale_color_manual(values = stock_color)+
  coord_fixed(5)+
  ggtitle("Tech stock close")+
  geom_dl(aes(label = stock_symbol), 
          method = list(dl.combine("first.points", "last.points")), 
          cex = 0.8)+
  theme_solarized()

open <- ggplot(big_tech_stock_prices, aes(x = date, y = open,
                                  color = stock_symbol))+
  geom_line(show.legend = FALSE)+
  scale_color_manual(values = stock_color)+
  coord_fixed(5)+
  ggtitle("Tech stock open")+
  geom_dl(aes(label = stock_symbol), 
          method = list(dl.combine("first.points", "last.points")), 
          cex = 0.8)+
  theme_solarized()

high <- ggplot(big_tech_stock_prices, aes(x = date, y = high,
                                           color = stock_symbol))+
  geom_line(show.legend = FALSE)+
  scale_color_manual(values = stock_color)+
  coord_fixed(5)+
  ggtitle("Tech stock high")+
  geom_dl(aes(label = stock_symbol), 
          method = list(dl.combine("first.points", "last.points")), 
          cex = 0.8)+
  theme_solarized()

low <- ggplot(big_tech_stock_prices, aes(x = date, y = low,
                                           color = stock_symbol))+
  geom_line(show.legend = FALSE)+
  scale_color_manual(values = stock_color)+
  coord_fixed(5)+
  ggtitle("Tech stock low")+
  geom_dl(aes(label = stock_symbol), 
          method = list(dl.combine("first.points", "last.points")), 
          cex = 0.8)+
  theme_solarized()

#combine 4 plots
figure <- ggarrange(open, close, high, low,
          ncol = 2, nrow = 2)

figure

