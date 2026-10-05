#' Spatial Cropping and Masking for PISCO Rasters
#'
#' @description
#' Crops and masks a PISCO [terra::SpatRaster] using a vector polygon (`sf` or `SpatVector`),
#' an `sf::st_bbox` object, or a spatial bounding box numeric vector.
#'
#' @param x A [terra::SpatRaster] object.
#' @param mask An `sf` object, `terra::SpatVector`, `sf::st_bbox`, `terra::SpatExtent`,
#'   or numeric bounding box (`c(xmin, ymin, xmax, ymax)`).
#' @param crop_only Logical. If `TRUE`, only crops to bounding box without masking values outside polygon.
#'   Default is `FALSE`.
#' @param touches Logical. If `TRUE`, all cells touched by polygon boundaries are included in the mask.
#'   Default is `TRUE` (matching default [terra::mask()] behavior).
#' @param ... Additional arguments passed directly to [terra::crop()].
#'
#' @return A cropped (and optionally masked) [terra::SpatRaster].
#' @export
#' @examples
#' \dontrun{
#' r <- pisco_read("monthly")
#' # Crop by bounding box (e.g. Lima / Rimac basin)
#' r_sub <- pisco_clip(r, mask = c(-77.5, -12.5, -76.0, -11.5))
#'
#' # Crop and mask using an sf polygon
#' # r_basin <- pisco_clip(r, mask = basin_sf)
#' }
pisco_clip <- function(x, mask, crop_only = FALSE, touches = TRUE, ...) {
  if (!inherits(x, "SpatRaster")) {
    cli::cli_abort("Argument `x` must be a `terra::SpatRaster`.")
  }
  
  ext_x <- terra::ext(x)
  
  # Fast O(1) coordinate boundary check
  .check_overlap <- function(em) {
    if (em[2] < ext_x[1] || em[1] > ext_x[2] ||
        em[4] < ext_x[3] || em[3] > ext_x[4]) {
      cli::cli_abort("The clipping mask does not intersect the spatial extent of the raster.")
    }
  }
  
  # 1. Handle SpatExtent directly
  if (inherits(mask, "SpatExtent")) {
    .check_overlap(mask)
    return(terra::crop(x, mask, ...))
  }
  
  # 2. Handle bbox from sf
  if (inherits(mask, "bbox")) {
    ext <- terra::ext(mask[["xmin"]], mask[["xmax"]], mask[["ymin"]], mask[["ymax"]])
    .check_overlap(ext)
    return(terra::crop(x, ext, ...))
  }
  
  # 3. Handle numeric bounding box
  if (is.numeric(mask) && length(mask) == 4) {
    nms <- names(mask)
    if (!is.null(nms) && all(c("xmin", "ymin", "xmax", "ymax") %in% nms)) {
      ext <- terra::ext(mask[["xmin"]], mask[["xmax"]], mask[["ymin"]], mask[["ymax"]])
    } else {
      # Assume c(xmin, ymin, xmax, ymax)
      ext <- terra::ext(mask[1], mask[3], mask[2], mask[4])
    }
    .check_overlap(ext)
    return(terra::crop(x, ext, ...))
  }
  
  # 4. Handle sf / sfc: extract geometry only to avoid table/attribute overhead
  if (inherits(mask, "sf") || inherits(mask, "sfc")) {
    mask <- terra::vect(sf::st_geometry(mask))
  }
  
  if (!inherits(mask, "SpatVector")) {
    cli::cli_abort("Argument `mask` must be an `sf` object, `SpatVector`, `bbox`, `SpatExtent`, or numeric vector of length 4.")
  }
  
  # Ensure same CRS using native C++ same.crs comparison
  if (terra::crs(mask) != "" && !terra::same.crs(mask, x)) {
    mask <- terra::project(mask, terra::crs(x))
  }
  
  ext_m <- terra::ext(mask)
  .check_overlap(ext_m)
  
  # Crop to mask spatial bounding box first
  x_cropped <- terra::crop(x, mask, ...)
  if (isTRUE(crop_only)) {
    return(terra::setMinMax(x_cropped))
  }
  
  # Apply polygon mask to the cropped extent and compute real min/max
  res <- terra::mask(x_cropped, mask, touches = touches)
  terra::setMinMax(res)
}



