# Spatial Cropping and Masking for PISCO Rasters

Crops and masks a PISCO
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
using a vector polygon (`sf` or `SpatVector`), an
[`sf::st_bbox`](https://r-spatial.github.io/sf/reference/st_bbox.html)
object, or a spatial bounding box numeric vector.

## Usage

``` r
pisco_clip(x, mask, crop_only = FALSE, touches = TRUE, ...)
```

## Arguments

- x:

  A
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  object.

- mask:

  An `sf` object,
  [`terra::SpatVector`](https://rspatial.github.io/terra/reference/SpatVector-class.html),
  [`sf::st_bbox`](https://r-spatial.github.io/sf/reference/st_bbox.html),
  [`terra::SpatExtent`](https://rspatial.github.io/terra/reference/SpatExtent-class.html),
  or numeric bounding box (`c(xmin, ymin, xmax, ymax)`).

- crop_only:

  Logical. If `TRUE`, only crops to bounding box without masking values
  outside polygon. Default is `FALSE`.

- touches:

  Logical. If `TRUE`, all cells touched by polygon boundaries are
  included in the mask. Default is `TRUE` (matching default
  [`terra::mask()`](https://rspatial.github.io/terra/reference/mask.html)
  behavior).

- ...:

  Additional arguments passed directly to
  [`terra::crop()`](https://rspatial.github.io/terra/reference/crop.html).

## Value

A cropped (and optionally masked)
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html).

## Examples

``` r
# Toy SpatRaster
r <- terra::rast(xmin = -80, xmax = -70, ymin = -15, ymax = -5,
                 resolution = 0.5, crs = "EPSG:4326")
terra::values(r) <- seq_len(terra::ncell(r))

# Crop by bounding box (c(xmin, ymin, xmax, ymax))
r_sub <- pisco_clip(r, mask = c(-78, -12, -76, -10))

# Crop and mask using an sf polygon
pt <- sf::st_point(c(-75, -10))
poly_sf <- sf::st_sf(data.frame(id = 1),
                     geometry = sf::st_sfc(sf::st_buffer(pt, 1), crs = 4326))
r_basin <- pisco_clip(r, mask = poly_sf)

# \donttest{
# Real PISCO download
r_pisco <- pisco_read("monthly")
#> Error in pisco_read("monthly"): ✖ File not found in the local cache:
#>   /home/runner/.cache/R/rpisco/PISCOp_m.nc.
#> ℹ Download it explicitly with `pisco_download('monthly')`.
#> ℹ Or call `pisco_read('monthly', download = TRUE)` to authorize this download.
r_sub <- pisco_clip(r_pisco, mask = c(-77.5, -12.5, -76.0, -11.5))
#> Error: object 'r_pisco' not found
# }
```
