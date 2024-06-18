

aoi <- vect("data/allegheny_nf.shp")


output_rasters_dir <- "output_rasters/"
raster_files <- list.files(output_rasters_dir, pattern = "\\.tif$", full.names = TRUE)



# Select one of the top 10 unique ecosystems (e.g., the first one)
selected_ecosystem <- top_10_ecosystems[1]

# Create a data frame for plotting
plot_data <- as.data.frame(ecosystem_rasters[[selected_ecosystem]])

# Create the plot using ggplot2
ggplot(plot_data, aes(x = x, y = y, fill = value)) +
  geom_raster() +
  geom_sf(data = state_boundaries, fill = NA, color = "black") +  # Add state boundaries
  scale_fill_viridis_c() +
  theme_void()
