#' Temporal Aggregation of PISCO Rasters
#'
#' @description
#' Aggregates a PISCO [terra::SpatRaster] across time: annual totals, monthly cycle,
#' multi-year climatology, or SENAMHI hydrological seasons (Wet: Nov–Apr, Dry: May–Oct).
#'
#' @param x A [terra::SpatRaster] with valid time attributes.
#' @param by Character. Aggregation unit:
#'   - `"year"`: Aggregates across each calendar year (e.g., annual rainfall).
#'   - `"month"`: Multi-year monthly aggregation (produces 12 layers for Jan–Dec).
#'   - `"season_senamhi"`: SENAMHI official hydrological seasons:
#'     Wet season (`wet_Nov_Apr`: Nov, Dec, Jan, Feb, Mar, Apr) and
#'     Dry season (`dry_May_Oct`: May, Jun, Jul, Aug, Sep, Oct).
#'     November and December are grouped with the following calendar year's hydrological period.
#'   - `"hydrological_year"`: Annual aggregation based on the Peruvian hydrological year
#'     starting in November (Nov 1 to Oct 31).
#'   - `"climatology"`: Multi-year monthly mean normals (12 layers).
#' @param fun Character or function. Aggregation function (`"sum"`, `"mean"`, `"max"`, etc.).
#'   Default is `"sum"` (for precipitation accumulations).
#'
#' @return An aggregated [terra::SpatRaster].
#' @export
#' @examples
#' \donttest{
#' r <- pisco_read("monthly")
#' # Annual rainfall accumulation (mm/year)
#' r_ann <- pisco_aggregate(r, by = "year", fun = "sum")
#'
#' # SENAMHI seasonal rainfall (Wet: Nov-Apr, Dry: May-Oct)
#' r_seas <- pisco_aggregate(r, by = "season_senamhi", fun = "sum")
#'
#' # Multi-year mean monthly cycle
#' r_cycle <- pisco_aggregate(r, by = "month", fun = "mean")
#' }
pisco_aggregate <- function(x,
                            by = c("year", "month", "season_senamhi", "hydrological_year", "climatology"),
                            fun = "sum") {
  if (!inherits(x, "SpatRaster")) {
    cli::cli_abort("Argument `x` must be a `terra::SpatRaster`.")
  }
  
  by <- match.arg(by)
  times <- terra::time(x)
  
  if (is.null(times) || all(is.na(times))) {
    cli::cli_abort("Raster must have valid time attributes to perform temporal aggregation.")
  }
  
  dates <- as.Date(times)
  
  if (by == "year") {
    index <- format(dates, "%Y")
    res <- terra::tapp(x, index = index, fun = fun)
    return(res)
  }
  
  if (by %in% c("month", "climatology")) {
    agg_fun <- if (by == "climatology" && missing(fun)) "mean" else fun
    index <- format(dates, "%m")
    res <- terra::tapp(x, index = index, fun = agg_fun)
    month_names <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                     "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
    unique_months <- sort(as.integer(unique(index)))
    names(res) <- month_names[unique_months]
    return(res)
  }
  
  if (by == "season_senamhi") {
    # SENAMHI official definition (Gutierrez & Lavado-Casimiro, 2025):
    # Wet season (Humeda): Nov, Dec, Jan, Feb, Mar, Apr
    # Dry season (Seca): May, Jun, Jul, Aug, Sep, Oct
    month_num <- as.integer(format(dates, "%m"))
    year_num <- as.integer(format(dates, "%Y"))
    
    # Associate Nov & Dec to the hydrological year (year + 1)
    hydro_year <- ifelse(month_num >= 11, year_num + 1, year_num)
    season_type <- ifelse(month_num %in% c(11, 12, 1, 2, 3, 4), "wet_Nov_Apr", "dry_May_Oct")
    
    index <- paste0(hydro_year, "_", season_type)
    res <- terra::tapp(x, index = index, fun = fun)
    return(res)
  }
  
  if (by == "hydrological_year") {
    month_num <- as.integer(format(dates, "%m"))
    year_num <- as.integer(format(dates, "%Y"))
    hydro_year <- ifelse(month_num >= 11, year_num + 1, year_num)
    
    res <- terra::tapp(x, index = as.character(hydro_year), fun = fun)
    return(res)
  }
}

#' Calculate Rainfall Anomalies
#'
#' @description
#' Computes precipitation anomalies relative to a baseline climatology (such as `PISCOp_clim2`
#' or a multi-year monthly mean). Anomalies can be expressed in absolute difference (mm)
#' or percentage deviation (\\%).
#'
#' @param x A monthly [terra::SpatRaster] with valid time attributes.
#' @param baseline Optional [terra::SpatRaster] of monthly normals (12 layers) representing
#'   the climatological baseline (e.g. `pisco_read("climatology")`). If `NULL`, the baseline
#'   is computed internally as the multi-year monthly mean of `x`.
#' @param type Character. Type of anomaly: `"difference"` (absolute anomaly: `x - baseline` in mm)
#'   or `"percentage"` (relative anomaly: `((x - baseline) / baseline) * 100` in \\%). Default is `"percentage"`.
#' @param eps Numeric. Small epsilon to prevent division by zero in arid regions when `type = "percentage"`.
#'   Default is 0.1 (mm).
#'
#' @return A [terra::SpatRaster] of anomalies with preserved time attributes.
#' @export
#' @examples
#' \donttest{
#' r_m <- pisco_read("monthly", dates = c(1997, 1998))
#' r_clim <- pisco_read("climatology")
#'
#' # Percentage anomaly during 1997-1998 El Nino
#' anom_pct <- pisco_anomaly(r_m, baseline = r_clim, type = "percentage")
#'
#' # Absolute difference anomaly (mm)
#' anom_diff <- pisco_anomaly(r_m, baseline = r_clim, type = "difference")
#' }
pisco_anomaly <- function(x,
                          baseline = NULL,
                          type = c("percentage", "difference"),
                          eps = 0.1) {
  if (!inherits(x, "SpatRaster")) {
    cli::cli_abort("Argument `x` must be a `terra::SpatRaster`.")
  }
  
  type <- match.arg(type)
  times <- terra::time(x)
  
  if (is.null(times) || all(is.na(times))) {
    cli::cli_abort("Raster `x` must have valid time attributes to compute monthly anomalies.")
  }
  
  dates <- as.Date(times)
  layer_months <- as.integer(format(dates, "%m"))
  
  # Compute baseline if not provided
  if (is.null(baseline)) {
    baseline <- pisco_aggregate(x, by = "climatology", fun = "mean")
  }
  
  if (!inherits(baseline, "SpatRaster") || terra::nlyr(baseline) != 12) {
    cli::cli_abort("Baseline must be a `terra::SpatRaster` with exactly 12 monthly layers.")
  }
  
  # Ensure matching extent and resolution
  if (terra::ext(baseline) != terra::ext(x) || terra::res(baseline)[1] != terra::res(x)[1]) {
    baseline <- terra::resample(baseline, x)
  }
  
  # Construct matched baseline stack for each layer in x
  baseline_matched <- baseline[[layer_months]]
  
  if (type == "difference") {
    res <- x - baseline_matched
    terra::units(res) <- "mm"
  } else {
    # Percentage anomaly: ((x - baseline) / (baseline + eps)) * 100
    res <- ((x - baseline_matched) / (baseline_matched + eps)) * 100
    terra::units(res) <- "%"
  }
  
  terra::time(res) <- times
  names(res) <- paste0("anom_", format(dates, "%Y_%m"))
  res
}
