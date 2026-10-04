#' Download PISCO Datasets
#'
#' @description
#' Downloads a PISCO dataset from official repositories (Figshare or HydroShare)
#' to the local cache directory. If the file is already cached, download is skipped
#' unless `overwrite = TRUE`.
#'
#' @param dataset Character. The dataset to download:
#'   - Precipitation: `"monthly"` (`"PISCOp_m"`), `"daily"` (`"PISCOp_d"`), `"climatology"` (`"PISCOp_clim2"`).
#'   - Temperature: `"tmax_daily"`, `"tmin_daily"`, `"tmax_clim"`, `"tmin_clim"`.
#'   - Evapotranspiration: `"eto_clim"` (`"PISCOeo_pm"`).
#'   - Erosivity: `"erosivity_r"`, `"erosivity_density"`.
#'   - Streamflow: `"streamflow_monthly"`, `"streamflow_daily"`,
#'     `"catchments_gr2m"`, `"rivers_gr2m"`, `"catchments_arnovic"`, or
#'     `"rivers_arnovic"`.
#'   Default is `"monthly"`.
#' @param destdir Character. Destination directory. Default is [pisco_cache_dir()].
#' @param overwrite Logical. If `TRUE`, re-downloads the file even if present in cache.
#' @param verify_md5 Logical. If `TRUE` and an MD5 hash is registered, validates the checksum. Default is `TRUE`.
#' @param timeout Numeric. Maximum seconds to allow for download. Default is 3600 (1 hour).
#' @param quiet Logical. If `TRUE`, suppresses progress messages. Default is `FALSE`.
#' @param refresh Logical. If `TRUE`, refreshes public repository metadata before
#'   downloading an uncached file. This is safe because calling this function is
#'   an explicit user request to download data. Default is `TRUE`.
#'
#' @return Character. The absolute path to the downloaded (or cached) file.
#' @export
#' @examples
#' \dontrun{
#' # Download monthly precipitation (56.6 MB)
#' fpath_pr <- pisco_download("monthly")
#'
#' # Download climatological normal maximum temperature (0.52 MB)
#' fpath_tx <- pisco_download("tmax_clim")
#'
#' # Download rainfall erosivity R-factor (1.75 MB)
#' fpath_re <- pisco_download("erosivity_r")
#' }
pisco_download <- function(dataset = c("monthly", "daily", "climatology",
                                      "tmax_daily", "tmin_daily", "tmax_clim", "tmin_clim",
                                      "eto_clim", "erosivity_r", "erosivity_density",
                                      "streamflow_monthly", "streamflow_daily",
                                      "catchments_gr2m", "rivers_gr2m"),
                           destdir = pisco_cache_dir(),
                           overwrite = FALSE,
                           verify_md5 = TRUE,
                           timeout = 3600,
                           quiet = FALSE,
                           refresh = TRUE) {
  dataset <- .pisco_resolve_dataset(dataset)
  info <- .pisco_current_files()[[dataset]]
  
  if (!dir.exists(destdir)) {
    dir.create(destdir, recursive = TRUE, showWarnings = FALSE)
  }
  
  target_file <- file.path(destdir, info$filename)
  
  if (file.exists(target_file) && !overwrite) {
    if (!quiet) {
      cli::cli_alert_info("Found cached file: {.file {target_file}} ({round(file.size(target_file)/(1024^2), 2)} MB). Skipping download.")
    }
    return(normalizePath(target_file, winslash = "/"))
  }

  if (isTRUE(refresh)) {
    pisco_refresh_catalog(timeout = min(timeout, 60), quiet = quiet)
    info <- .pisco_current_files()[[dataset]]
  }
  
  if (!quiet) {
    cli::cli_h2("Downloading PISCO dataset: {dataset} ({info$product})")
    cli::cli_alert_info("Variable: {.val {info$variable}} | File: {.val {info$filename}} | Size: ~{info$size_mb} MB")
    cli::cli_alert_info("Period: {.val {info$period}} | Resolution: {.val {info$resolution}}")
    cli::cli_alert_info("Source: {info$source} repository")
  }
  
  # Configure request with timeout and automatic retry
  req <- httr2::request(info$download_url)
  req <- httr2::req_timeout(req, timeout)
  req <- httr2::req_retry(req, max_tries = 3, backoff = ~ 2)
  if (!quiet) {
    req <- httr2::req_progress(req)
  }
  
  temp_download <- tempfile(pattern = "pisco_dl_", fileext = paste0(".", tools::file_ext(info$filename)))
  on.exit(if (file.exists(temp_download)) unlink(temp_download), add = TRUE)
  
  resp <- tryCatch(
    httr2::req_perform(req, path = temp_download),
    error = function(e) {
      cli::cli_abort(c(
        "x" = "Failed to download {.val {info$filename}} from {info$source}.",
        "i" = "URL: {.url {info$download_url}}",
        "i" = "Details: {e$message}"
      ))
    }
  )
  
  # Verify MD5 checksum if available and requested
  if (isTRUE(verify_md5) && !is.na(info$md5)) {
    computed_hash <- tools::md5sum(temp_download)[[1]]
    if (computed_hash != info$md5) {
      cli::cli_abort(c(
        "x" = "MD5 checksum verification failed for {info$filename}.",
        "i" = "Expected: {info$md5}",
        "i" = "Received: {computed_hash}"
      ))
    }
    if (!quiet) {
      cli::cli_alert_success("MD5 checksum verified successfully: {.val {computed_hash}}")
    }
  } else {
    # Check that file has non-zero size
    if (file.size(temp_download) < 100) {
      cli::cli_abort("Downloaded file {.file {info$filename}} is empty or corrupted.")
    }
  }
  
  # Move to destination
  file.copy(temp_download, target_file, overwrite = TRUE)
  
  if (!quiet) {
    cli::cli_alert_success("Dataset saved successfully to: {.file {target_file}}")
  }
  
  normalizePath(target_file, winslash = "/")
}
