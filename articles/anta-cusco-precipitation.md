# Precipitación PISCO para la provincia de Anta, Cusco

Este artículo muestra cómo obtener los límites oficiales de la
**provincia de Anta** (departamento de **Cusco**), conformada por sus 9
distritos (Anta, Ancahuasi, Cachimayo, Chinchaypujio, Huarocondo,
Limatambo, Mollepata, Pucyura y Zurite), y cómo procesar la
precipitación mensual grillada de PISCOp v3.0 para el periodo 2020–2024
utilizando `geoperu` y `rpisco`.

> **Nota:** Esta viñeta es deliberadamente no ejecutable durante la
> comprobación del paquete: consulta servicios externos y usa archivos
> NetCDF grandes. El código se conserva para reproducirlo de forma
> explícita en una sesión local.

## Paquetes Requeridos

``` r

# Instalar los paquetes si no están instalados
# install.packages("geoperu")
# pak::pak("PaulESantos/rpisco")

library(geoperu)
library(ggplot2)
library(rpisco)
library(sf)
library(terra)
```

## 1. Obtención de los Límites de la Provincia de Anta

A través de `geoperu`, se descarga la cartografía oficial del INEI para
la provincia de **Anta**:

``` r

# Descargar límites de la provincia de Anta (incluye sus 9 distritos)
anta_provincia <- geoperu::get_geo_peru(
  geography = "ANTA",
  level = "prov",
  simplified = FALSE,
  showProgress = FALSE
)

# Verificar distritos contenidos
print(anta_provincia[, c("departamento", "provincia", "distrito")])
```

Si se desea obtener un único polígono envolvente de toda la provincia
consolidada:

``` r

# Unir los distritos en un único polígono provincial
anta_limite_total <- sf::st_union(anta_provincia)
```

## 2. Descarga Explícita del Producto PISCOp Mensual

`rpisco` requiere autorización explícita para la descarga de datos
mediante
[`pisco_download()`](https://PaulESantos.github.io/rpisco/reference/pisco_download.md).
El archivo NetCDF (~56 MB) se almacena en la caché de usuario
([`tools::R_user_dir`](https://rdrr.io/r/tools/userdir.html)), evitando
descargas redundantes en sesiones futuras:

``` r

# Descargar PISCOp v3.0 mensual (1981-2025)
pisco_download("monthly")

# Verificar el estado de la caché local
pisco_cache_status()
```

## 3. Extracción de Series Temporales de Precipitación

Se cargan las capas correspondientes al periodo 2020–2024 y se calculan
las medias zonales mensuales para cada distrito de la provincia de Anta
utilizando
[`pisco_extract()`](https://PaulESantos.github.io/rpisco/reference/pisco_extract.md):

``` r

# Leer solo los años 2020 a 2024 desde la caché local
pisco_mensual <- pisco_read(
  dataset = "monthly",
  dates = 2020:2024
)

# Extraer el promedio espacial mensual (mm/mes) por distrito
precipitacion_distrital <- pisco_extract(
  x = pisco_mensual,
  polygons = anta_provincia,
  id_col = "distrito",
  fun = mean
)

head(precipitacion_distrital)
```

Para obtener una única serie promedio consolidada para toda la
provincia:

``` r

# Extraer el promedio espacial para toda la provincia consolidada
precipitacion_provincial <- pisco_extract(
  x = pisco_mensual,
  polygons = anta_provincia,
  id_col = "provincia",
  fun = mean
)

head(precipitacion_provincial)
```

## 4. Recorte y Enmascaramiento Espacial (`pisco_clip`)

Para aislar y visualizar la cuadrícula espacial de precipitación sobre
el ámbito territorial de la provincia de Anta, se utiliza la función
optimizada
[`pisco_clip()`](https://PaulESantos.github.io/rpisco/reference/pisco_clip.md):

``` r

# Recortar y enmascarar la grilla raster al límite de la provincia
pisco_anta <- pisco_clip(pisco_mensual, mask = anta_provincia)
```

Podemos visualizar la distribución espacial de la precipitación
utilizando los métodos gráficos base de `terra`, ajustando los márgenes
y relación de aspecto para la geometría de la provincia:

``` r

# Visualizar la precipitación del primer mes (enero de 2020) con terra
plot(
  pisco_anta[[1]],
  main = "Precipitación en la Provincia de Anta (Enero 2020)",
  plg = list(title = "mm/mes"),
  mar = c(3.2, 3.2, 2.5, 5),
  cex.main = 0.95
)
plot(sf::st_geometry(anta_provincia), add = TRUE, border = "black", lwd = 1.2)
```

O generar una visualización cartográfica con `ggplot2` y
[`geom_sf()`](https://ggplot2.tidyverse.org/reference/ggsf.html):

``` r

# Convertir la capa raster a data frame para ggplot2
df_anta <- as.data.frame(pisco_anta[[1]], xy = TRUE)
colnames(df_anta) <- c("lon", "lat", "precip")

ggplot() +
  geom_raster(data = df_anta, aes(x = lon, y = lat, fill = precip)) +
  geom_sf(data = anta_provincia, fill = NA, color = "black", linewidth = 0.5) +
  scale_fill_viridis_c(
    name = "Precipitación\n(mm/mes)",
    option = "viridis",
    na.value = "transparent"
  ) +
  coord_sf() +
  labs(
    title = "Precipitación en la Provincia de Anta (Enero 2020)",
    subtitle = "PISCOp v3.0 mensual (0.1°) - SENAMHI",
    x = "Longitud",
    y = "Latitud"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(face = "bold", size = 12),
    plot.subtitle = element_text(color = "gray30", size = 10),
    panel.grid = element_line(color = "gray90", linetype = "dotted"),
    legend.position = "right"
  )
```

## 5. Exportar Resultados

Las series temporales extraídas pueden guardarse como un archivo CSV
para análisis hidrológicos o climáticos posteriores:

``` r

utils::write.csv(
  precipitacion_distrital,
  file = "precipitacion_mensual_provincia_anta_distritos_2020_2024.csv",
  row.names = FALSE
)
```
