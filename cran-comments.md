## Resubmission

This is a resubmission of package 'rpisco' (v0.1.0) following feedback from CRAN reviewer Leonore Hochhauser:

> 1. "We still see \dontrun{} being used, please replace it with \donttest{} or reply-all and explain why \dontrun{} is necessary here."
> 2. "Some code lines in examples are commented out. Please never do that. Ideally find toy examples that can be regularly executed and checked. Lengthy examples (> 5 sec), can be wrapped in \donttest{}."

### Changes in this resubmission

* Replaced `\dontrun{}` with `\donttest{}`:
  - In `climatodiagrama()`, replaced the `\dontrun{}` block with `\donttest{}` and converted it into a safe, executable example using `tempfile()` for writing and reading a sample CSV, ensuring no files are left in the working directory.

* Removed commented-out code in examples:
  - Removed commented-out code lines in `pisco_clip()` (`# r_basin <- pisco_clip(r, mask = basin_sf)`) and `pisco_extract()` (`# df_basin <- pisco_extract(r, polygons = basins_sf, id_col = "basin_name")`).

* Added executable toy examples:
  - Added self-contained, lightweight toy examples for `pisco_clip()`, `pisco_extract()`, `pisco_aggregate()`, and `pisco_anomaly()`. These create small in-memory `SpatRaster` and `sf` polygon objects that execute in milliseconds, allowing examples to be regularly executed and tested during R CMD check without requiring external data downloads.
  - Lengthy examples requiring remote data downloads remain safely wrapped in `\donttest{}`.

### Earlier feedback (Uwe Ligges)

* Fixed all invalid URLs:
  - Removed `https://PaulESantos.github.io/rpisco/` from `DESCRIPTION` (only canonical repository URL `https://github.com/PaulESantos/rpisco` is listed).
  - Updated PISCOeo_pm reference to Huerta et al. (2022), Scientific Data, <https://doi.org/10.1038/s41597-022-01373-8>.
  - Updated PISCO_HyM reference to Llauca et al. (2021), Water, <https://doi.org/10.3390/w13081048> and active HydroShare resource <https://www.hydroshare.org/resource/f1b537f338f24533af5dab946b51d215/>.
  - Verified with `urlchecker::url_check()` that all URLs return HTTP 200.

## R CMD check results

0 errors | 0 warnings | 1 note

### Notes

* Note: "New submission" (this is the first CRAN release of rpisco).

* Note: "Possibly misspelled words in DESCRIPTION"
  - ARNOVIC, Climatological, DHI, Figshare, HyM, HydroShare, PISCO, PISCOeo, PISCOp, PISCOt, SEH, SENAMHI, climatologies, erosivity, evapotranspiration, hydrological, streamflow.
  - These are legitimate domain-specific scientific terminology, model/product acronyms, and institutional names (SENAMHI: Servicio Nacional de Meteorología e Hidrología del Perú, DHI-SEH, HydroShare, Figshare). All terms are spelled correctly in context.

