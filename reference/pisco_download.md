# Download PISCO Datasets

Downloads a PISCO dataset from official repositories (Figshare or
HydroShare) to the local cache directory. If the file is already cached,
download is skipped unless `overwrite = TRUE`.

## Usage

``` r
pisco_download(
  dataset = c("monthly", "daily", "climatology", "tmax_daily", "tmin_daily", "tmax_clim",
    "tmin_clim", "eto_clim", "erosivity_r", "erosivity_density", "streamflow_monthly",
    "streamflow_daily", "catchments_gr2m", "rivers_gr2m"),
  destdir = pisco_cache_dir(),
  overwrite = FALSE,
  verify_md5 = TRUE,
  timeout = 3600,
  quiet = FALSE,
  refresh = TRUE
)
```

## Arguments

- dataset:

  Character. The dataset to download:

  - Precipitation: `"monthly"` (`"PISCOp_m"`), `"daily"` (`"PISCOp_d"`),
    `"climatology"` (`"PISCOp_clim2"`).

  - Temperature: `"tmax_daily"`, `"tmin_daily"`, `"tmax_clim"`,
    `"tmin_clim"`.

  - Evapotranspiration: `"eto_clim"` (`"PISCOeo_pm"`).

  - Erosivity: `"erosivity_r"`, `"erosivity_density"`.

  - Streamflow: `"streamflow_monthly"`, `"streamflow_daily"`,
    `"catchments_gr2m"`, `"rivers_gr2m"`, `"catchments_arnovic"`, or
    `"rivers_arnovic"`. Default is `"monthly"`.

- destdir:

  Character. Destination directory. Default is
  [`pisco_cache_dir()`](https://PaulESantos.github.io/rpisco/reference/pisco_cache_dir.md).

- overwrite:

  Logical. If `TRUE`, re-downloads the file even if present in cache.

- verify_md5:

  Logical. If `TRUE` and an MD5 hash is registered, validates the
  checksum. Default is `TRUE`.

- timeout:

  Numeric. Maximum seconds to allow for download. Default is 3600 (1
  hour).

- quiet:

  Logical. If `TRUE`, suppresses progress messages. Default is `FALSE`.

- refresh:

  Logical. If `TRUE`, refreshes public repository metadata before
  downloading an uncached file. This is safe because calling this
  function is an explicit user request to download data. Default is
  `TRUE`.

## Value

Character. The absolute path to the downloaded (or cached) file.

## Examples

``` r
if (FALSE) { # \dontrun{
# Download monthly precipitation (56.6 MB)
fpath_pr <- pisco_download("monthly")

# Download climatological normal maximum temperature (0.52 MB)
fpath_tx <- pisco_download("tmax_clim")

# Download rainfall erosivity R-factor (1.75 MB)
fpath_re <- pisco_download("erosivity_r")
} # }
```
