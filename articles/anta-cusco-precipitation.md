# Precipitación PISCO para el distrito de Anta, Cusco

Este ejemplo obtiene el límite oficial del distrito de **Anta**,
provincia de **Anta**, departamento de **Cusco**, y calcula la
precipitación mensual media espacial de PISCOp para 2020–2024. `geoperu`
entrega límites administrativos del INEI como objetos `sf`, que se
pueden usar directamente con `rpisco`.

No se ejecuta código en esta viñeta: la descarga de PISCO es una acción
explícita del usuario y el archivo mensual ocupa aproximadamente 54 MB.

## Paquetes

``` r

# Instalar una sola vez, si fuera necesario
install.packages("geoperu")
# pak::pak("PaulESantos/rpisco")  # versión de desarrollo de rpisco

library(geoperu)
library(rpisco)
```

## 1. Obtener y verificar el distrito

Se consulta Cusco sin simplificar para obtener los polígonos
distritales; luego se filtra con ambos nombres administrativos. Usar los
dos campos evita confundir un distrito homónimo de otra provincia.

``` r

cusco_distritos <- geoperu::get_geo_peru(
  geography = "CUSCO",
  level = "dep",
  simplified = FALSE,
  showProgress = FALSE
)

anta <- cusco_distritos[
  cusco_distritos$provincia == "ANTA" &
    cusco_distritos$distrito == "ANTA",
]

stopifnot(nrow(anta) == 1L)
anta[, c("departamento", "provincia", "distrito")]
```

## 2. Descargar PISCOp mensual una vez

Esta llamada es el consentimiento explícito para descargar. `rpisco`
conserva el NetCDF en su caché de usuario; en ejecuciones posteriores
[`pisco_read()`](https://PaulESantos.github.io/rpisco/reference/pisco_read.md)
usa ese archivo local y no inicia ninguna descarga.

``` r

pisco_download("monthly")
pisco_cache_status()
```

## 3. Recuperar la precipitación del área

[`pisco_read()`](https://PaulESantos.github.io/rpisco/reference/pisco_read.md)
carga únicamente los meses solicitados.
[`pisco_extract()`](https://PaulESantos.github.io/rpisco/reference/pisco_extract.md)
calcula la media de las celdas que intersectan el polígono y retorna una
tabla ordenada. La unidad de `precipitation` es **mm/mes**.

``` r

pisco_mensual <- pisco_read(
  dataset = "monthly",
  dates = 2020:2024
)

precipitacion_anta <- pisco_extract(
  x = pisco_mensual,
  polygons = anta,
  id_col = "distrito",
  fun = mean
)

head(precipitacion_anta)
```

Para trabajar solamente con las celdas del distrito (por ejemplo, para
crear un mapa), se puede recortar y enmascarar el raster:

``` r

pisco_anta <- pisco_clip(pisco_mensual, mask = anta)
plot(pisco_anta[[1]], main = "Precipitación en Anta: enero de 2020")
plot(sf::st_geometry(anta), add = TRUE, border = "black", lwd = 2)
```

## 4. Guardar la serie resultante

La exportación también es deliberada. El CSV contiene una fila por mes y
la precipitación media areal del distrito.

``` r

utils::write.csv(
  precipitacion_anta,
  file = "precipitacion_mensual_anta_cusco_2020_2024.csv",
  row.names = FALSE
)
```
