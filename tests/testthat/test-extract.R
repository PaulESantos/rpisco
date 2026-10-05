test_that("pisco_extract extracts point series into tidy tibbles", {
  r <- terra::rast(xmin = -82, xmax = -64, ymin = -19, ymax = 2,
                   resolution = 1, crs = "EPSG:4326", nlyrs = 12)
  terra::values(r) <- rep(10, terra::ncell(r) * 12)
  dts <- seq(as.Date("2000-01-01"), by = "month", length.out = 12)
  terra::time(r) <- dts
  
  # Point extraction with numeric vector
  pt <- c(-75.5, -10.5)
  res <- pisco_extract(r, points = pt)
  
  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 12)
  expect_equal(colnames(res), c("id", "lon", "lat", "date", "precipitation"))
  expect_equal(res$precipitation, rep(10, 12))
  expect_equal(res$lon[1], -75.5)
  expect_equal(res$lat[1], -10.5)
  
  # Point extraction with data.frame
  pts_df <- data.frame(lon = c(-75.5, -72.0), lat = c(-10.5, -13.5), st_name = c("A", "B"))
  res_df <- pisco_extract(r, points = pts_df, id_col = "st_name")
  expect_equal(nrow(res_df), 24)
  expect_equal(unique(res_df$id), c("A", "B"))
})

test_that("pisco_extract handles rasters without dates (climatology)", {
  r_clim <- terra::rast(xmin = -82, xmax = -64, ymin = -19, ymax = 2,
                        resolution = 1, crs = "EPSG:4326", nlyrs = 12)
  names(r_clim) <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                     "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
  terra::values(r_clim) <- rep(25, terra::ncell(r_clim) * 12)
  
  res <- pisco_extract(r_clim, points = c(-75.5, -10.5))
  expect_s3_class(res, "tbl_df")
  expect_equal(nrow(res), 12)
  expect_true("layer" %in% colnames(res))
  expect_equal(res$precipitation, rep(25, 12))
})

test_that("pisco_extract handles polygon zonal statistics and duplicate id aggregation", {
  r <- terra::rast(xmin = -80, xmax = -70, ymin = -15, ymax = -5,
                   resolution = 0.5, crs = "EPSG:4326", nlyrs = 6)
  terra::values(r) <- rep(1:6, each = terra::ncell(r))
  dts <- seq(as.Date("2020-01-01"), by = "month", length.out = 6)
  terra::time(r) <- dts
  
  p1 <- sf::st_buffer(sf::st_point(c(-76, -11)), 0.8)
  p2 <- sf::st_buffer(sf::st_point(c(-74, -9)), 0.8)
  poly_sf <- sf::st_sf(
    distrito = c("Distrito_A", "Distrito_B"),
    provincia = c("Provincia_X", "Provincia_X"),
    geometry = sf::st_sfc(p1, p2, crs = 4326)
  )
  
  # 1. Distinct id_col: extracts each polygon separately (2 polygons * 6 months = 12 rows)
  res_dist <- pisco_extract(r, polygons = poly_sf, id_col = "distrito")
  expect_equal(nrow(res_dist), 12)
  expect_equal(unique(res_dist$id), c("Distrito_A", "Distrito_B"))
  
  # 2. Duplicate id_col: automatically aggregates into 1 consolidated polygon (1 province * 6 months = 6 rows)
  res_prov <- pisco_extract(r, polygons = poly_sf, id_col = "provincia")
  expect_equal(nrow(res_prov), 6)
  expect_equal(unique(res_prov$id), "Provincia_X")
})

