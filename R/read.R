#' Read PISCO Datasets as SpatRaster or sf Vector
#'
#' @description
#' Reads a PISCO dataset into memory or memory-mapped objects ([terra::SpatRaster]
#' for raster grids, or `sf` for catchment/river vector layers). If the file is
#' not present locally, it can be downloaded after the caller explicitly sets
#' `download = TRUE`.
#'
#' @param dataset Character. The dataset to load:
#'   - Precipitation: `"monthly"` (`"PISCOp_m"`), `"daily"` (`"PISCOp_d"`), `"climatology"` (`"PISCOp_clim2"`).
#'   - Temperature: `"tmax_daily"`, `"tmin_daily"`, `"tmax_clim"`, `"tmin_clim"`.
#'   - Evapotranspiration: `"eto_clim"` (`"PISCOeo_pm"`).
#'   - Erosivity: `"erosivity_r"`, `"erosivity_density"`.
#'   - Streamflow: `"streamflow_monthly"`, `"streamflow_daily"`,
#'     `"catchments_gr2m"`, `"rivers_gr2m"`, `"catchments_arnovic"`, or
#'     `"rivers_arnovic"`.
#'   Default is `"monthly"`.
#' @param file Character. Optional custom path to a PISCO NetCDF or GeoPackage file.
#'   If `NULL`, looks in the local cache.
#' @param dates Vector of dates, years, year-months, or indices to filter layers.
#'   - For daily/monthly rasters: Date objects, character dates (`"1998-01-01"`),
#'     character year-months (`c("1997-01", "1998-12")`), or numeric years (`1998` or `c(1997, 1998)`).
#'   - For climatologies (12 months): integer month numbers (`1:12`) or month names.
#' @param aoi Optional spatial object (`sf`, `SpatVector`, or bounding box vector)
#'   to crop/mask the raster upon reading. Alias for `mask`.
#' @param mask Optional spatial mask. Same as `aoi`.
#' @param download Logical. If `TRUE` and file is not cached, downloads it after
#'   this explicit request. Default is `FALSE` to avoid implicit network access.
#'
#' @return A [terra::SpatRaster] object (for gridded data) or an `sf` object (for vector hydrography).
#' @export
#' @examples
#' \dontrun{
#' # Read monthly precipitation
#' r_pr <- pisco_read("monthly")
#'
#' # Read normal maximum temperature 1981-2010
#' r_tx <- pisco_read("tmax_clim")
#'
#' # Read reference evapotranspiration climatology
#' r_eto <- pisco_read("eto_clim")
#'
#' # Read rainfall erosivity R-factor
#' r_ero <- pisco_read("erosivity_r")
#' }
pisco_read <- function(dataset = c("monthly", "daily", "climatology",
                                  "tmax_daily", "tmin_daily", "tmax_clim", "tmin_clim",
                                  "eto_clim", "erosivity_r", "erosivity_density",
                                  "streamflow_monthly", "streamflow_daily",
                                  "catchments_gr2m", "rivers_gr2m"),
                       file = NULL,
                       dates = NULL,
                       aoi = NULL,
                       mask = NULL,
                       download = FALSE) {
  # Consolidate aoi and mask
  if (is.null(mask) && !is.null(aoi)) {
    mask <- aoi
  }
  
  resolved_ds <- if (!is.null(dataset)) .pisco_resolve_dataset(dataset) else "monthly"
  info <- .pisco_current_files()[[resolved_ds]]
  
  if (is.null(file)) {
    cached_path <- file.path(pisco_cache_dir(), info$filename)
    
    if (!file.exists(cached_path)) {
      if (isTRUE(download)) {
        cli::cli_alert_info("Dataset '{resolved_ds}' not found in cache. Starting download...")
        cached_path <- pisco_download(resolved_ds)
      } else {
        cli::cli_abort(c(
          "x" = "File not found in the local cache: {.file {cached_path}}.",
          "i" = "Download it explicitly with {.code pisco_download('{resolved_ds}')}.",
          "i" = "Or call {.code pisco_read('{resolved_ds}', download = TRUE)} to authorize this download."
        ))
      }
    }
    file <- cached_path
  }
  
  if (!file.exists(file)) {
    cli::cli_abort("Specified file does not exist: {.file {file}}")
  }
  
  ext <- tolower(tools::file_ext(file))
  
  # Handle vector files (GPKG)
  if (ext == "gpkg") {
    v <- sf::st_read(file, quiet = TRUE)
    if (!is.null(mask)) {
      if (is.numeric(mask) && length(mask) == 4) {
        mask_bbox <- sf::st_bbox(c(xmin = mask[1], ymin = mask[2], xmax = mask[3], ymax = mask[4]),
                                crs = sf::st_crs(v))
        v <- sf::st_crop(v, mask_bbox)
      } else if (inherits(mask, "sf") || inherits(mask, "sfc")) {
        v <- sf::st_intersection(v, sf::st_transform(mask, sf::st_crs(v)))
      }
    }
    return(v)
  }
  
  # Load SpatRaster using terra
  r <- terra::rast(file)
  
  # Ensure CRS is set to EPSG:4326 (WGS84) if missing
  if (is.na(terra::crs(r)) || terra::crs(r) == "") {
    terra::crs(r) <- .pisco_crs
  }
  
  # Assign standard units if available
  # Assign standard units if available
  if (!is.null(info$unit)) {
    terra::units(r) <- info$unit
  }
  
  # Assign time attributes and standard layer names if missing from NetCDF (e.g. Z1 or z dimension)
  r_time <- terra::time(r)
  if (is.null(r_time) || all(is.na(r_time))) {
    n_lyrs <- terra::nlyr(r)
    ts <- if (!is.null(info$timestep)) info$timestep else ""
    
    if ((grepl("monthly", resolved_ds) || grepl("monthly", ts)) && !grepl("clim|erosivity", resolved_ds)) {
      start_ym <- "1981-01"
      if (!is.null(info$period) && grepl("^[0-9]{4}-(0[1-9]|1[0-2])", info$period)) {
        start_ym <- substr(info$period, 1, 7)
      }
      dts <- seq(as.Date(paste0(start_ym, "-01")), by = "month", length.out = n_lyrs)
      terra::time(r) <- dts
      names(r) <- format(dts, "%Y-%m")
    } else if ((grepl("daily", resolved_ds) || grepl("daily", ts)) && !grepl("clim|erosivity", resolved_ds)) {
      start_ymd <- "1981-01-01"
      if (!is.null(info$period) && grepl("^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])", info$period)) {
        start_ymd <- substr(info$period, 1, 10)
      }
      dts <- seq(as.Date(start_ymd), by = "day", length.out = n_lyrs)
      terra::time(r) <- dts
      names(r) <- format(dts, "%Y-%m-%d")
    } else if (grepl("erosivity", resolved_ds) && n_lyrs == 20) {
      # Annual time series 2001-2020
      yrs <- 2001:2020
      dts <- as.Date(paste0(yrs, "-01-01"))
      terra::time(r) <- dts
      names(r) <- paste0("year_", yrs)
    }
  }
  
  month_labels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
  
  # For 12-month climatologies, assign standard month names
  if (terra::nlyr(r) == 12 && (grepl("clim|eto|eo", resolved_ds) || 
                               all(grepl("^[0-9]+$", names(r))) || 
                               all(grepl("^[a-zA-Z]+_[0-9]+$", names(r))) || 
                               any(is.na(names(r))))) {
    names(r) <- month_labels
  }
  
  # For 13-layer erosivity rasters (Annual + 12 months)
  if (grepl("erosivity", resolved_ds) && terra::nlyr(r) == 13) {
    names(r) <- c("Annual", month_labels)
  }
  
  # Apply date / layer filtering if requested
  if (!is.null(dates)) {
    r <- .pisco_filter_dates(r, dates, resolved_ds)
  }
  
  # Apply spatial clipping if requested
  if (!is.null(mask)) {
    r <- pisco_clip(r, mask = mask)
  }
  
  r
}

