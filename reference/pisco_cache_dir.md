# PISCO Cache Management

Functions to inspect, set, and clear the local cache directory used by
`rpisco` to store downloaded NetCDF files.

## Usage

``` r
pisco_cache_dir(path = NULL)

pisco_cache_status()

pisco_cache_clear(dataset = "all")
```

## Arguments

- path:

  Character. Custom path to set as cache. If `NULL`, returns current
  cache.

- dataset:

  Character. Dataset name (`"monthly"`, `"daily"`, `"climatology"`), or
  `"all"` to remove every cached file known to `rpisco`. Files unrelated
  to `rpisco` are never removed.

## Value

A character path to the cache directory, or logical status invisibly.

## Examples

``` r
pisco_cache_dir()
#> [1] "/home/runner/.cache/R/rpisco"
pisco_cache_status()
#> # A tibble: 16 × 6
#>    dataset            filename                cached expected_mb cached_mb path 
#>    <chr>              <chr>                   <lgl>        <dbl>     <dbl> <chr>
#>  1 monthly            PISCOp_m.nc             FALSE        56.6          0 NA   
#>  2 daily              PISCOp_d.nc             FALSE      1527.           0 NA   
#>  3 climatology        PISCOp_clim2.nc         FALSE         1.83         0 NA   
#>  4 tmax_daily         tmax_daily_1981_2020_0… FALSE       603.           0 NA   
#>  5 tmin_daily         tmin_daily_1981_2020_0… FALSE       620.           0 NA   
#>  6 tmax_clim          tmax_mean_1981-2010_01… FALSE         0.52         0 NA   
#>  7 tmin_clim          tmin_mean_1981-2010_01… FALSE         0.53         0 NA   
#>  8 eto_clim           eo_mean_1981-2010.nc    FALSE        64.0          0 NA   
#>  9 erosivity_r        PISCOa_re.nc            FALSE         1.75         0 NA   
#> 10 erosivity_density  PISCOa_ed.nc            FALSE         1.75         0 NA   
#> 11 streamflow_monthly PISCO_GR2M_v2.0.nc      FALSE        24.6          0 NA   
#> 12 streamflow_daily   PISCO_ARNOVIC_v1.1.nc   FALSE       747.           0 NA   
#> 13 catchments_gr2m    cat_pisco_GR2M_v2.0.gp… FALSE       100.           0 NA   
#> 14 rivers_gr2m        riv_pisco_GR2M_v2.0.gp… FALSE        15.2          0 NA   
#> 15 catchments_arnovic cat_pisco_arnovic_v1.1… FALSE       100.           0 NA   
#> 16 rivers_arnovic     riv_pisco_arnovic_v1.1… FALSE        15.2          0 NA   
```
