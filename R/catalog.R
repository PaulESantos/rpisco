#' Catalog of PISCO Products
#'
#' @description
#' Lists the available PISCO datasets, variables, metadata, temporal ranges,
#' resolution, official file names, hosting repositories, and local cache status
#' across the full PISCO family (SENAMHI DHI-SEH).
#'
#' @param variable Character. Variable filter: `"all"`, `"precipitation"`,
#'   `"temperature"`, `"evapotranspiration"`, `"erosivity"`, or `"streamflow"`.
#'   Default is `"all"`.
#' @param refresh Logical. If `TRUE`, explicitly refreshes the in-session
#'   metadata from the Figshare and HydroShare APIs. This never downloads data.
#'
#' @return A [tibble::tibble] containing metadata for the selected PISCO datasets.
#' @export
#' @examples
#' # Complete catalog
#' pisco_catalog()
#'
#' # Filter by variable family
#' pisco_catalog("precipitation")
#' pisco_catalog("temperature")
#' pisco_catalog("streamflow")
pisco_catalog <- function(variable = c("all", "precipitation", "temperature", 
                                      "evapotranspiration", "erosivity", "streamflow"),
                          refresh = FALSE) {
  variable <- match.arg(variable)
  if (isTRUE(refresh)) pisco_refresh_catalog(quiet = TRUE)
  cache <- pisco_cache_dir()
  
  files <- .pisco_current_files()
  keys <- names(files)
  
  if (variable != "all") {
    keys <- keys[vapply(keys, function(k) files[[k]]$variable == variable, logical(1))]
  }
  
  rows <- lapply(keys, function(key) {
    item <- files[[key]]
    fpath <- file.path(cache, item$filename)
    cached <- file.exists(fpath)
    
    tibble::tibble(
      dataset = key,
      variable = item$variable,
      product = item$product,
      filename = item$filename,
      timestep = item$timestep,
      period = item$period,
      layers = item$layers,
      resolution = item$resolution,
      unit = item$unit,
      size_mb = item$size_mb,
      source = item$source,
      cached = cached,
      download_url = item$download_url
    )
  })
  
  do.call(rbind, rows)
}