#' Helper to Filter SpatRaster by Dates, Years, or Months
#' @noRd
.pisco_filter_dates <- function(r, dates, dataset_name = "monthly") {
  r_time <- terra::time(r)
  
  # Check if numeric input represents calendar years (>= 1900)
  is_years_input <- is.numeric(dates) && all(dates >= 1900 & dates <= 2100)
  
  # Special case for climatologies, erosivity, or rasters without calendar dates
  if (!is_years_input && (is.null(r_time) || all(is.na(r_time)) || grepl("clim|erosivity", dataset_name))) {
    if (is.numeric(dates)) {
      valid_idx <- dates[dates >= 1 & dates <= terra::nlyr(r)]
      if (length(valid_idx) == 0) {
        cli::cli_abort("Invalid layer/month indices for raster: {.val {dates}}")
      }
      return(r[[valid_idx]])
    }
    if (is.character(dates)) {
      matched <- which(tolower(names(r)) %in% tolower(dates))
      if (length(matched) > 0) {
        return(r[[matched]])
      }
    }
    cli::cli_warn("Raster does not contain valid time attributes. Skipping date filter.")
    return(r)
  }
  
  # Fallback: if r_time is missing but input is years, search layer names
  if (is.null(r_time) || all(is.na(r_time))) {
    if (is_years_input) {
      yrs_seq <- if (length(dates) == 2 && dates[2] > dates[1]) {
        as.character(seq(dates[1], dates[2]))
      } else {
        as.character(dates)
      }
      idx <- which(vapply(seq_len(terra::nlyr(r)), function(i) {
        any(vapply(yrs_seq, function(y) grepl(paste0("(^|[^0-9])", y, "([^0-9]|$)"), names(r)[i]), logical(1)))
      }, logical(1)))
      if (length(idx) > 0) {
        return(r[[idx]])
      }
    }
    cli::cli_abort("Raster lacks time attributes and dates cannot be matched from layer names.")
  }
  
  layer_dates <- as.Date(r_time)
  
  # Numeric years passed, e.g. 1998 or c(1997, 1998)
  if (is.numeric(dates)) {
    layer_yrs <- as.integer(format(layer_dates, "%Y"))
    if (length(dates) == 1) {
      idx <- which(layer_yrs == as.integer(dates))
    } else if (length(dates) == 2 && dates[2] > dates[1]) {
      idx <- which(layer_yrs >= dates[1] & layer_yrs <= dates[2])
    } else {
      idx <- which(layer_yrs %in% as.integer(dates))
    }
  } else if (inherits(dates, "Date") || inherits(dates, "POSIXt")) {
    dates_d <- as.Date(dates)
    if (length(dates_d) == 1) {
      idx <- which(layer_dates == dates_d)
    } else {
      idx <- which(layer_dates >= min(dates_d) & layer_dates <= max(dates_d))
    }
  } else if (is.character(dates)) {
    # Check if format is "YYYY"
    if (all(grepl("^[0-9]{4}$", dates))) {
      yrs <- as.integer(dates)
      if (length(yrs) == 1) {
        idx <- which(format(layer_dates, "%Y") == dates)
      } else {
        layer_yrs <- as.integer(format(layer_dates, "%Y"))
        idx <- which(layer_yrs >= min(yrs) & layer_yrs <= max(yrs))
      }
    } else if (all(grepl("^[0-9]{4}-[0-9]{2}$", dates))) {
      # Format "YYYY-MM"
      layer_ym <- format(layer_dates, "%Y-%m")
      if (length(dates) == 1) {
        idx <- which(layer_ym == dates)
      } else {
        idx <- which(layer_ym >= min(dates) & layer_ym <= max(dates))
      }
    } else {
      # Try coercing to Date
      parsed <- as.Date(dates)
      if (length(parsed) == 1) {
        idx <- which(layer_dates == parsed)
      } else {
        idx <- which(layer_dates >= min(parsed) & layer_dates <= max(parsed))
      }
    }
  } else {
    cli::cli_abort("Unsupported format for `dates` parameter.")
  }
  
  if (length(idx) == 0) {
    cli::cli_abort("No raster layers found within the requested date/time filter.")
  }
  
  r[[idx]]
}
