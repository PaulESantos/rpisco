# Statistical Validation Metrics for PISCO

Implements the statistical evaluation metrics used in the official
PISCOp v3.0 validation report (Gutierrez & Lavado-Casimiro, 2025;
Willmott et al., 2012):

- Pearson correlation coefficient (COR)

- Refined Index of Agreement (\\d_r\\) (Willmott et al., 2012)

- Normalized Mean Bias (NMB, \\

- Normalized Mean Gross Error (NMGE)

- Root Mean Squared Error (RMSE)

- Mean Absolute Error (MAE)

## Usage

``` r
pisco_metric_cor(sim, obs, na.rm = TRUE)

pisco_metric_dr(sim, obs, na.rm = TRUE)

pisco_metric_nmb(sim, obs, na.rm = TRUE)

pisco_metric_nmge(sim, obs, na.rm = TRUE)

pisco_metrics(sim, obs, na.rm = TRUE)
```

## Arguments

- sim:

  Numeric vector of simulated or gridded values (e.g. PISCO).

- obs:

  Numeric vector of observed values (e.g. rain gauge stations).

- na.rm:

  Logical. If `TRUE`, pairs with missing values (`NA`) are removed.
  Default is `TRUE`.

## Value

`pisco_metrics()` returns a
[tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
containing all validation metrics.

## Examples

``` r
obs <- c(12.5, 34.2, 0.0, 5.4, 60.1, 105.3)
sim <- c(10.1, 31.0, 0.2, 7.8, 55.0, 98.4)

pisco_metrics(sim, obs)
#> # A tibble: 1 × 8
#>       n   cor    dr   nmb   nmge  rmse   mae  bias
#>   <int> <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl> <dbl>
#> 1     6 0.999 0.946 -6.90 0.0929  3.99  3.37  -2.5
pisco_metric_dr(sim, obs)
#> [1] 0.9456405
pisco_metric_nmb(sim, obs)
#> [1] -6.896552
pisco_metric_nmge(sim, obs)
#> [1] 0.09287356
```
