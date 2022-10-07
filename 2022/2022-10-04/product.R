# Get the Data

# Read in with tidytuesdayR package 
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2022-10-04')
tuesdata <- tidytuesdayR::tt_load(2022, week = 40)

product_hunt <- tuesdata$product_hunt

# Or read in the data manually

product_hunt <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-04/product_hunt.csv')
View(product_hunt)

#split category_tags column in multiple, one per category
library(dplyr)
library(tidyr)
library(stringr)

product_hunt[c("cat1", "cat2", "cat3", "cat4", "cat5", "cat6", 
               "cat7", "cat8", "cat9", "cat10", "cat11", "cat12",
               "cat13", "cat14", "cat15", "cat16", "cat17", "cat18",
               "cat19", "cat20")] <- str_split_fixed(product_hunt$category_tags, ',', 20)

View(product_hunt)
unique(product_hunt$upvotes)

#group data by year
library(lubridate)
product_hunt$release_date <- as.Date(product_hunt$release_date)

product_hunt$year <- year(as.Date(product_hunt$release_date, "%y-%m-%d"))

#group data by update
product_hunt$last_updated <- as.Date(product_hunt$last_updated)

product_hunt$update_year <- year(as.Date(product_hunt$last_updated, "%y-%m-%d"))
unique(product_hunt$update_year)

library(ggplot2)
library(hrbrthemes)
library(ggdark)

ggplot(product_hunt, aes(year, upvotes, color = update_year))+
  geom_point()

#create social media platforms data

snapchat <- product_hunt %>% 
  filter(str_detect(category_tags, "SNAPCHAT")) %>%
  mutate(category_tags = str_replace_all(category_tags, "\\[", "")) %>% 
  mutate(category_tags = str_replace_all(category_tags, "\\]", "")) %>% 
  mutate(category_tags = str_replace_all(category_tags, "'", "")) %>% 
  mutate(category_tags = as.vector(str_split(category_tags, ",")))

linkedin <- product_hunt %>% 
  filter(str_detect(category_tags, "LINKEDIN")) %>% 
  mutate(category_tags = str_replace_all(category_tags, "\\[", "")) %>% 
  mutate(category_tags = str_replace_all(category_tags, "\\]", "")) %>% 
  mutate(category_tags = str_replace_all(category_tags, "'", "")) %>% 
  mutate(category_tags = as.vector(str_split(category_tags, ",")))

twitter <- product_hunt %>% 
  filter(str_detect(category_tags, "TWITTER")) %>% 
  mutate(category_tags = str_replace_all(category_tags, "\\[", "")) %>% 
  mutate(category_tags = str_replace_all(category_tags, "\\]", "")) %>% 
  mutate(category_tags = str_replace_all(category_tags, "'", "")) %>% 
  mutate(category_tags = as.vector(str_split(category_tags, ",")))

facebook <- product_hunt %>% 
  filter(str_detect(category_tags, "FACEBOOK")) %>% 
  mutate(category_tags = str_replace_all(category_tags, "\\[", "")) %>% 
  mutate(category_tags = str_replace_all(category_tags, "\\]", "")) %>% 
  mutate(category_tags = str_replace_all(category_tags, "'", "")) %>% 
  mutate(category_tags = as.vector(str_split(category_tags, ",")))

mid<-mean(product_hunt$update_year)

snap <- ggplot(snapchat, aes(year, upvotes, color = update_year, 
                     size = product_ranking))+
  geom_jitter(alpha = .6)+
  scale_color_gradient2(midpoint=mid, low="orange", mid="purple",
                         high="pink", space ="Lab" )+
  dark_theme_light()+
  xlab("Year")+
  ylab("Votes")+
  labs(title="Votes for Snapchat products",
       subtitle = "Product ranking and last updated date",
       caption = "Data: components.one | Author: Arantxa Herranz",
       color= "Update year", size = "Product Ranking")
  
  
lid <- ggplot(linkedin, aes(year, upvotes, color = update_year, 
                     size = product_ranking))+
  geom_jitter(alpha = .6)+
  scale_color_gradient2(midpoint=mid, low="orange", mid="purple",
                        high="pink", space ="Lab" )+
  dark_theme_light()+
  xlab("Year")+
  ylab("Votes")+
  labs(title="Votes for Linkedin products",
       subtitle = "Product ranking and last updated date",
       caption = "Data: components.one | Author: Arantxa Herranz",
       color= "Update year", size = "Product Ranking")

twi <- ggplot(twitter, aes(year, upvotes, color = update_year, 
                    size = product_ranking))+
  geom_jitter(alpha = .6)+
  scale_color_gradient2(midpoint=mid, low="orange", mid="purple",
                        high="pink", space ="Lab" )+
  dark_theme_light()+
  xlab("Year")+
  ylab("Votes")+
  labs(title="Votes for Twitter products",
       subtitle = "Product ranking and last updated date",
       caption = "Data: components.one | Author: Arantxa Herranz",
       color= "Update year", size = "Product Ranking")

fb <- ggplot(facebook, aes(year, upvotes, color = update_year, 
                     size = product_ranking))+
  geom_jitter(alpha = .6)+
  scale_color_gradient2(midpoint=mid, low="orange", mid="purple",
                        high="pink", space ="Lab" )+
  dark_theme_light()+
  xlab("Year")+
  ylab("Votes")+
  labs(title="Votes for Facebook products",
       subtitle = "Product ranking and last updated date",
       caption = "Data: components.one | Author: Arantxa Herranz",
       color= "Update year", size = "Product Ranking")

#create a simple plage with several graphs
library(ggpubr)
library(ggdraw)

figure <- ggarrange(snap, lid, twi, fb + rremove("x.text"), 
          ncol = 2, nrow = 2,
          common.legend = TRUE, legend = "right")
cowplot::ggdraw(figure)+
  theme(plot.background = element_rect(fill = "black", color = NA))

annotate_figure(figure,
                top = text_grob("Votes for social media products", color = "white", face = "bold", size = 14),
                bottom = text_grob("Data: components.one | Author: Arantxa Herranz", color = "white",
                                   hjust = 1, x = 1, face = "italic", size = 10),
                left = text_grob("Votes", color = "white", rot = 90)+
                  bgcolor("black")
                )
cowplot::ggdraw(figure)+
  theme(plot.background = element_rect(fill = "black", color = NA),
        plot.title = element_text("Votes for social media products", color = "white", face = "bold", size = 14),
        plot.caption = element_text("Data: components.one | Author: Arantxa Herranz", color = "white"),
        legend.title = element_text("Votes", color = "white"))
