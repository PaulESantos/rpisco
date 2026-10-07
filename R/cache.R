#' PISCO Cache Management
#'
#' @description
#' Functions to inspect, set, and clear the local cache directory used by
#' `rpisco` to store downloaded NetCDF files.
#'
#' @param path Character. Custom path to set as cache. If `NULL`, returns current cache.
#' @return A character path to the cache directory, or logical status invisibly.
#' @export
#' @examples
#' pisco_cache_dir()
#' pisco_cache_status()
pisco_cache_dir <- function(path = NULL) {
  if (is.null(path)) {
    cache <- getOption("rpisco.cache_dir", default = tools::R_user_dir("rpisco", "cache"))
    if (!dir.exists(cache)) {
      dir.create(cache, recursive = TRUE, showWarnings = FALSE)
    }
    return(cache)
  }
  
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }
  options(rpisco.cache_dir = normalizePath(path, winslash = "/", mustWork = FALSE))
  invisible(options("rpisco.cache_dir")[[1]])
}

#' @rdname pisco_cache_dir
#' @export
pisco_cache_status <- function() {
  cache <- pisco_cache_dir()
  
  files <- .pisco_current_files()
  results <- lapply(names(files), function(key) {
    info <- files[[key]]
    fpath <- file.path(cache, info$filename)
    exists <- file.exists(fpath)
    
    actual_size <- if (exists) file.size(fpath) else 0
    actual_mb <- round(actual_size / (1024^2), 2)
    
    tibble::tibble(
      dataset = key,
      filename = info$filename,
      cached = exists,
      expected_mb = info$size_mb,
      cached_mb = actual_mb,
      path = if (exists) fpath else NA_character_
    )
  })
  
  do.call(rbind, results)
}

#' @rdname pisco_cache_dir
#' @param dataset Character. Dataset name (`"monthly"`, `"daily"`, `"climatology"`),
#'   or `"all"` to remove every cached file known to `rpisco`. Files unrelated
#'   to `rpisco` are never removed.
#' @export
pisco_cache_clear <- function(dataset = "all") {
  cache <- pisco_cache_dir()
  
  if (dataset == "all") {
    files <- vapply(
      .pisco_current_files(),
      function(info) file.path(cache, info$filename),
      character(1)
    )
    files <- files[file.exists(files)]
    if (length(files) > 0) {
      unlink(files)
      cli::cli_alert_success("Cleared {length(files)} cached PISCO file(s) from {cache}.")
    } else {
      cli::cli_alert_info("No cached PISCO files found in {cache}.")
    }
    return(invisible(TRUE))
  }
  
  files <- .pisco_current_files()
  matched <- match.arg(dataset, choices = names(files))
  fpath <- file.path(cache, files[[matched]]$filename)
  if (file.exists(fpath)) {
    unlink(fpath)
    cli::cli_alert_success("Removed {matched} ({files[[matched]]$filename}) from cache.")
  } else {
    cli::cli_alert_info("Dataset '{matched}' is not present in cache.")
  }
  invisible(TRUE)
}
