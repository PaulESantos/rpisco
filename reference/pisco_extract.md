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
if (FALSE) { # \dontrun{
r <- pisco_read("monthly")
# Extract at point coordinates (Cusco)
df_pt <- pisco_extract(r, points = c(-71.96, -13.53))

# Extract areal mean over watershed polygons
# df_basin <- pisco_extract(r, polygons = basins_sf, id_col = "basin_name")
} # }
```
