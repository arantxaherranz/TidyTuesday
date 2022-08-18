# Get the Data

# Read in with tidytuesdayR package 
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2022-08-16')
tuesdata <- tidytuesdayR::tt_load(2022, week = 33)

characters <- tuesdata$characters

# Or read in the data manually

characters <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-08-16/characters.csv')

View(characters)

library(ggplot2)

ggplot(characters, aes(name, notability))+
  geom_boxplot(aes(group = uni_name))

#find some stats
median(characters$notability)
#71.7

mean(characters$notability)
#67.62

range(characters$notability)
#18.4 96.9

# Plot
ggplot(characters, aes(x=notability, y=uni_name)) + 
  geom_point(stat=characters$notability, aes(col=notability), size=6)  +
  scale_color_manual(name="Mileage", 
                     labels = c("Above Average", "Below Average"), 
                     values = c("above"="#00ba38", "below"="#f8766d")) + 
  geom_text(color="white", size=2) +
  labs(title="Diverging Dot Plot", 
       subtitle="Normalized mileage from 'mtcars': Dotplot") + 
  ylim(-2.5, 2.5) +
  coord_flip()


#select Series

got <- characters %>% filter(characters$uni_name == "Game of Thrones")
got

mean(got$notability)
#68.19

#create a Diverge bar chart with median notability

#set the line

got$not_z_score <- round((got$notability - mean(got$notability))/sd(got$notability), digits=2)
got$median_score <- round((got$notability - mean(got$notability), digits=2)

#Creating a cut off (above/below mean)

got$not_type <- ifelse(got$not_z_score < 68.19, "below")

#order
got_order <- got[order(got$not_z_score), ] #Ascending sort on Z Score
got_order$name <- factor(got_order$name, levels = got_order$name)

library(RColorBrewer)

#creating the plot
ggplot(got_order, aes(x=name, y=not_z_score, label=not_z_score))+
  geom_bar(stat='identity', aes(fill=not_type), width=.5)+
  scale_fill_manual(name="Mileage", 
                    labels = c("Above Average", "Below Average"), 
                    values = c("above"="#00ba38", "below"="#f8766d"))+
  labs(title= "GoT characters notability: the best and the worst", 
       caption="Produced by Arantxa Herranz")+
  coord_flip()


#Diverging Lollipop Chart
ggplot(got_order, aes(x=name, y=not_z_score, label=not_z_score)) + 
  geom_point(stat='identity', fill="black", size=8, alpha = 0.9)  +
  geom_segment(aes(y = 0, 
                   x = name, 
                   yend = not_z_score, 
                   xend = name), 
               color = "black") +
  geom_text(color="white", size=2) +
  labs(title="How each GoT character diverges frome median notability", 
       caption="Source: Open-Source Psychometrics Project | Author: Arantxa Herranz",
       y = "Notability Standard Deviaton") + 
  ylim(-2.5, 2.5) +
  coord_flip()+
  theme(text = element_text(family = "Game of Thrones")) 


library(extrafont)
font_import(paths = ""
