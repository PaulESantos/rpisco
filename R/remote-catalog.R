#' Refresh PISCO download metadata from public repositories
#'
#' @description
#' Queries the public Figshare and HydroShare metadata APIs and refreshes the
#' download URLs, file sizes, and checksums held in the current R session. This
#' operation retrieves metadata only; it never downloads a PISCO data file.
#' It is opt-in so package loading and ordinary reads remain offline.
#'
#' @param timeout Numeric. Maximum seconds for each metadata request.
#' @param quiet Logical. If `TRUE`, suppresses informational messages.
#'
#' @return A [tibble::tibble] with refreshed metadata, invisibly.
#' @export
#' @examples
#' \dontrun{
#' pisco_refresh_catalog()
#' }
pisco_refresh_catalog <- function(timeout = 30, quiet = FALSE) {
  stopifnot(is.numeric(timeout), length(timeout) == 1, timeout > 0)

  fetch_json <- function(url) {
    req <- httr2::request(url) |>
      httr2::req_timeout(timeout) |>
      httr2::req_retry(max_tries = 3, backoff = ~ 1)
    httr2::resp_body_json(httr2::req_perform(req), simplifyVector = FALSE)
  }

  catalog <- .pisco_current_files()
  refreshed <- character()

  # Figshare returns `name`, `download_url`, `size`, and `computed_md5` for
  # every public file belonging to an article.
  for (article_id in .pisco_figshare_articles) {
    article <- tryCatch(
      fetch_json(paste0("https://api.figshare.com/v2/articles/", article_id)),
      error = function(e) {
        if (!quiet) cli::cli_warn("Could not refresh Figshare metadata: {conditionMessage(e)}")
        NULL
      }
    )
    if (is.null(article) || is.null(article$files)) next

    for (remote in article$files) {
      key <- names(catalog)[vapply(catalog, function(x) identical(x$filename, remote$name), logical(1))]
      if (!length(key)) next
      key <- key[[1]]
      catalog[[key]]$download_url <- remote$download_url
      catalog[[key]]$size_bytes <- as.numeric(remote$size)
      catalog[[key]]$size_mb <- round(as.numeric(remote$size) / 1024^2, 2)
      catalog[[key]]$md5 <- remote$computed_md5
      refreshed <- c(refreshed, key)
    }
  }

  # Unlike GET /resource/{id}/, GET /resource/{id}/files/ is read-only and
  # returns the file manifest rather than requesting creation of a BagIt archive.
  for (resource_id in .pisco_hydroshare_resources) {
    manifest <- tryCatch(
      fetch_json(paste0("https://www.hydroshare.org/hsapi/resource/", resource_id, "/files/")),
      error = function(e) {
        if (!quiet) cli::cli_warn("Could not refresh HydroShare metadata: {conditionMessage(e)}")
        NULL
      }
    )
    if (is.null(manifest) || is.null(manifest$results)) next

    for (remote in manifest$results) {
      key <- names(catalog)[vapply(catalog, function(x) identical(x$filename, remote$file_name), logical(1))]
      if (!length(key)) next
      key <- key[[1]]
      catalog[[key]]$download_url <- sub("^http://", "https://", remote$url)
      catalog[[key]]$size_bytes <- as.numeric(remote$size)
      catalog[[key]]$size_mb <- round(as.numeric(remote$size) / 1024^2, 2)
      # HydroShare reports an S3 ETag. It is an MD5 only for a single-part file.
      checksum <- if (is.null(remote$checksum)) NA_character_ else remote$checksum
      catalog[[key]]$md5 <- if (grepl("-[1]$", checksum)) sub("-[1]$", "", checksum) else NA_character_
      refreshed <- c(refreshed, key)
    }
  }

  .pisco_catalog_state$files <- catalog
  out <- pisco_catalog()
  out <- out[out$dataset %in% unique(refreshed), , drop = FALSE]
  if (!quiet) cli::cli_alert_success("Refreshed metadata for {nrow(out)} PISCO file(s).")
  invisible(out)
}
