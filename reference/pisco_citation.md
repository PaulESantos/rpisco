# Citation Information for PISCO Products

Prints and returns official citation metadata for datasets in the PISCO
family and their associated scientific publications from SENAMHI and
international journals.

## Usage

``` r
pisco_citation(
  dataset = c("all", "precipitation", "temperature", "evapotranspiration", "erosivity",
    "streamflow"),
  format = c("text", "bibtex"),
  variable = NULL
)

pisco_cite(
  dataset = c("all", "precipitation", "temperature", "evapotranspiration", "erosivity",
    "streamflow"),
  format = c("text", "bibtex"),
  variable = NULL
)
```

## Arguments

- dataset:

  Character. Filter citations for a specific dataset or group: `"all"`,
  `"precipitation"` (`"piscop"`), `"temperature"` (`"piscot"`),
  `"evapotranspiration"` (`"piscoeo"`), `"erosivity"` (`"pisco_reed"`),
  or `"streamflow"` (`"pisco_hym"`). Default is `"all"`.

- format:

  Character. Citation format: `"text"` (formatted string for
  papers/reports) or `"bibtex"` (BibTeX entry). Default is `"text"`.

- variable:

  Character. Optional alias for `dataset` for consistency with
  [`pisco_catalog()`](https://PaulESantos.github.io/rpisco/reference/pisco_catalog.md).
  Default is `NULL`.

## Value

A character string containing the requested citation (invisibly if
printed).

## Examples

``` r
# Citation for all PISCO products
pisco_citation()
#> === 1. PRECIPITACION (PISCOp v3.0 & PISCOp_h) ===
#> Gutierrez, L. y Lavado-Casimiro, W. (2025). PISCOp (v3.0): Actualizacion de datos
#>   grillados de precipitacion. Servicio Nacional de Meteorologia e Hidrologia del Peru - SENAMHI.
#>   Libro disponible en: https://hdl.handle.net/20.500.12542/4183 (Deposito Legal N 2025-07014)
#>   Dataset en Figshare: https://doi.org/10.6084/m9.figshare.32411886
#> 
#> Precipitacion horaria (PISCOp_h):
#>   Huerta, A., Lavado-Casimiro, W., & Felipe-Obando, O. (2022). High-resolution gridded
#>   hourly precipitation dataset for Peru (PISCOp_h). Data in Brief, 45, 108570.
#>   https://doi.org/10.1016/j.dib.2022.108570
#> 
#> === 2. TEMPERATURA DEL AIRE (PISCOt v1.2) ===
#> Huerta, A., Aybar, C., Imfeld, N., Correa, K., Felipe-Obando, O., Rau, P.,
#>   Drenkhan, F., & Lavado-Casimiro, W. (2023). High-resolution grids of daily air
#>   temperature for Peru - the new PISCOt v1.2 dataset. Scientific Data, 10(1), 847.
#>   https://doi.org/10.1038/s41597-023-02777-w
#>   Dataset en Figshare: https://figshare.com/collections/5959863
#> 
#> === 3. EVAPOTRANSPIRACION DE REFERENCIA (PISCOeo_pm) ===
#> Huerta, A., Bonnesoeur, V., Cuadros-Adriazola, J., Gutierrez, L., Lavado-Casimiro, W. et al. (2022).
#>   PISCOeo_pm, a reference evapotranspiration gridded database based on FAO Penman-Monteith in Peru.
#>   Scientific Data, 9(1), 328. https://doi.org/10.1038/s41597-022-01373-8
#>   Dataset en Figshare: https://figshare.com/collections/5633182/3
#> 
#> === 4. EROSIVIDAD DE LLUVIA (PISCO_reed v1.0) ===
#> Gutierrez, L., Huerta, A., Sabino, E., Bourrel, L., Frappart, F., & Lavado-Casimiro, W. (2023).
#>   Rainfall Erosivity in Peru: A New Gridded Dataset Based on GPM-IMERG and Comprehensive
#>   Assessment (2000-2020). Climate, 13(6), 125. https://doi.org/10.3390/cli13060125
#>   Dataset en Figshare: https://doi.org/10.6084/m9.figshare.24416923
#> 
#> === 5. CAUDALES E HIDROLOGIA (PISCO_HyM) ===
#> Caudales mensuales (PISCO_HyM_GR2M):
#>   Llauca, H., Lavado-Casimiro, W., Montesinos, C., Santini, W., & Rau, P. (2021).
#>   PISCO_HyM_GR2M: A model of monthly water balance in Peru (1981-2020).
#>   Water, 13(8), 1048. https://doi.org/10.3390/w13081048
#>   HydroShare: https://www.hydroshare.org/resource/f1b537f338f24533af5dab946b51d215/
#> 
#> Caudales diarios (PISCO_HyM_Daily / ARNOVIC):
#>   Llauca, H., Leon, K., & Lavado-Casimiro, W. (2023). Construction of a daily streamflow
#>   dataset for Peru using a similarity-based regionalization approach and a hybrid
#>   hydrological modeling framework. Journal of Hydrology: Regional Studies, 47, 101381.
#>   https://doi.org/10.1016/j.ejrh.2023.101381
#>   HydroShare: https://www.hydroshare.org/resource/f723d6c762ca45b6936dd9489bc44842/ 

# BibTeX for temperature (PISCOt v1.2)
pisco_citation("temperature", format = "bibtex")
#> @article{huerta2023piscot,
#>   author  = {Huerta, Adrian and Aybar, Cesar and Imfeld, Noemi and Correa, Karen and Felipe-Obando, Oscar and Rau, Pedro and Drenkhan, Fabian and Lavado-Casimiro, Waldo},
#>   title   = {{High-resolution grids of daily air temperature for Peru - the new PISCOt v1.2 dataset}},
#>   journal = {Scientific Data},
#>   volume  = {10},
#>   number  = {1},
#>   pages   = {847},
#>   year    = {2023},
#>   doi     = {10.1038/s41597-023-02777-w}
#> } 

# Using variable = "precipitation"
pisco_citation(variable = "precipitation")
#> === 1. PRECIPITACION (PISCOp v3.0 & PISCOp_h) ===
#> Gutierrez, L. y Lavado-Casimiro, W. (2025). PISCOp (v3.0): Actualizacion de datos
#>   grillados de precipitacion. Servicio Nacional de Meteorologia e Hidrologia del Peru - SENAMHI.
#>   Libro disponible en: https://hdl.handle.net/20.500.12542/4183 (Deposito Legal N 2025-07014)
#>   Dataset en Figshare: https://doi.org/10.6084/m9.figshare.32411886
#> 
#> Precipitacion horaria (PISCOp_h):
#>   Huerta, A., Lavado-Casimiro, W., & Felipe-Obando, O. (2022). High-resolution gridded
#>   hourly precipitation dataset for Peru (PISCOp_h). Data in Brief, 45, 108570.
#>   https://doi.org/10.1016/j.dib.2022.108570 

# Citation for streamflow (PISCO_HyM)
pisco_citation("streamflow")
#> === 5. CAUDALES E HIDROLOGIA (PISCO_HyM) ===
#> Caudales mensuales (PISCO_HyM_GR2M):
#>   Llauca, H., Lavado-Casimiro, W., Montesinos, C., Santini, W., & Rau, P. (2021).
#>   PISCO_HyM_GR2M: A model of monthly water balance in Peru (1981-2020).
#>   Water, 13(8), 1048. https://doi.org/10.3390/w13081048
#>   HydroShare: https://www.hydroshare.org/resource/f1b537f338f24533af5dab946b51d215/
#> 
#> Caudales diarios (PISCO_HyM_Daily / ARNOVIC):
#>   Llauca, H., Leon, K., & Lavado-Casimiro, W. (2023). Construction of a daily streamflow
#>   dataset for Peru using a similarity-based regionalization approach and a hybrid
#>   hydrological modeling framework. Journal of Hydrology: Regional Studies, 47, 101381.
#>   https://doi.org/10.1016/j.ejrh.2023.101381
#>   HydroShare: https://www.hydroshare.org/resource/f723d6c762ca45b6936dd9489bc44842/ 
```
