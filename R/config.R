# Constants and Dataset Metadata for the PISCO Family (SENAMHI DHI-SEH)

.pisco_figshare_article_id <- 32411886L
.pisco_doi <- "10.6084/m9.figshare.32411886.v1"
.pisco_handle <- "https://hdl.handle.net/20.500.12542/4183"
.pisco_portal <- "https://sites.google.com/view/dhi-seh/pisco"
.pisco_crs <- "EPSG:4326"

# Public resource identifiers used to refresh file metadata on demand.  These
# are metadata endpoints only: they never download a PISCO data file.
.pisco_figshare_articles <- c(piscop_v3 = "32411886")
.pisco_hydroshare_resources <- c(
  gr2m = "f1b537f338f24533af5dab946b51d215",
  arnovic = "f723d6c762ca45b6936dd9489bc44842"
)

# Official geographic coverage for Peru and transboundary basins
.pisco_extent <- c(xmin = -82.0, ymin = -19.0, xmax = -64.0, ymax = 2.0)

.pisco_files <- list(
  # =========================================================================
  # 1. PRECIPITATION (PISCOp v3.0 - Gutierrez & Lavado-Casimiro, 2025)
  # =========================================================================
  monthly = list(
    variable = "precipitation",
    product = "PISCOp_m",
    filename = "PISCOp_m.nc",
    figshare_file_id = 64968111L,
    download_url = "https://ndownloader.figshare.com/files/64968111",
    md5 = "fbf4f19b5d537183a75d08615c404010",
    size_bytes = 56601000L,
    size_mb = 56.6,
    resolution = "0.10 deg (~10 km)",
    timestep = "monthly",
    period = "1981-01 to 2025-12",
    layers = 540L,
    unit = "mm/month",
    source = "Figshare",
    description = "Monthly gridded rainfall for Peru and transboundary basins (1981-2025)"
  ),
  daily = list(
    variable = "precipitation",
    product = "PISCOp_d",
    filename = "PISCOp_d.nc",
    figshare_file_id = 64968183L,
    download_url = "https://ndownloader.figshare.com/files/64968183",
    md5 = "01a7259f4a4fa38158496e3670bb1794",
    size_bytes = 1527191910L,
    size_mb = 1527.2,
    resolution = "0.10 deg (~10 km)",
    timestep = "daily",
    period = "1981-01-01 to 2025-12-31",
    layers = 16436L,
    unit = "mm/day",
    source = "Figshare",
    description = "Daily gridded rainfall for Peru and transboundary basins (1981-2025)"
  ),
  climatology = list(
    variable = "precipitation",
    product = "PISCOp_clim2",
    filename = "PISCOp_clim2.nc",
    figshare_file_id = 64968156L,
    download_url = "https://ndownloader.figshare.com/files/64968156",
    md5 = "655b42e841505182548f57de70fdd57b",
    size_bytes = 1827367L,
    size_mb = 1.83,
    resolution = "0.10 deg (~10 km)",
    timestep = "climatology (12 months)",
    period = "1991-2015 normal",
    layers = 12L,
    unit = "mm/month",
    source = "Figshare",
    description = "Monthly normal rainfall climatology 1991-2015 at 0.10 deg"
  ),
  
  # =========================================================================
  # 2. AIR TEMPERATURE (PISCOt v1.2 - Huerta et al., 2023)
  # =========================================================================
  tmax_daily = list(
    variable = "temperature",
    product = "PISCOt_tx_d",
    filename = "tmax_daily_1981_2020_010.nc",
    figshare_file_id = 40343707L,
    download_url = "https://ndownloader.figshare.com/files/40343707",
    md5 = NA_character_,
    size_bytes = 631945625L,
    size_mb = 602.67,
    resolution = "0.10 deg (~10 km)",
    timestep = "daily",
    period = "1981-01-01 to 2020-12-31",
    layers = 14610L,
    unit = "degC",
    source = "Figshare",
    description = "Daily maximum temperature at 0.10 deg (PISCOt v1.2, 1981-2020)"
  ),
  tmin_daily = list(
    variable = "temperature",
    product = "PISCOt_tn_d",
    filename = "tmin_daily_1981_2020_010.nc",
    figshare_file_id = 40343728L,
    download_url = "https://ndownloader.figshare.com/files/40343728",
    md5 = NA_character_,
    size_bytes = 649624576L,
    size_mb = 619.53,
    resolution = "0.10 deg (~10 km)",
    timestep = "daily",
    period = "1981-01-01 to 2020-12-31",
    layers = 14610L,
    unit = "degC",
    source = "Figshare",
    description = "Daily minimum temperature at 0.10 deg (PISCOt v1.2, 1981-2020)"
  ),
  tmax_clim = list(
    variable = "temperature",
    product = "PISCOt_tx_clim",
    filename = "tmax_mean_1981-2010_010.nc",
    figshare_file_id = 41000858L,
    download_url = "https://ndownloader.figshare.com/files/41000858",
    md5 = NA_character_,
    size_bytes = 545280L,
    size_mb = 0.52,
    resolution = "0.10 deg (~10 km)",
    timestep = "climatology (12 months)",
    period = "1981-2010 normal",
    layers = 12L,
    unit = "degC",
    source = "Figshare",
    description = "Monthly normal maximum temperature 1981-2010 at 0.10 deg (PISCOt v1.2)"
  ),
  tmin_clim = list(
    variable = "temperature",
    product = "PISCOt_tn_clim",
    filename = "tmin_mean_1981-2010_010.nc",
    figshare_file_id = 41000861L,
    download_url = "https://ndownloader.figshare.com/files/41000861",
    md5 = NA_character_,
    size_bytes = 555776L,
    size_mb = 0.53,
    resolution = "0.10 deg (~10 km)",
    timestep = "climatology (12 months)",
    period = "1981-2010 normal",
    layers = 12L,
    unit = "degC",
    source = "Figshare",
    description = "Monthly normal minimum temperature 1981-2010 at 0.10 deg (PISCOt v1.2)"
  ),
  
  # =========================================================================
  # 3. REFERENCE EVAPOTRANSPIRATION (PISCOeo_pm - Huerta et al., 2022)
  # =========================================================================
  eto_clim = list(
    variable = "evapotranspiration",
    product = "PISCOeo_pm_clim",
    filename = "eo_mean_1981-2010.nc",
    figshare_file_id = 30714011L,
    download_url = "https://ndownloader.figshare.com/files/30714011",
    md5 = NA_character_,
    size_bytes = 67088384L,
    size_mb = 63.98,
    resolution = "0.10 deg (~10 km)",
    timestep = "climatology (12 months)",
    period = "1981-2010 normal",
    layers = 12L,
    unit = "mm/month",
    source = "Figshare",
    description = "Monthly normal reference evapotranspiration (FAO Penman-Monteith, 1981-2010)"
  ),
  
  # =========================================================================
  # 4. RAINFALL EROSIVITY (PISCO_reed v1.0 - Gutierrez et al., 2023)
  # =========================================================================
  erosivity_r = list(
    variable = "erosivity",
    product = "PISCOa_re",
    filename = "PISCOa_re.nc",
    figshare_file_id = 42825442L,
    download_url = "https://ndownloader.figshare.com/files/42825442",
    md5 = NA_character_,
    size_bytes = 1835008L,
    size_mb = 1.75,
    resolution = "0.10 deg (~10 km)",
    timestep = "annual (2001-2020, 20 layers)",
    period = "2001-2020",
    layers = 20L,
    unit = "MJ mm ha-1 h-1 yr-1",
    source = "Figshare",
    description = "Annual rainfall erosivity factor R (2001-2020, 20 layers) at 0.10 deg"
  ),
  erosivity_density = list(
    variable = "erosivity",
    product = "PISCOa_ed",
    filename = "PISCOa_ed.nc",
    figshare_file_id = 42825439L,
    download_url = "https://ndownloader.figshare.com/files/42825439",
    md5 = NA_character_,
    size_bytes = 1835008L,
    size_mb = 1.75,
    resolution = "0.10 deg (~10 km)",
    timestep = "annual (2001-2020, 20 layers)",
    period = "2001-2020",
    layers = 20L,
    unit = "MJ ha-1 h-1",
    source = "Figshare",
    description = "Annual rainfall erosive density (ED) (2001-2020, 20 layers) at 0.10 deg"
  ),
  
  # =========================================================================
  # 5. STREAMFLOW / HYDROLOGY (PISCO_HyM - Llauca et al., 2021, 2023)
  # =========================================================================
  streamflow_monthly = list(
    variable = "streamflow",
    product = "PISCO_GR2M",
    filename = "PISCO_GR2M_v2.0.nc",
    figshare_file_id = NA_integer_,
    download_url = "https://www.hydroshare.org/resource/f1b537f338f24533af5dab946b51d215/data/contents/PISCO_GR2M_v2.0.nc",
    md5 = NA_character_,
    size_bytes = 25836912L,
    size_mb = 24.64,
    resolution = "river reaches",
    timestep = "monthly",
    period = "1981-01 to 2020-12",
    layers = 480L,
    unit = "m3/s",
    source = "HydroShare",
    description = "Monthly simulated streamflow for river reaches across Peru (GR2M, 1981-2020)"
  ),
  streamflow_daily = list(
    variable = "streamflow",
    product = "PISCO_ARNOVIC",
    filename = "PISCO_ARNOVIC_v1.1.nc",
    figshare_file_id = NA_integer_,
    download_url = "https://www.hydroshare.org/resource/f723d6c762ca45b6936dd9489bc44842/data/contents/PISCO_ARNOVIC_v1.1.nc",
    md5 = NA_character_,
    size_bytes = 783450000L,
    size_mb = 747.15,
    resolution = "river reaches",
    timestep = "daily",
    period = "1981-01-01 to 2020-12-31",
    layers = 14610L,
    unit = "m3/s",
    source = "HydroShare",
    description = "Daily simulated streamflow for river reaches across Peru (ARNOVIC, 1981-2020)"
  ),
  catchments_gr2m = list(
    variable = "streamflow",
    product = "cat_pisco_gr2m",
    filename = "cat_pisco_GR2M_v2.0.gpkg",
    figshare_file_id = NA_integer_,
    download_url = "https://www.hydroshare.org/resource/f1b537f338f24533af5dab946b51d215/data/contents/cat_pisco_GR2M_v2.0.gpkg",
    md5 = NA_character_,
    size_bytes = 105342976L,
    size_mb = 100.46,
    resolution = "vector polygons",
    timestep = "static",
    period = "1981-2020",
    layers = 1L,
    unit = "boundaries",
    source = "HydroShare",
    description = "Catchment delineations (GPKG) for PISCO GR2M streamflow reaches"
  ),
  rivers_gr2m = list(
    variable = "streamflow",
    product = "riv_pisco_gr2m",
    filename = "riv_pisco_GR2M_v2.0.gpkg",
    figshare_file_id = NA_integer_,
    download_url = "https://www.hydroshare.org/resource/f1b537f338f24533af5dab946b51d215/data/contents/riv_pisco_GR2M_v2.0.gpkg",
    md5 = NA_character_,
    size_bytes = 15917056L,
    size_mb = 15.18,
    resolution = "vector lines",
    timestep = "static",
    period = "1981-2020",
    layers = 1L,
    unit = "streamlines",
    source = "HydroShare",
    description = "River network streamlines (GPKG) for PISCO GR2M streamflow reaches"
  ),
  catchments_arnovic = list(
    variable = "streamflow",
    product = "cat_pisco_arnovic",
    filename = "cat_pisco_arnovic_v1.1.gpkg",
    figshare_file_id = NA_integer_,
    download_url = "https://www.hydroshare.org/resource/f723d6c762ca45b6936dd9489bc44842/data/contents/cat_pisco_arnovic_v1.1.gpkg",
    md5 = NA_character_,
    size_bytes = 105340928L,
    size_mb = 100.46,
    resolution = "vector polygons",
    timestep = "static",
    period = "1981-2020",
    layers = 1L,
    unit = "boundaries",
    source = "HydroShare",
    description = "Catchment delineations (GPKG) for PISCO ARNOVIC streamflow reaches"
  ),
  rivers_arnovic = list(
    variable = "streamflow",
    product = "riv_pisco_arnovic",
    filename = "riv_pisco_arnovic_v1.1.gpkg",
    figshare_file_id = NA_integer_,
    download_url = "https://www.hydroshare.org/resource/f723d6c762ca45b6936dd9489bc44842/data/contents/riv_pisco_arnovic_v1.1.gpkg",
    md5 = NA_character_,
    size_bytes = 15917056L,
    size_mb = 15.18,
    resolution = "vector lines",
    timestep = "static",
    period = "1981-2020",
    layers = 1L,
    unit = "streamlines",
    source = "HydroShare",
    description = "River network streamlines (GPKG) for PISCO ARNOVIC streamflow reaches"
  )
)

