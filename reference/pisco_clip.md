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
if (FALSE) { # \dontrun{
r <- pisco_read("monthly")
# Crop by bounding box (e.g. Lima / Rimac basin)
r_sub <- pisco_clip(r, mask = c(-77.5, -12.5, -76.0, -11.5))

# Crop and mask using an sf polygon
# r_basin <- pisco_clip(r, mask = basin_sf)
} # }
```
