#' Extract Time Series from PISCO Rasters
#'
#' @description
#' Extracts precipitation time series from a PISCO [terra::SpatRaster] at given point
#' coordinates or computes zonal summaries (e.g. areal mean) over spatial polygons.
#'
#' @param x A [terra::SpatRaster] object.
#' @param points Optional. An `sf` point object, a matrix/data.frame with `lon` and `lat` columns,
#'   or a numeric coordinate vector `c(lon, lat)`.
#' @param polygons Optional. An `sf` polygon object or `terra::SpatVector` for zonal statistics.
#' @param fun Character or function. Summary statistic when extracting across polygons
#'   (e.g., `"mean"`, `"sum"`, `"median"`). Default is `"mean"`.
#' @param id_col Character. Name of the column in `polygons` or `points` to identify features.
#'
#' @return A [tibble::tibble] containing the extracted time series in tidy format.
#' @export
#' @examples
#' \dontrun{
#' r <- pisco_read("monthly")
#' # Extract at point coordinates (Cusco)
#' df_pt <- pisco_extract(r, points = c(-71.96, -13.53))
#'
#' # Extract areal mean over watershed polygons
#' # df_basin <- pisco_extract(r, polygons = basins_sf, id_col = "basin_name")
#' }
pisco_extract <- function(x,
                          points = NULL,
                          polygons = NULL,
                          fun = "mean",
                          id_col = NULL) {
  if (!inherits(x, "SpatRaster")) {
    cli::cli_abort("Argument `x` must be a `terra::SpatRaster`.")
  }
  
  times <- terra::time(x)
  has_valid_time <- !is.null(times) && !all(is.na(times))
  layer_labels <- if (has_valid_time) as.character(times) else names(x)
  
  # 1. Point extraction
  if (!is.null(points)) {
    pt_coords <- NULL
    
    if (is.numeric(points) && length(points) == 2) {
      pt_coords <- data.frame(lon = points[1], lat = points[2])
      v_pts <- terra::vect(pt_coords, geom = c("lon", "lat"), crs = .pisco_crs)
      ids <- 1L
    } else if (inherits(points, "sf") || inherits(points, "sfc")) {
      v_pts <- terra::vect(points)
      coords <- sf::st_coordinates(points)
      pt_coords <- data.frame(lon = coords[, 1], lat = coords[, 2])
      ids <- if (!is.null(id_col) && id_col %in% names(points)) {
        points[[id_col]]
      } else {
        seq_len(nrow(points))
      }
    } else if (is.data.frame(points) || is.matrix(points)) {
      df_pts <- as.data.frame(points)
      cnames <- tolower(colnames(df_pts))
      lon_idx <- which(cnames %in% c("lon", "longitude", "x"))[1]
      lat_idx <- which(cnames %in% c("lat", "latitude", "y"))[1]
      
      if (is.na(lon_idx) || is.na(lat_idx)) {
        lon_idx <- 1
        lat_idx <- 2
      }
      
      pt_coords <- data.frame(lon = df_pts[[lon_idx]], lat = df_pts[[lat_idx]])
      v_pts <- terra::vect(pt_coords, geom = c("lon", "lat"), crs = .pisco_crs)
      ids <- if (!is.null(id_col) && id_col %in% names(df_pts)) {
        df_pts[[id_col]]
      } else {
        seq_len(nrow(df_pts))
      }
    } else {
      cli::cli_abort("Invalid format for `points`. Provide coordinates, data.frame, or an sf point object.")
    }
    
    vals <- terra::extract(x, v_pts, ID = FALSE)
    
    res_list <- lapply(seq_len(nrow(vals)), function(i) {
      v <- as.numeric(vals[i, ])
      if (has_valid_time) {
        tibble::tibble(
          id = ids[i],
          lon = pt_coords$lon[i],
          lat = pt_coords$lat[i],
          date = as.Date(times),
          precipitation = v
        )
      } else {
        tibble::tibble(
          id = ids[i],
          lon = pt_coords$lon[i],
          lat = pt_coords$lat[i],
          layer = layer_labels,
          precipitation = v
        )
      }
    })
    
    return(do.call(rbind, res_list))
  }
  
  # 2. Polygon zonal extraction
  if (!is.null(polygons)) {
    if (inherits(polygons, "sf") || inherits(polygons, "sfc")) {
      v_poly <- terra::vect(polygons)
    } else if (inherits(polygons, "SpatVector")) {
      v_poly <- polygons
    } else {
      cli::cli_abort("Argument `polygons` must be an `sf` or `terra::SpatVector` object.")
    }
    
    # If id_col has duplicates (e.g. multiple districts under the same province),
    # aggregate geometries by id_col so zonal statistics represent the consolidated entity
    if (!is.null(id_col) && id_col %in% names(v_poly)) {
      if (anyDuplicated(v_poly[[id_col]][[1]])) {
        v_poly <- terra::aggregate(v_poly, by = id_col)
      }
      ids <- as.character(v_poly[[id_col]][[1]])
    } else {
      ids <- if (!is.null(id_col) && id_col %in% names(v_poly)) {
        as.character(v_poly[[id_col]][[1]])
      } else {
        seq_len(nrow(v_poly))
      }
    }

    
    # Ensure matching CRS
    if (terra::crs(v_poly) != "" && !terra::same.crs(v_poly, x)) {
      v_poly <- terra::project(v_poly, terra::crs(x))
    }
    
    vals <- terra::extract(x, v_poly, fun = fun, na.rm = TRUE, ID = FALSE)

    
    res_list <- lapply(seq_len(nrow(vals)), function(i) {
      v <- as.numeric(vals[i, ])
      if (has_valid_time) {
        tibble::tibble(
          id = ids[i],
          date = as.Date(times),
          precipitation = v
        )
      } else {
        tibble::tibble(
          id = ids[i],
          layer = layer_labels,
          precipitation = v
        )
      }
    })
    
    return(do.call(rbind, res_list))
  }
  
  cli::cli_abort("Must provide either `points` or `polygons` for extraction.")
}
