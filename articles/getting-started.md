# 1. Introducción a rpisco: Acceso al Ecosistema PISCO

## Introducción

El paquete **`rpisco`** proporciona una interfaz moderna, reproducible y
eficiente para acceder, descargar, procesar y validar el conjunto
completo de datos grillados climáticos e hidrológicos **PISCO**
(*Peruvian Interpolated data of the SENAMHI’s Climatological and
hydrological Observations*), desarrollados por la Dirección de
Hidrología y la Dirección de Meteorología del **SENAMHI** (Servicio
Nacional de Meteorología e Hidrología del Perú) junto a instituciones
colaboradoras.

``` r

library(rpisco)
library(tibble)
```

------------------------------------------------------------------------

## 1. Exploración del Catálogo de Productos PISCO

La función
[`pisco_catalog()`](https://PaulESantos.github.io/rpisco/reference/pisco_catalog.md)
permite consultar en cualquier momento los metadatos completos de toda
la familia de productos PISCO disponibles en repositorios oficiales
(Figshare y HydroShare):

``` r

# Catálogo completo (14 datasets)
cat_all <- pisco_catalog(variable = "all")
cat_all[, c("dataset", "product", "variable", "resolution", "period", "source")]
#> # A tibble: 16 × 6
#>    dataset            product           variable        resolution period source
#>    <chr>              <chr>             <chr>           <chr>      <chr>  <chr> 
#>  1 monthly            PISCOp_m          precipitation   0.10 deg … 1981-… Figsh…
#>  2 daily              PISCOp_d          precipitation   0.10 deg … 1981-… Figsh…
#>  3 climatology        PISCOp_clim2      precipitation   0.10 deg … 1991-… Figsh…
#>  4 tmax_daily         PISCOt_tx_d       temperature     0.10 deg … 1981-… Figsh…
#>  5 tmin_daily         PISCOt_tn_d       temperature     0.10 deg … 1981-… Figsh…
#>  6 tmax_clim          PISCOt_tx_clim    temperature     0.10 deg … 1981-… Figsh…
#>  7 tmin_clim          PISCOt_tn_clim    temperature     0.10 deg … 1981-… Figsh…
#>  8 eto_clim           PISCOeo_pm_clim   evapotranspira… 0.10 deg … 1981-… Figsh…
#>  9 erosivity_r        PISCOa_re         erosivity       0.10 deg … 2001-… Figsh…
#> 10 erosivity_density  PISCOa_ed         erosivity       0.10 deg … 2001-… Figsh…
#> 11 streamflow_monthly PISCO_GR2M        streamflow      river rea… 1981-… Hydro…
#> 12 streamflow_daily   PISCO_ARNOVIC     streamflow      river rea… 1981-… Hydro…
#> 13 catchments_gr2m    cat_pisco_gr2m    streamflow      vector po… 1981-… Hydro…
#> 14 rivers_gr2m        riv_pisco_gr2m    streamflow      vector li… 1981-… Hydro…
#> 15 catchments_arnovic cat_pisco_arnovic streamflow      vector po… 1981-… Hydro…
#> 16 rivers_arnovic     riv_pisco_arnovic streamflow      vector li… 1981-… Hydro…
```

### Filtrado por Familias Climáticas e Hidrológicas

Es posible filtrar el catálogo por dominio o variable de interés
mediante el parámetro `variable`:

``` r

# 1. Grillas de precipitación (PISCOp v3.0 y PISCOp_h)
pisco_catalog("precipitation")[, c("dataset", "variable", "timestep", "size_mb")]
#> # A tibble: 3 × 4
#>   dataset     variable      timestep                size_mb
#>   <chr>       <chr>         <chr>                     <dbl>
#> 1 monthly     precipitation monthly                   56.6 
#> 2 daily       precipitation daily                   1527.  
#> 3 climatology precipitation climatology (12 months)    1.83

# 2. Grillas de temperatura máxima y mínima (PISCOt v1.2)
pisco_catalog("temperature")[, c("dataset", "variable", "timestep", "period")]
#> # A tibble: 4 × 4
#>   dataset    variable    timestep                period                  
#>   <chr>      <chr>       <chr>                   <chr>                   
#> 1 tmax_daily temperature daily                   1981-01-01 to 2020-12-31
#> 2 tmin_daily temperature daily                   1981-01-01 to 2020-12-31
#> 3 tmax_clim  temperature climatology (12 months) 1981-2010 normal        
#> 4 tmin_clim  temperature climatology (12 months) 1981-2010 normal

# 3. Evapotranspiración de referencia FAO Penman-Monteith (PISCOeo_pm)
pisco_catalog("evapotranspiration")[, c("dataset", "variable", "resolution")]
#> # A tibble: 1 × 3
#>   dataset  variable           resolution       
#>   <chr>    <chr>              <chr>            
#> 1 eto_clim evapotranspiration 0.10 deg (~10 km)

# 4. Caudales y capas vectoriales de cuencas y ríos (PISCO_HyM)
pisco_catalog("streamflow")[, c("dataset", "variable", "resolution", "source")]
#> # A tibble: 6 × 4
#>   dataset            variable   resolution      source    
#>   <chr>              <chr>      <chr>           <chr>     
#> 1 streamflow_monthly streamflow river reaches   HydroShare
#> 2 streamflow_daily   streamflow river reaches   HydroShare
#> 3 catchments_gr2m    streamflow vector polygons HydroShare
#> 4 rivers_gr2m        streamflow vector lines    HydroShare
#> 5 catchments_arnovic streamflow vector polygons HydroShare
#> 6 rivers_arnovic     streamflow vector lines    HydroShare
```

------------------------------------------------------------------------

## 2. Límites Espaciales y Cobertura Oficial

Para verificar los dominios espaciales oficiales de las grillas PISCO
sobre el territorio peruano y cuencas transfronterizas:

``` r

# Vector numérico con el Bounding Box (xmin, ymin, xmax, ymax)
pisco_bbox()
#> xmin ymin xmax ymax 
#>  -82  -19  -64    2

# Objeto de extensión en formato SpatExtent de terra
pisco_extent("ext")
#> SpatExtent : -82, -64, -19, 2 (xmin, xmax, ymin, ymax)

# Objeto bounding box en formato sf::st_bbox
pisco_extent("bbox")
#> xmin ymin xmax ymax 
#>  -82  -19  -64    2
```

------------------------------------------------------------------------

## 3. Citas Científicas y Referencias Oficiales

Cada producto PISCO ha sido desarrollado mediante rigurosas
investigaciones publicadas en revistas científicas indexadas y libros
técnicos del SENAMHI. La función
[`pisco_citation()`](https://PaulESantos.github.io/rpisco/reference/pisco_citation.md)
permite generar de forma inmediata las citas académicas formales:

``` r

# Citas de precipitación (PISCOp v3.0 y PISCOp_h)
pisco_citation("precipitation", format = "text")
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

# Citas de evapotranspiración y erosividad de lluvia
pisco_citation("evapotranspiration", format = "text")
#> === 3. EVAPOTRANSPIRACION DE REFERENCIA (PISCOeo_pm) ===
#> Huerta, A., Bonnesoeur, V., Cuadros-Adriazola, J., Gutierrez, L., Lavado-Casimiro, W. et al. (2022).
#>   PISCOeo_pm, a reference evapotranspiration gridded database based on FAO Penman-Monteith in Peru.
#>   Scientific Data, 9(1), 328. https://doi.org/10.1038/s41597-022-01373-8
#>   Dataset en Figshare: https://figshare.com/collections/5633182/3
```

### Exportación en Formato BibTeX

Para integrar las citas en artículos, tesis o informes con
LaTeX/Quarto/RMarkdown:

``` r

# Entradas BibTeX para temperatura (PISCOt)
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
```

------------------------------------------------------------------------

## 4. Gestión de la Caché Local

Los archivos climáticos grillados (NetCDF) y capas vectoriales
(GeoPackage) pueden variar desde unos pocos megabytes hasta 1.5 GB. Para
evitar descargas redundantes, `rpisco` implementa un sistema inteligente
de almacenamiento en caché persistente:

``` r

# Consultar el directorio local de almacenamiento en caché
pisco_cache_dir()
#> [1] "/home/runner/.cache/R/rpisco"

# Estado de cada dataset en el almacenamiento local
cache_info <- pisco_cache_status()
head(cache_info[, c("dataset", "filename", "cached", "expected_mb")])
#> # A tibble: 6 × 4
#>   dataset     filename                    cached expected_mb
#>   <chr>       <chr>                       <lgl>        <dbl>
#> 1 monthly     PISCOp_m.nc                 FALSE        56.6 
#> 2 daily       PISCOp_d.nc                 FALSE      1527.  
#> 3 climatology PISCOp_clim2.nc             FALSE         1.83
#> 4 tmax_daily  tmax_daily_1981_2020_010.nc FALSE       603.  
#> 5 tmin_daily  tmin_daily_1981_2020_010.nc FALSE       620.  
#> 6 tmax_clim   tmax_mean_1981-2010_010.nc  FALSE         0.52
```

------------------------------------------------------------------------

## 5. Descarga y Lectura de Datos

### Descarga con `pisco_download()`

La función
[`pisco_download()`](https://PaulESantos.github.io/rpisco/reference/pisco_download.md)
realiza la descarga desde Figshare o HydroShare con verificación
automática de suma de verificación MD5 y soporte para reintentos:

``` r

# Descargar precipitación mensual PISCOp v3.0 (56.6 MB)
archivo_pr <- pisco_download("monthly")

# Descargar normales mensuales de temperatura máxima PISCOt v1.2 (0.52 MB)
archivo_tx <- pisco_download("tmax_clim")
```

### Lectura con `pisco_read()`

[`pisco_read()`](https://PaulESantos.github.io/rpisco/reference/pisco_read.md)
carga los datasets directamente como objetos nativos de R: - Objetos
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
para grillas raster. - Objetos `sf` para límites de cuencas
hidrográficas y redes de ríos.

``` r

# Carga automática (descarga si no está en caché)
r_pisco <- pisco_read("monthly", dates = c("1997-01", "1998-12"))

# Lectura directa recortando a una región geográfica específica
aoi_lima <- c(xmin = -77.5, ymin = -12.5, xmax = -76.5, ymax = -11.5)
r_lima <- pisco_read("monthly", aoi = aoi_lima)
```

En las siguientes viñetas se profundiza en el análisis espaciotemporal,
recorte con geometrías vectoriales, cálculo de anomalías y validación
frente a estaciones meteorológicas.
