

## try terra:segregate

library(terra)
library(tidyverse)


# read in BpS raster
bps_raster <- rast("multiple_single_maps/data/bps_aoi.tif")


# try segregate with defaults

segretated <- segregate(bps_raster)

plot(bps_raster)

# it's a start!

# try to get to bps names for maps

# get some meaningful info to the raster

bps_names<- read.csv(file = "multiple_single_maps/data/bps_aoi_attributes.csv") %>%
  select(c(VALUE,
           BPS_NAME))
  
# set active categories
levels(bps_raster) <- bps_names
activeCat(bps_raster) <- 'BPS_NAME'

plot(bps_raster)

# can you now segregate based on BPS_NAME?  Unlikely, but here goes
bps_name_segregate <- segregate(bps_raster)

plot(bps_name_segregate)

bps_name_segregate
