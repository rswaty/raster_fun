

# Load the necessary libraries
library(terra)
library(ggplot2)

# Load your ecosystem raster data (replace "path/to/your/ecosystem_raster.tif" with the actual path)
ecosystem_raster <- rast("data/bps_aoi.tif")

# Load the state boundaries shapefile (replace "path/to/your/state_boundaries.shp" with the actual path)
state_boundaries <- vect("data/allegheny_nf.shp")

# Calculate the frequency counts of unique ecosystems
ecosystem_counts <- table(ecosystem_raster[])

# Sort the ecosystems by count in descending order
sorted_ecosystems <- sort(ecosystem_counts, decreasing = TRUE)

# Select the top 10 unique ecosystems
top_10_ecosystems <- names(sorted_ecosystems)[1:10]

# Create separate rasters for each of the top 10 ecosystems
ecosystem_rasters <- list()
for (ecosystem_value in top_10_ecosystems) {
  ecosystem_rasters[[ecosystem_value]] <- ecosystem_raster * (ecosystem_raster[] == ecosystem_value)
}

# Optional: Save the separate rasters
output_dir <- "output_rasters"
dir.create(output_dir, showWarnings = FALSE)
for (ecosystem_value in top_10_ecosystems) {
  output_path <- file.path(output_dir, paste0("ecosystem_", ecosystem_value, ".tif"))
  writeRaster(ecosystem_rasters[[ecosystem_value]], filename = output_path)
}

## so far so good!

# Visualize the separate ecosystem maps using ggplot2
for (ecosystem_value in top_10_ecosystems) {
  plot_data <- as.data.frame(ecosystem_rasters[[ecosystem_value]])
  ggplot(plot_data, aes(x = x, y = y, fill = value)) +
    geom_raster() +
    geom_sf(data = state_boundaries, fill = NA, color = "black") +  # Add state boundaries
    scale_fill_viridis_c() +
    theme_void()
}