#' Citation Information for PISCO Products
#'
#' @description
#' Prints and returns official citation metadata for datasets in the PISCO
#' family and their associated scientific publications from SENAMHI and international journals.
#'
#' @param dataset Character. Filter citations for a specific dataset or group:
#'   `"all"`, `"precipitation"` (`"piscop"`), `"temperature"` (`"piscot"`),
#'   `"evapotranspiration"` (`"piscoeo"`), `"erosivity"` (`"pisco_reed"`), or
#'   `"streamflow"` (`"pisco_hym"`). Default is `"all"`.
#' @param format Character. Citation format: `"text"` (formatted string for papers/reports)
#'   or `"bibtex"` (BibTeX entry). Default is `"text"`.
#' @param variable Character. Optional alias for `dataset` for consistency with [pisco_catalog()].
#'   Default is `NULL`.
#'
#' @return A character string containing the requested citation (invisibly if printed).
#' @export
#' @examples
#' # Citation for all PISCO products
#' pisco_citation()
#'
#' # BibTeX for temperature (PISCOt v1.2)
#' pisco_citation("temperature", format = "bibtex")
#'
#' # Using variable = "precipitation"
#' pisco_citation(variable = "precipitation")
#'
#' # Citation for streamflow (PISCO_HyM)
#' pisco_citation("streamflow")
pisco_citation <- function(dataset = c("all", "precipitation", "temperature",
                                      "evapotranspiration", "erosivity", "streamflow"),
                           format = c("text", "bibtex"),
                           variable = NULL) {
  if (!missing(variable) && !is.null(variable)) {
    dataset <- variable
  }
  if (is.character(dataset) && length(dataset) == 1) {
    d_low <- tolower(trimws(dataset))
    if (d_low %in% c("piscop", "precip", "lluvia")) dataset <- "precipitation"
    if (d_low %in% c("piscot", "temp", "temperatura")) dataset <- "temperature"
    if (d_low %in% c("piscoeo", "piscoeo_pm", "eto", "evp")) dataset <- "evapotranspiration"
    if (d_low %in% c("pisco_reed", "erosividad", "r_factor")) dataset <- "erosivity"
    if (d_low %in% c("pisco_hym", "caudal", "caudales", "q")) dataset <- "streamflow"
  }
  dataset <- match.arg(dataset, choices = c("all", "precipitation", "temperature",
                                           "evapotranspiration", "erosivity", "streamflow"))
  format <- match.arg(format)
  
  # Text blocks
  text_piscop <- paste(
    "=== 1. PRECIPITACION (PISCOp v3.0 & PISCOp_h) ===",
    "Gutierrez, L. y Lavado-Casimiro, W. (2025). PISCOp (v3.0): Actualizacion de datos",
    "  grillados de precipitacion. Servicio Nacional de Meteorologia e Hidrologia del Peru - SENAMHI.",
    "  Libro disponible en: https://hdl.handle.net/20.500.12542/4183 (Deposito Legal N 2025-07014)",
    "  Dataset en Figshare: https://doi.org/10.6084/m9.figshare.32411886",
    "",
    "Precipitacion horaria (PISCOp_h):",
    "  Huerta, A., Lavado-Casimiro, W., & Felipe-Obando, O. (2022). High-resolution gridded",
    "  hourly precipitation dataset for Peru (PISCOp_h). Data in Brief, 45, 108570.",
    "  https://doi.org/10.1016/j.dib.2022.108570",
    sep = "\n"
  )
  
  text_piscot <- paste(
    "=== 2. TEMPERATURA DEL AIRE (PISCOt v1.2) ===",
    "Huerta, A., Aybar, C., Imfeld, N., Correa, K., Felipe-Obando, O., Rau, P.,",
    "  Drenkhan, F., & Lavado-Casimiro, W. (2023). High-resolution grids of daily air",
    "  temperature for Peru - the new PISCOt v1.2 dataset. Scientific Data, 10(1), 847.",
    "  https://doi.org/10.1038/s41597-023-02777-w",
    "  Dataset en Figshare: https://figshare.com/collections/5959863",
    sep = "\n"
  )
  
  text_piscoeo <- paste(
    "=== 3. EVAPOTRANSPIRACION DE REFERENCIA (PISCOeo_pm) ===",
    "Huerta, A., Bonnesoeur, V., Cuadros-Adriazola, J., Gutierrez, L., Lavado-Casimiro, W. et al. (2022).",
    "  PISCOeo_pm, a reference evapotranspiration gridded database based on FAO Penman-Monteith in Peru.",
    "  Scientific Data, 9(1), 328. https://doi.org/10.1038/s41597-022-01373-8",
    "  Dataset en Figshare: https://figshare.com/collections/5633182/3",
    sep = "\n"
  )
  
  text_erosivity <- paste(
    "=== 4. EROSIVIDAD DE LLUVIA (PISCO_reed v1.0) ===",
    "Gutierrez, L., Huerta, A., Sabino, E., Bourrel, L., Frappart, F., & Lavado-Casimiro, W. (2023).",
    "  Rainfall Erosivity in Peru: A New Gridded Dataset Based on GPM-IMERG and Comprehensive",
    "  Assessment (2000-2020). Climate, 13(6), 125. https://doi.org/10.3390/cli13060125",
    "  Dataset en Figshare: https://doi.org/10.6084/m9.figshare.24416923",
    sep = "\n"
  )
  
  text_streamflow <- paste(
    "=== 5. CAUDALES E HIDROLOGIA (PISCO_HyM) ===",
    "Caudales mensuales (PISCO_HyM_GR2M):",
    "  Llauca, H., Lavado-Casimiro, W., Montesinos, C., Santini, W., & Rau, P. (2021).",
    "  PISCO_HyM_GR2M: A model of monthly water balance in Peru (1981-2020).",
    "  Water, 13(8), 1048. https://doi.org/10.3390/w13081048",
    "  HydroShare: https://www.hydroshare.org/resource/f1b537f338f24533af5dab946b51d215/",
    "",
    "Caudales diarios (PISCO_HyM_Daily / ARNOVIC):",
    "  Llauca, H., Leon, K., & Lavado-Casimiro, W. (2023). Construction of a daily streamflow",
    "  dataset for Peru using a similarity-based regionalization approach and a hybrid",
    "  hydrological modeling framework. Journal of Hydrology: Regional Studies, 47, 101381.",
    "  https://doi.org/10.1016/j.ejrh.2023.101381",
    "  HydroShare: https://www.hydroshare.org/resource/f723d6c762ca45b6936dd9489bc44842/",
    sep = "\n"
  )
  
  # BibTeX blocks
  bib_piscop <- paste(
    "@techreport{gutierrez2025piscop,",
    "  author      = {Gutierrez, Leonardo and Lavado-Casimiro, Waldo},",
    "  title       = {{PISCOp (v3.0): Actualizaci{\\'o}n de datos grillados de precipitaci{\\'o}n}},",
    "  institution = {Servicio Nacional de Meteorolog{\\'i}a e Hidrolog{\\'i}a del Per{\\'u} (SENAMHI)},",
    "  year        = {2025},",
    "  url         = {https://hdl.handle.net/20.500.12542/4183}",
    "}",
    "",
    "@article{huerta2022piscoph,",
    "  author  = {Huerta, Adrian and Lavado-Casimiro, Waldo and Felipe-Obando, Oscar},",
    "  title   = {{High-resolution gridded hourly precipitation dataset for Peru (PISCOp\\_h)}},",
    "  journal = {Data in Brief},",
    "  volume  = {45},",
    "  pages   = {108570},",
    "  year    = {2022},",
    "  doi     = {10.1016/j.dib.2022.108570}",
    "}",
    sep = "\n"
  )
  
  bib_piscot <- paste(
    "@article{huerta2023piscot,",
    "  author  = {Huerta, Adrian and Aybar, Cesar and Imfeld, Noemi and Correa, Karen and Felipe-Obando, Oscar and Rau, Pedro and Drenkhan, Fabian and Lavado-Casimiro, Waldo},",
    "  title   = {{High-resolution grids of daily air temperature for Peru - the new PISCOt v1.2 dataset}},",
    "  journal = {Scientific Data},",
    "  volume  = {10},",
    "  number  = {1},",
    "  pages   = {847},",
    "  year    = {2023},",
    "  doi     = {10.1038/s41597-023-02777-w}",
    "}",
    sep = "\n"
  )
  
  bib_piscoeo <- paste(
    "@article{huerta2022piscoeo,",
    "  author  = {Huerta, Adrian and Bonnesoeur, Vivien and Cuadros-Adriazola, Julio and Gutierrez, Leonardo and Lavado-Casimiro, Waldo},",
    "  title   = {{PISCOeo\\_pm, a reference evapotranspiration gridded database based on FAO Penman-Monteith in Peru}},",
    "  journal = {Scientific Data},",
    "  volume  = {9},",
    "  number  = {1},",
    "  pages   = {328},",
    "  year    = {2022},",
    "  doi     = {10.1038/s41597-022-01373-8}",
    "}",
    sep = "\n"
  )
  
  bib_erosivity <- paste(
    "@article{gutierrez2023erosivity,",
    "  author  = {Gutierrez, Leonardo and Huerta, Adrian and Sabino, Edwin and Bourrel, Luc and Frappart, Frederic and Lavado-Casimiro, Waldo},",
    "  title   = {{Rainfall Erosivity in Peru: A New Gridded Dataset Based on GPM-IMERG and Comprehensive Assessment (2000--2020)}},",
    "  journal = {Climate},",
    "  volume  = {13},",
    "  number  = {6},",
    "  pages   = {125},",
    "  year    = {2023},",
    "  doi     = {10.3390/cli13060125}",
    "}",
    sep = "\n"
  )
  
  bib_streamflow <- paste(
    "@article{llauca2021gr2m,",
    "  author  = {Llauca, Harold and Lavado-Casimiro, Waldo and Montesinos, Cesar and Santini, William and Rau, Pedro},",
    "  title   = {{PISCO\\_HyM\\_GR2M: A model of monthly water balance in Peru (1981--2020)}},",
    "  journal = {Water},",
    "  volume  = {13},",
    "  number  = {8},",
    "  pages   = {1048},",
    "  year    = {2021},",
    "  doi     = {10.3390/w13081048}",
    "}",
    "",
    "@article{llauca2023arnovic,",
    "  author  = {Llauca, Harold and Leon, Karen and Lavado-Casimiro, Waldo},",
    "  title   = {{Construction of a daily streamflow dataset for Peru using a similarity-based regionalization approach and a hybrid hydrological modeling framework}},",
    "  journal = {Journal of Hydrology: Regional Studies},",
    "  volume  = {47},",
    "  pages   = {101381},",
    "  year    = {2023},",
    "  doi     = {10.1016/j.ejrh.2023.101381}",
    "}",
    sep = "\n"
  )
  
  if (format == "text") {
    chosen <- switch(
      dataset,
      all = paste(text_piscop, text_piscot, text_piscoeo, text_erosivity, text_streamflow, sep = "\n\n"),
      precipitation = text_piscop,
      temperature = text_piscot,
      evapotranspiration = text_piscoeo,
      erosivity = text_erosivity,
      streamflow = text_streamflow
    )
    cat(chosen, "\n")
    return(invisible(chosen))
  }
  
  if (format == "bibtex") {
    chosen <- switch(
      dataset,
      all = paste(bib_piscop, bib_piscot, bib_piscoeo, bib_erosivity, bib_streamflow, sep = "\n\n"),
      precipitation = bib_piscop,
      temperature = bib_piscot,
      evapotranspiration = bib_piscoeo,
      erosivity = bib_erosivity,
      streamflow = bib_streamflow
    )
    cat(chosen, "\n")
    return(invisible(chosen))
  }
}

#' @rdname pisco_citation
#' @export
pisco_cite <- function(dataset = c("all", "precipitation", "temperature",
                                   "evapotranspiration", "erosivity", "streamflow"),
                       format = c("text", "bibtex"),
                       variable = NULL) {
  pisco_citation(dataset = dataset, format = format, variable = variable)
}
