# Extract Time Series from PISCO Rasters

Extracts precipitation time series from a PISCO
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
at given point coordinates or computes zonal summaries (e.g. areal mean)
over spatial polygons.

## Usage

``` r
pisco_extract(x, points = NULL, polygons = NULL, fun = "mean", id_col = NULL)
```

## Arguments

- x:

  A
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  object.

- points:

  Optional. An `sf` point object, a matrix/data.frame with `lon` and
  `lat` columns, or a numeric coordinate vector `c(lon, lat)`.

- polygons:

  Optional. An `sf` polygon object or
  [`terra::SpatVector`](https://rspatial.github.io/terra/reference/SpatVector-class.html)
  for zonal statistics.

- fun:

  Character or function. Summary statistic when extracting across
  polygons (e.g., `"mean"`, `"sum"`, `"median"`). Default is `"mean"`.

- id_col:

  Character. Name of the column in `polygons` or `points` to identify
  features.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
containing the extracted time series in tidy format.

## Examples

``` r
# Toy SpatRaster with time attribute
r <- terra::rast(xmin = -80, xmax = -70, ymin = -15, ymax = -5,
                 resolution = 0.5, crs = "EPSG:4326", nlyrs = 6)
terra::values(r) <- rep(1:6, each = terra::ncell(r))
terra::time(r) <- seq(as.Date("2020-01-01"), by = "month", length.out = 6)

# Extract at point coordinates
df_pt <- pisco_extract(r, points = c(-75.5, -10.5))

# Extract areal means over polygons
p1 <- sf::st_buffer(sf::st_point(c(-76, -11)), 0.8)
poly_sf <- sf::st_sf(basin_name = "Rimac",
                     geometry = sf::st_sfc(p1, crs = 4326))
df_basin <- pisco_extract(r, polygons = poly_sf, id_col = "basin_name")

# \donttest{
# Real PISCO download
r_pisco <- pisco_read("monthly")
df_pt <- pisco_extract(r_pisco, points = c(-71.96, -13.53))
# }
```
