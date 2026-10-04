# Refresh PISCO download metadata from public repositories

Queries the public Figshare and HydroShare metadata APIs and refreshes
the download URLs, file sizes, and checksums held in the current R
session. This operation retrieves metadata only; it never downloads a
PISCO data file. It is opt-in so package loading and ordinary reads
remain offline.

## Usage

``` r
pisco_refresh_catalog(timeout = 30, quiet = FALSE)
```

## Arguments

- timeout:

  Numeric. Maximum seconds for each metadata request.

- quiet:

  Logical. If `TRUE`, suppresses informational messages.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with refreshed metadata, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
pisco_refresh_catalog()
} # }
```
