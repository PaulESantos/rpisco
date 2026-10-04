test_that("pisco_catalog returns expected structure and products across variables", {
  cat_all <- pisco_catalog("all")
  expect_s3_class(cat_all, "tbl_df")
  expect_gte(nrow(cat_all), 14)
  
  expected_cols <- c("dataset", "variable", "product", "filename",
                     "timestep", "period", "layers", "resolution",
                     "unit", "size_mb", "source", "cached", "download_url")
  expect_true(all(expected_cols %in% colnames(cat_all)))
  
  # Filter by variable
  cat_pr <- pisco_catalog("precipitation")
  expect_equal(nrow(cat_pr), 3)
  expect_true(all(cat_pr$variable == "precipitation"))
  
  cat_tx <- pisco_catalog("temperature")
  expect_equal(nrow(cat_tx), 4)
  expect_true(all(cat_tx$variable == "temperature"))
  
  cat_eto <- pisco_catalog("evapotranspiration")
  expect_equal(nrow(cat_eto), 1)
  expect_equal(cat_eto$product, "PISCOeo_pm_clim")
  
  cat_ero <- pisco_catalog("erosivity")
  expect_equal(nrow(cat_ero), 2)
  expect_setequal(cat_ero$product, c("PISCOa_re", "PISCOa_ed"))
  
  cat_q <- pisco_catalog("streamflow")
  expect_equal(nrow(cat_q), 6)
  expect_true(all(cat_q$source == "HydroShare"))
})

test_that("dataset alias resolver works for all variables", {
  # Precipitation
  expect_equal(.pisco_resolve_dataset("monthly"), "monthly")
  expect_equal(.pisco_resolve_dataset("PISCOp_m"), "monthly")
  expect_equal(.pisco_resolve_dataset("daily"), "daily")
  expect_equal(.pisco_resolve_dataset("climatology"), "climatology")
  
  # Temperature
  expect_equal(.pisco_resolve_dataset("tmax_daily"), "tmax_daily")
  expect_equal(.pisco_resolve_dataset("tmax"), "tmax_daily")
  expect_equal(.pisco_resolve_dataset("PISCOt_tx_d"), "tmax_daily")
  expect_equal(.pisco_resolve_dataset("tmin_daily"), "tmin_daily")
  expect_equal(.pisco_resolve_dataset("tmin"), "tmin_daily")
  expect_equal(.pisco_resolve_dataset("tmax_clim"), "tmax_clim")
  expect_equal(.pisco_resolve_dataset("tmin_clim"), "tmin_clim")
  
  # Evapotranspiration
  expect_equal(.pisco_resolve_dataset("eto_clim"), "eto_clim")
  expect_equal(.pisco_resolve_dataset("piscoeo_pm"), "eto_clim")
  expect_equal(.pisco_resolve_dataset("eto"), "eto_clim")
  
  # Erosivity
  expect_equal(.pisco_resolve_dataset("erosivity_r"), "erosivity_r")
  expect_equal(.pisco_resolve_dataset("piscoa_re"), "erosivity_r")
  expect_equal(.pisco_resolve_dataset("erosivity_density"), "erosivity_density")
  expect_equal(.pisco_resolve_dataset("piscoa_ed"), "erosivity_density")
  
  # Streamflow
  expect_equal(.pisco_resolve_dataset("streamflow_monthly"), "streamflow_monthly")
  expect_equal(.pisco_resolve_dataset("pisco_gr2m"), "streamflow_monthly")
  expect_equal(.pisco_resolve_dataset("streamflow_daily"), "streamflow_daily")
  expect_equal(.pisco_resolve_dataset("pisco_arnovic"), "streamflow_daily")
  expect_equal(.pisco_resolve_dataset("cat_pisco_arnovic"), "catchments_arnovic")
  expect_equal(.pisco_resolve_dataset("riv_pisco_arnovic"), "rivers_arnovic")
  
  expect_error(.pisco_resolve_dataset("unknown_dataset_xyz"))
})

test_that("pisco_extent and pisco_bbox return correct boundaries", {
  ext_vec <- pisco_extent("vector")
  expect_type(ext_vec, "double")
  expect_equal(ext_vec[["xmin"]], -82)
  expect_equal(ext_vec[["ymin"]], -19)
  expect_equal(ext_vec[["xmax"]], -64)
  expect_equal(ext_vec[["ymax"]], 2)
  
  bbox_obj <- pisco_bbox()
  expect_s3_class(bbox_obj, "bbox")
  expect_equal(as.numeric(bbox_obj["xmin"]), -82)
  
  ext_obj <- pisco_extent("ext")
  expect_s4_class(ext_obj, "SpatExtent")
})

test_that("pisco_citation produces text and bibtex formats across variables", {
  txt_all <- pisco_citation("all", "text")
  expect_match(txt_all, "Gutierrez, L. y Lavado-Casimiro, W.")
  expect_match(txt_all, "PISCOt v1.2")
  expect_match(txt_all, "PISCOeo_pm")
  expect_match(txt_all, "PISCO_reed")
  expect_match(txt_all, "PISCO_HyM")
  
  # Specific family citations
  txt_t <- pisco_citation("temperature")
  expect_match(txt_t, "Huerta, A., Aybar, C.")
  
  txt_q <- pisco_citation("streamflow")
  expect_match(txt_q, "Llauca, H., Lavado-Casimiro, W.")
  
  bib_t <- pisco_cite("temperature", "bibtex")
  expect_match(bib_t, "@article\\{huerta2023piscot")
  
  bib_q <- pisco_cite("streamflow", "bibtex")
  expect_match(bib_q, "@article\\{llauca2021gr2m")
  expect_match(bib_q, "@article\\{llauca2023arnovic")
  
  # Support variable = "precipitation" alias
  txt_var <- pisco_citation(variable = "precipitation")
  expect_match(txt_var, "Gutierrez, L. y Lavado-Casimiro, W.")
  
  bib_var <- pisco_cite(variable = "temperature", format = "bibtex")
  expect_match(bib_var, "@article\\{huerta2023piscot")
})
