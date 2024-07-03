

## from https://tmieno2.github.io/R-as-GIS-for-Economists/geom-raster.html

## try ggplot

library(ggspatial)
library(maps)
library(sf)
library(tidyverse)
library(terra)

bps_atts <- read.csv("data/bps_aoi_attributes.csv")
bps_r <- rast("data/bps_aoi.tif") 

shp <- st_read("data/allegheny_nf.shp") %>% 
  st_transform(crs = 5070) %>%
  st_union() %>%
  st_sf()

# try to limit map when adding states
bounding_box <- sf::st_bbox(shp)
xmin <- bounding_box[1]
xmax <- bounding_box[3]
ymin <- bounding_box[2]
ymax <- bounding_box[4]

states <- st_read("data/cb_2018_us_state_500k (1)/cb_2018_us_state_500k.shp") %>% 
  st_transform(crs = 5070) %>%
  st_union() %>%
  st_sf()



# convert to dataframe

bps_df <- as.data.frame(bps_r, xy = TRUE)

# try a little wrangling and other work

geographies <- c(
  "Appalachian ",
  "Boreal",
  "Central Interior and Appalachian ",
  "Central Appalachian ",
  "Laurentian ",
  "Laurentian-Acadian ",
  "North-Central Interior ",
  "South-Central Interior ")

bps_atts$BPS_NAME <- gsub(paste(geographies, collapse = "|"), "", bps_atts$BPS_NAME)

bps_df_atts <- left_join(bps_df, bps_atts) 

top_bpss <- bps_df_atts %>%
  group_by(BPS_NAME) %>%
  summarize(mean_percent = mean(REL_PERCENT)) %>%
  arrange(desc(mean_percent)) %>%
  filter(mean_percent > 5)

top_bpss <- top_bpss$BPS_NAME

# crete final dataframe to map
bpss_to_map <- bps_df_atts %>%
  filter(BPS_NAME %in% top_bpss)

ggplot() +
  geom_raster(data = bpss_to_map, aes(x = x, y = y)) +
  geom_sf(data = shp, fill = NA) +
  facet_wrap(BPS_NAME ~ .) + 
  theme_bw()  +
  labs(
    title = "Top Biophysical Settings",
    subtitle = "Allegheny NF",
    x = "",
    y = "",
    caption = "Represents dominant vegetation systems pre-European colonization. \n Based on LANDFIRE's Biophysical Settings.  Data available at https://www.landfire.gov/viewer. Randy Swaty, Ecologist, rswaty@tnc.org") + 
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank()) +
  annotation_scale(unit_category = 'imperial',
                   style = 'ticks') 