# Keep refreshed metadata outside the locked package namespace. The bundled
# object above remains the offline fallback distributed with the package.
.pisco_catalog_state <- new.env(parent = emptyenv())
.pisco_catalog_state$files <- .pisco_files

.pisco_current_files <- function() {
  .pisco_catalog_state$files
}

#' Resolve Dataset Aliases Across PISCO Variables
#'
#' @param dataset Character. Name or alias of dataset.
#' @return Canonical dataset key.
#' @noRd
.pisco_resolve_dataset <- function(dataset) {
  if (missing(dataset) || is.null(dataset) || length(dataset) == 0) {
    return("monthly")
  }
  
  key <- tolower(trimws(dataset[1]))
  
  # Strip common extensions if passed (.nc, .gpkg)
  key <- sub("\\.(nc|gpkg)$", "", key)
  
  # 1. Precipitation aliases
  if (key %in% c("monthly", "piscop_m", "m", "month", "mensual", "pr_m", "precip_monthly", "piscop_monthly")) {
    return("monthly")
  }
  if (key %in% c("daily", "piscop_d", "d", "day", "diario", "pr_d", "precip_daily", "piscop_daily")) {
    return("daily")
  }
  if (key %in% c("climatology", "piscop_clim2", "piscop_clim", "clim", "clim2", "climatologia", "normal", "pr_clim")) {
    return("climatology")
  }
  
  # 2. Temperature aliases
  if (key %in% c("tmax_daily", "piscot_tx_d", "tmax", "tx_d", "tx", "temperature_max", "tmax_daily_1981_2020_010")) {
    return("tmax_daily")
  }
  if (key %in% c("tmin_daily", "piscot_tn_d", "tmin", "tn_d", "tn", "temperature_min", "tmin_daily_1981_2020_010")) {
    return("tmin_daily")
  }
  if (key %in% c("tmax_clim", "piscot_tx_clim", "tmax_normal", "tmax_mean", "tmax_mean_1981-2010_010")) {
    return("tmax_clim")
  }
  if (key %in% c("tmin_clim", "piscot_tn_clim", "tmin_normal", "tmin_mean", "tmin_mean_1981-2010_010")) {
    return("tmin_clim")
  }
  
  # 3. Evapotranspiration aliases
  if (key %in% c("eto_clim", "piscoeo_pm", "piscoeo_pm_clim", "eto", "evapotranspiration", "eo_mean_1981-2010", "evp")) {
    return("eto_clim")
  }
  
  # 4. Erosivity aliases
  if (key %in% c("erosivity_r", "piscoa_re", "erosivity", "erosividad", "r_factor", "factor_r")) {
    return("erosivity_r")
  }
  if (key %in% c("erosivity_density", "piscoa_ed", "erosive_density", "ed", "densidad_erosiva")) {
    return("erosivity_density")
  }
  
  # 5. Streamflow aliases
  if (key %in% c("streamflow_monthly", "pisco_gr2m", "pisco_gr2m_v2.0", "caudal_mensual", "q_monthly")) {
    return("streamflow_monthly")
  }
  if (key %in% c("streamflow_daily", "pisco_arnovic", "pisco_arnovic_v1.1", "caudal_diario", "q_daily")) {
    return("streamflow_daily")
  }
  if (key %in% c("catchments_gr2m", "cat_pisco_gr2m", "cat_pisco_gr2m_v2.0", "cuencas_gr2m")) {
    return("catchments_gr2m")
  }
  if (key %in% c("rivers_gr2m", "riv_pisco_gr2m", "riv_pisco_gr2m_v2.0", "rios_gr2m")) {
    return("rivers_gr2m")
  }
  if (key %in% c("catchments_arnovic", "cat_pisco_arnovic", "cat_pisco_arnovic_v1.1", "cuencas_arnovic")) {
    return("catchments_arnovic")
  }
  if (key %in% c("rivers_arnovic", "riv_pisco_arnovic", "riv_pisco_arnovic_v1.1", "rios_arnovic")) {
    return("rivers_arnovic")
  }
  
  # Exact match in file names or list keys
  if (key %in% names(.pisco_current_files())) {
    return(key)
  }
  
  cli::cli_abort(c(
    "x" = "Unknown PISCO dataset: {.val {dataset}}.",
    "i" = "Run {.code pisco_catalog()} to see all available products across precipitation, temperature, evapotranspiration, erosivity, and streamflow."
  ))
}

