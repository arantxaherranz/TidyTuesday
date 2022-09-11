# Get the Data

# Read in with tidytuesdayR package 
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2022-09-06')
tuesdata <- tidytuesdayR::tt_load(2022, week = 36)

inventories <- tuesdata$inventories

# Or read in the data manually

inventory_parts <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-06/inventory_parts.csv.gz')
colours <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-06/colors.csv.gz')

View(inventory_parts)
View(colours)

library(tidyverse)
library(ggplot2)
library(dplyr)

#group by color and summarise

df2 <- inventory_parts %>%
  group_by(color_id) %>%
  summarise(total_quantity = sum(quantity))

df2 <- df2 %>%
  left_join(colours, by= c("color_id" = "id"))

#add # and create a list of colors
df2$rgb2 <- paste("#", df2$rgb, sep = "")

df2 <- df2[order(df2$total_quantity),]

list(df2$rgb)

#plot a treemap
library(treemapify)


lego_colors <- ggplot(df2, aes(area = total_quantity, fill = rgb2),
         color = rgb2)+
    geom_treemap()+
  geom_treemap_text(label= df2$name,
                    colour = "gray80",
                    place = "centre")+
  scale_fill_identity()+
  theme(legend.position = "none",
        text = element_text(family = "Clicky Bricks 3 Solid",
                            size = 14))+
  labs(title = "Most common colors in Lego")


#plot a lego mosaic

library(brickr)
library(png)


img <- tempfile()
download.file("https://1000marcas.net/wp-content/uploads/2020/01/logo-Lego.png",
              img, mode = "wb")

logo <- readPNG(img) %>%
  image_to_mosaic() %>%
  build_mosaic()

pieces_logo <- readPNG(img) %>%
  image_to_mosaic()%>%
  build_pieces()

#combine all images
install.packages("ggpubr")
library(ggpubr)

theme_set(theme_pubr())

figure <- ggarrange(
  lego_colors, # First row with line plot
  # Second row with box and dot plots
  ggarrange(logo, pieces_logo, ncol = 2,
  labels = ""),
  nrow = 2,
  labels = "") # Label of the line plot

figure

ggsave("lego_chart.jpeg", width = 18, height = 24, units = c("cm"), dpi = 300)





