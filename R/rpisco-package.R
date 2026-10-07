#' rpisco: Access and Process PISCO High-Resolution Climate Grids for Peru
#'
#' @description
#' The `rpisco` package provides programmatic access, automated caching,
#' spatial subsetting, temporal analysis, and hydrological validation metrics
#' for the Peruvian Interpolated data of SENAMHI's Climatological and
#' hydrological Observations (PISCO).
#'
#' @details
#' Supports the PISCO datasets included in the package catalog:
#' \itemize{
#'   \item \strong{Precipitation (PISCOp)}: PISCOp v3.0 (1981-2025; daily, monthly, and
#'   climatological normal).
#'   \item \strong{Temperature (PISCOt)}: PISCOt v1.2 (maximum and minimum daily data
#'   and climatological normals).
#'   \item \strong{Evapotranspiration (PISCOeo_pm)}: PISCOeo_pm monthly climatological
#'   reference evapotranspiration.
#'   \item \strong{Rainfall Erosivity (PISCO_reed)}: PISCO_reed v1.0 (1981-2016; R-factor
#'   climatology and annual erosivity series).
#'   \item \strong{Streamflow (PISCO_HyM)}: Monthly gridded and vector streamflow
#'   (1981-2016) based on hydrological modeling (GR2M and ARNOVIC) with sub-basin
#'   polygons and river reach networks.
#' }
#' Datasets are hosted on Figshare and HydroShare by SENAMHI and collaborating
#' researchers. See \code{\link{pisco_catalog}} and \code{\link{pisco_citation}}
#' for links, dataset keys, and scientific citations.
#'
#' @keywords internal
"_PACKAGE"
