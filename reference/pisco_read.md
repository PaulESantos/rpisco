# Read PISCO Datasets as SpatRaster or sf Vector

Reads a PISCO dataset into memory or memory-mapped objects
([terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
for raster grids, or `sf` for catchment/river vector layers). If the
file is not present locally, it can be downloaded after the caller
explicitly sets `download = TRUE`.

## Usage

``` r
pisco_read(
  dataset = c("monthly", "daily", "climatology", "tmax_daily", "tmin_daily", "tmax_clim",
    "tmin_clim", "eto_clim", "erosivity_r", "erosivity_density", "streamflow_monthly",
    "streamflow_daily", "catchments_gr2m", "rivers_gr2m"),
  file = NULL,
  dates = NULL,
  aoi = NULL,
  mask = NULL,
  download = FALSE
)
```

## Arguments

- dataset:

  Character. The dataset to load:

  - Precipitation: `"monthly"` (`"PISCOp_m"`), `"daily"` (`"PISCOp_d"`),
    `"climatology"` (`"PISCOp_clim2"`).

  - Temperature: `"tmax_daily"`, `"tmin_daily"`, `"tmax_clim"`,
    `"tmin_clim"`.

  - Evapotranspiration: `"eto_clim"` (`"PISCOeo_pm"`).

  - Erosivity: `"erosivity_r"`, `"erosivity_density"`.

  - Streamflow: `"streamflow_monthly"`, `"streamflow_daily"`,
    `"catchments_gr2m"`, `"rivers_gr2m"`, `"catchments_arnovic"`, or
    `"rivers_arnovic"`. Default is `"monthly"`.

- file:

  Character. Optional custom path to a PISCO NetCDF or GeoPackage file.
  If `NULL`, looks in the local cache.

- dates:

  Vector of dates, years, year-months, or indices to filter layers.

  - For daily/monthly rasters: Date objects, character dates
    (`"1998-01-01"`), character year-months (`c("1997-01", "1998-12")`),
    or numeric years (`1998` or `c(1997, 1998)`).

  - For climatologies (12 months): integer month numbers (`1:12`) or
    month names.

- aoi:

  Optional spatial object (`sf`, `SpatVector`, or bounding box vector)
  to crop/mask the raster upon reading. Alias for `mask`.

- mask:

  Optional spatial mask. Same as `aoi`.

- download:

  Logical. If `TRUE` and file is not cached, downloads it after this
  explicit request. Default is `FALSE` to avoid implicit network access.

## Value

A
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
object (for gridded data) or an `sf` object (for vector hydrography).

## Examples

``` r
if (FALSE) { # \dontrun{
# Read monthly precipitation
r_pr <- pisco_read("monthly")

# Read normal maximum temperature 1981-2010
r_tx <- pisco_read("tmax_clim")

# Read reference evapotranspiration climatology
r_eto <- pisco_read("eto_clim")

# Read rainfall erosivity R-factor
r_ero <- pisco_read("erosivity_r")
} # }
```