#' Spatial Coverage Extent of PISCO
#'
#' @description
#' Returns the official geographic bounding coordinates for the PISCOp v3.0 domain,
#' covering Peru and its transboundary hydrologic basins (2 deg N to 19 deg S, 64 deg W to 82 deg W).
#'
#' @param format Character. Output format: `"vector"` (named numeric vector `c(xmin, ymin, xmax, ymax)`),
#'   `"bbox"` (`sf::st_bbox` object), or `"ext"` (`terra::ext` object). Default is `"vector"`.
#'
#' @return A named numeric vector, `sf::st_bbox`, or `terra::ext` representing the domain boundaries.
#' @export
#' @examples
#' pisco_extent()
#' pisco_extent("bbox")
#' pisco_extent("ext")
pisco_extent <- function(format = c("vector", "bbox", "ext")) {
  format <- match.arg(format)
  ext_vec <- .pisco_extent
  
  switch(
    format,
    vector = ext_vec,
    bbox = sf::st_bbox(
      c(xmin = ext_vec[["xmin"]], ymin = ext_vec[["ymin"]],
        xmax = ext_vec[["xmax"]], ymax = ext_vec[["ymax"]]),
      crs = sf::st_crs(.pisco_crs)
    ),
    ext = terra::ext(ext_vec[["xmin"]], ext_vec[["xmax"]], ext_vec[["ymin"]], ext_vec[["ymax"]])
  )
}

#' @rdname pisco_extent
#' @export
pisco_bbox <- function() {
  pisco_extent(format = "bbox")
}
