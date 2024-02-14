

# NOTES -----
# Importing LANDFIRE data via the rlandfire package, then trying to make acceptable maps
# Randy Swaty
# February 2024
# using git large file storage to commit and push large files


# Dependencies -----

# install.packages("devtools")
# devtools::install_github("bcknr/rlandfire")
# install.packages('sf')
# install.packages('terra')

# load packages

library(rlandfire)
library(sf)
library(terra)
library(tidyverse)

# download LANDFIRE EVT, EVC and EVH data via rlandfire -----

# read in and look at boundary (WUMO)

boundary <- st_read(file.path("inputs/wumo.shp")) %>% 
  sf::st_transform(crs = st_crs(5070))

plot(boundary$geometry, main = "Wasatch and Uinta Mountains Subregion (WUMO)", 
     border = "red", lwd = 1.5)


# get AOI extent (kind of large for this test!)

aoi <- getAOI(boundary, extend = 1000)
aoi
# AOI -> -114.87982   37.18775 -108.67846   42.88945

# define products
# viewProducts()
products <- c("230EVC", "230EVH", "230EVT")

# set file path (I don't really understand this)
path <- tempfile(fileext = ".zip")


# call in data (began at 8:19am ET, completed by ,with 80 mb download speed)
##  STOPPED WILL USE SMALLER AREA
lf_call <- landfireAPI(products = products,
                    aoi = aoi, 
                    path = path,
                    verbose = FALSE) # wished I had said TRUE so I could get info





