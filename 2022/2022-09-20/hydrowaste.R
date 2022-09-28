# Get the Data

# Read in with tidytuesdayR package 
# Install from CRAN via: install.packages("tidytuesdayR")
# This loads the readme and all the datasets for the week of interest

# Either ISO-8601 date or year/week works!

tuesdata <- tidytuesdayR::tt_load('2022-09-20')
tuesdata <- tidytuesdayR::tt_load(2022, week = 38)

HydroWASTE_v10 <- tuesdata$HydroWASTE_v10

# Or read in the data manually

HydroWASTE_v10 <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-09-20/HydroWASTE_v10.csv')

head(HydroWASTE_v10)

View(HydroWASTE_v10)

library(ggplot2)
ggplot(HydroWASTE_v10)+
  geom_point(aes(POP_SERVED, WASTE_DIS))

library(dplyr)

spain_hydro <- HydroWASTE_v10 %>%
  filter(COUNTRY == "Spain")

ggplot(spain_hydro)+
  geom_polygon(aes(LON_WWTP, LAT_WWTP))

#Spain
View(spain_hydro)
library(mapSpain)

spain_prov <- esp_get_prov()
spain_mun <- esp_get_munic()
View(spain_mun)

#change the name of a column to make an inner join
colnames(spain_hydro)[4] <- "name"

spain_mun$name <- toupper(spain_mun$name)

waste_spain <- merge(spain_hydro, spain_mun, by = "name", all.x=FALSE, all.y=FALSE)
View(waste_spain)

ggplot(spain_prov)+
  geom_sf()

head(waste_spain)

ggplot(spain_mun)+
  geom_sf()

ggplot(waste_spain)+
  geom_polygon(waste_spain$geometry)

library(tmap)

tm_shape(esp)+
  tm_borders()

#download shape data from https://www.diva-gis.org/gdata
library(sf)
spain <- st_read("ESP_adm/ESP_adm2.shp")
spain_river <- st_read("ESP_wat/ESP_water_areas_dcw.shp")

tm_shape(spain) +
  tm_borders("grey", lwd = 1.25) +
  tm_shape(spain_river) + 
  tm_fill("blue", title.col="water bodies") +
  tm_add_legend('Lake', 
                type = "fill",
                col = "blue",
                border.col = "blue",
                title = "Lake") 

base_map <- ggplot(spain)+
  geom_sf()+
  coord_sf()

base_map+
  geom_sf(data = waste_spain, mapping = aes(LAT_WWTP, LON_WWTP))+
  coord_sf()

ggplot(waste_spain)+
  geom_point(aes(LAT_WWTP, LON_WWTP))

ggplot(waste_spain)+
  geom_point(aes(LAT_WWTP, LON_WWTP))

ggplot(waste_spain)+
  geom_map(waste_spain, aes(map= "name", map_id = ine.prov.name)+
             expand_limits(x= waste_spain$LON_WWTP, y =waste_spain$LAT_WWTP)

