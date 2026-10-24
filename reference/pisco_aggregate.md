# Temporal Aggregation of PISCO Rasters

Aggregates a PISCO
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
across time: annual totals, monthly cycle, multi-year climatology, or
SENAMHI hydrological seasons (Wet: Nov–Apr, Dry: May–Oct).

## Usage

``` r
pisco_aggregate(
  x,
  by = c("year", "month", "season_senamhi", "hydrological_year", "climatology"),
  fun = "sum"
)
```

## Arguments

- x:

  A
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  with valid time attributes.

- by:

  Character. Aggregation unit:

  - `"year"`: Aggregates across each calendar year (e.g., annual
    rainfall).

  - `"month"`: Multi-year monthly aggregation (produces 12 layers for
    Jan–Dec).

  - `"season_senamhi"`: SENAMHI official hydrological seasons: Wet
    season (`wet_Nov_Apr`: Nov, Dec, Jan, Feb, Mar, Apr) and Dry season
    (`dry_May_Oct`: May, Jun, Jul, Aug, Sep, Oct). November and December
    are grouped with the following calendar year's hydrological period.

  - `"hydrological_year"`: Annual aggregation based on the Peruvian
    hydrological year starting in November (Nov 1 to Oct 31).

  - `"climatology"`: Multi-year monthly mean normals (12 layers).

- fun:

  Character or function. Aggregation function (`"sum"`, `"mean"`,
  `"max"`, etc.). Default is `"sum"` (for precipitation accumulations).

## Value

An aggregated
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html).

## Examples

``` r
# \donttest{
r <- pisco_read("monthly")
#> Error in pisco_read("monthly"): ✖ File not found in the local cache:
#>   /home/runner/.cache/R/rpisco/PISCOp_m.nc.
#> ℹ Download it explicitly with `pisco_download('monthly')`.
#> ℹ Or call `pisco_read('monthly', download = TRUE)` to authorize this download.
# Annual rainfall accumulation (mm/year)
r_ann <- pisco_aggregate(r, by = "year", fun = "sum")
#> Error: object 'r' not found

# SENAMHI seasonal rainfall (Wet: Nov-Apr, Dry: May-Oct)
r_seas <- pisco_aggregate(r, by = "season_senamhi", fun = "sum")
#> Error: object 'r' not found

# Multi-year mean monthly cycle
r_cycle <- pisco_aggregate(r, by = "month", fun = "mean")
#> Error: object 'r' not found
# }
```
