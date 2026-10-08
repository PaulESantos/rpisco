## Resubmission

This is a resubmission of package 'rpisco' (v0.1.0) following feedback from CRAN maintainer Uwe Ligges regarding invalid URLs.

### Changes in this resubmission

* Fixed all invalid URLs:
  - Removed `https://PaulESantos.github.io/rpisco/` from `DESCRIPTION` and regenerated package documentation (GitHub Pages is not yet active; only the canonical repository URL `https://github.com/PaulESantos/rpisco` is listed).
  - Corrected the references and URLs in `README.md`:
    - Updated PISCOeo_pm reference to Huerta et al. (2022), Scientific Data, <https://doi.org/10.1038/s41597-022-01373-8>.
    - Updated PISCO_HyM reference to Llauca et al. (2021), Water, <https://doi.org/10.3390/w13081048> and the active HydroShare resource <https://www.hydroshare.org/resource/f1b537f338f24533af5dab946b51d215/>.
  - Verified with `urlchecker::url_check()` that all URLs in the package are valid and return HTTP 200.

## R CMD check results

0 errors | 0 warnings | 1 note

### Notes

* Note: "New submission" (this is the first CRAN release of rpisco).

* Note: "Possibly misspelled words in DESCRIPTION"
  - ARNOVIC, Climatological, DHI, Figshare, HyM, HydroShare, PISCO, PISCOeo, PISCOp, PISCOt, SEH, SENAMHI, climatologies, erosivity, evapotranspiration, hydrological, streamflow.
  - These are legitimate domain-specific scientific terminology, model/product acronyms, and institutional names (SENAMHI: Servicio Nacional de Meteorología e Hidrología del Perú, DHI-SEH, HydroShare, Figshare). All terms are spelled correctly in context.

