# Calculate Rainfall Anomalies

Computes precipitation anomalies relative to a baseline climatology
(such as `PISCOp_clim2` or a multi-year monthly mean). Anomalies can be
expressed in absolute difference (mm) or percentage deviation (\\).

## Usage

``` r
pisco_anomaly(
  x,
  baseline = NULL,
  type = c("percentage", "difference"),
  eps = 0.1
)
```

## Arguments

- x:

  A monthly
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  with valid time attributes.

- baseline:

  Optional
  [terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  of monthly normals (12 layers) representing the climatological
  baseline (e.g. `pisco_read("climatology")`). If `NULL`, the baseline
  is computed internally as the multi-year monthly mean of `x`.

- type:

  Character. Type of anomaly: `"difference"` (absolute anomaly:
  `x - baseline` in mm) or `"percentage"` (relative anomaly:
  `((x - baseline) / baseline) * 100` in \\). Default is `"percentage"`.

- eps:

  Numeric. Small epsilon to prevent division by zero in arid regions
  when `type = "percentage"`. Default is 0.1 (mm).

## Value

A
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
of anomalies with preserved time attributes.

## Examples

``` r
# \donttest{
r_m <- pisco_read("monthly", dates = c(1997, 1998))
#> Error in pisco_read("monthly", dates = c(1997, 1998)): ✖ File not found in the local cache:
#>   /home/runner/.cache/R/rpisco/PISCOp_m.nc.
#> ℹ Download it explicitly with `pisco_download('monthly')`.
#> ℹ Or call `pisco_read('monthly', download = TRUE)` to authorize this download.
r_clim <- pisco_read("climatology")
#> Error in pisco_read("climatology"): ✖ File not found in the local cache:
#>   /home/runner/.cache/R/rpisco/PISCOp_clim2.nc.
#> ℹ Download it explicitly with `pisco_download('climatology')`.
#> ℹ Or call `pisco_read('climatology', download = TRUE)` to authorize this
#>   download.

# Percentage anomaly during 1997-1998 El Nino
anom_pct <- pisco_anomaly(r_m, baseline = r_clim, type = "percentage")
#> Error: object 'r_m' not found

# Absolute difference anomaly (mm)
anom_diff <- pisco_anomaly(r_m, baseline = r_clim, type = "difference")
#> Error: object 'r_m' not found
# }
```
