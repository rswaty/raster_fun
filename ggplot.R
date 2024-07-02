

## from https://tmieno2.github.io/R-as-GIS-for-Economists/geom-raster.html

## try ggplot

library(ggthemes)
library(sf)
library(tidyverse)
library(terra)

bps_atts <- read.csv("data/bps_aoi_attributes.csv")
bps_r <- rast("data/bps_aoi.tif") %>%
  project(crs = "EPSG:5070")

shp <- st_read("data/allegheny_nf.shp") %>% 
  st_transform(crs = 5070) %>%
  st_union() %>%
  st_sf()



# convert to dataframe

bps_df <- as.data.frame(bps_r, xy = TRUE)

# facet attempt

ggplot() +
  geom_raster(data = bps_df, aes(x = x, y = y)) +
  facet_wrap(VALUE ~ .) +
  theme_void()
## got something

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

bps_df_atts_wrangled <-
  


ggplot() +
  geom_raster(data = bps_df_atts, aes(x = x, y = y)) +
  geom_sf(data = shp, fill = NA) +
  facet_wrap(BPS_NAME ~ .) + 
  theme_bw()  +
  labs(
    title = "Top Biophysical Settings",
    subtitle = "Allegheny NF",
    x = "",
    y = "",
    caption = "Represents dominant vegetation systems pre-European colonization. \n Based on LANDFIRE's Biophysical Settings.  Data available at https://www.landfire.gov/viewer. Randy Swaty, Ecologist, rswaty@tnc.org")

