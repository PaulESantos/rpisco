# Catalog of PISCO Products

Lists the available PISCO datasets, variables, metadata, temporal
ranges, resolution, official file names, hosting repositories, and local
cache status across the full PISCO family (SENAMHI DHI-SEH).

## Usage

``` r
pisco_catalog(
  variable = c("all", "precipitation", "temperature", "evapotranspiration", "erosivity",
    "streamflow"),
  refresh = FALSE
)
```

## Arguments

- variable:

  Character. Variable filter: `"all"`, `"precipitation"`,
  `"temperature"`, `"evapotranspiration"`, `"erosivity"`, or
  `"streamflow"`. Default is `"all"`.

- refresh:

  Logical. If `TRUE`, explicitly refreshes the in-session metadata from
  the Figshare and HydroShare APIs. This never downloads data.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
containing metadata for the selected PISCO datasets.

## Examples

``` r
# Complete catalog
pisco_catalog()
#> # A tibble: 16 × 13
#>    dataset     variable product filename timestep period layers resolution unit 
#>    <chr>       <chr>    <chr>   <chr>    <chr>    <chr>   <int> <chr>      <chr>
#>  1 monthly     precipi… PISCOp… PISCOp_… monthly  1981-…    540 0.10 deg … mm/m…
#>  2 daily       precipi… PISCOp… PISCOp_… daily    1981-…  16436 0.10 deg … mm/d…
#>  3 climatology precipi… PISCOp… PISCOp_… climato… 1991-…     12 0.10 deg … mm/m…
#>  4 tmax_daily  tempera… PISCOt… tmax_da… daily    1981-…  14610 0.10 deg … degC 
#>  5 tmin_daily  tempera… PISCOt… tmin_da… daily    1981-…  14610 0.10 deg … degC 
#>  6 tmax_clim   tempera… PISCOt… tmax_me… climato… 1981-…     12 0.10 deg … degC 
#>  7 tmin_clim   tempera… PISCOt… tmin_me… climato… 1981-…     12 0.10 deg … degC 
#>  8 eto_clim    evapotr… PISCOe… eo_mean… climato… 1981-…     12 0.10 deg … mm/m…
#>  9 erosivity_r erosivi… PISCOa… PISCOa_… annual … 2001-…     20 0.10 deg … MJ m…
#> 10 erosivity_… erosivi… PISCOa… PISCOa_… annual … 2001-…     20 0.10 deg … MJ h…
#> 11 streamflow… streamf… PISCO_… PISCO_G… monthly  1981-…    480 river rea… m3/s 
#> 12 streamflow… streamf… PISCO_… PISCO_A… daily    1981-…  14610 river rea… m3/s 
#> 13 catchments… streamf… cat_pi… cat_pis… static   1981-…      1 vector po… boun…
#> 14 rivers_gr2m streamf… riv_pi… riv_pis… static   1981-…      1 vector li… stre…
#> 15 catchments… streamf… cat_pi… cat_pis… static   1981-…      1 vector po… boun…
#> 16 rivers_arn… streamf… riv_pi… riv_pis… static   1981-…      1 vector li… stre…
#> # ℹ 4 more variables: size_mb <dbl>, source <chr>, cached <lgl>,
#> #   download_url <chr>

# Filter by variable family
pisco_catalog("precipitation")
#> # A tibble: 3 × 13
#>   dataset     variable  product filename timestep period layers resolution unit 
#>   <chr>       <chr>     <chr>   <chr>    <chr>    <chr>   <int> <chr>      <chr>
#> 1 monthly     precipit… PISCOp… PISCOp_… monthly  1981-…    540 0.10 deg … mm/m…
#> 2 daily       precipit… PISCOp… PISCOp_… daily    1981-…  16436 0.10 deg … mm/d…
#> 3 climatology precipit… PISCOp… PISCOp_… climato… 1991-…     12 0.10 deg … mm/m…
#> # ℹ 4 more variables: size_mb <dbl>, source <chr>, cached <lgl>,
#> #   download_url <chr>
pisco_catalog("temperature")
#> # A tibble: 4 × 13
#>   dataset    variable   product filename timestep period layers resolution unit 
#>   <chr>      <chr>      <chr>   <chr>    <chr>    <chr>   <int> <chr>      <chr>
#> 1 tmax_daily temperatu… PISCOt… tmax_da… daily    1981-…  14610 0.10 deg … degC 
#> 2 tmin_daily temperatu… PISCOt… tmin_da… daily    1981-…  14610 0.10 deg … degC 
#> 3 tmax_clim  temperatu… PISCOt… tmax_me… climato… 1981-…     12 0.10 deg … degC 
#> 4 tmin_clim  temperatu… PISCOt… tmin_me… climato… 1981-…     12 0.10 deg … degC 
#> # ℹ 4 more variables: size_mb <dbl>, source <chr>, cached <lgl>,
#> #   download_url <chr>
pisco_catalog("streamflow")
#> # A tibble: 6 × 13
#>   dataset      variable product filename timestep period layers resolution unit 
#>   <chr>        <chr>    <chr>   <chr>    <chr>    <chr>   <int> <chr>      <chr>
#> 1 streamflow_… streamf… PISCO_… PISCO_G… monthly  1981-…    480 river rea… m3/s 
#> 2 streamflow_… streamf… PISCO_… PISCO_A… daily    1981-…  14610 river rea… m3/s 
#> 3 catchments_… streamf… cat_pi… cat_pis… static   1981-…      1 vector po… boun…
#> 4 rivers_gr2m  streamf… riv_pi… riv_pis… static   1981-…      1 vector li… stre…
#> 5 catchments_… streamf… cat_pi… cat_pis… static   1981-…      1 vector po… boun…
#> 6 rivers_arno… streamf… riv_pi… riv_pis… static   1981-…      1 vector li… stre…
#> # ℹ 4 more variables: size_mb <dbl>, source <chr>, cached <lgl>,
#> #   download_url <chr>
```
