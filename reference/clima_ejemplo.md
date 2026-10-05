# Datos climatológicos de prueba para climatodiagramas

Conjunto de datos de prueba con 12 observaciones mensuales
representativas de una estación andina (julio a junio), conteniendo
temperatura media mensual y precipitación total mensual para la
construcción de climatodiagramas de Walter-Lieth.

## Usage

``` r
clima_ejemplo
```

## Format

Un data frame con 12 filas y 3 columnas:

- MES:

  Abreviatura del mes de registro (`"Jul"` a `"Jun"`).

- TMED:

  Temperatura media mensual en grados Celsius (\\^\circ\\C).

- PTOT:

  Precipitación total mensual en milímetros (mm).

## Source

Elaboración propia con datos climatológicos típicos de la región andina.

## See also

[`climatodiagrama`](https://PaulESantos.github.io/rpisco/reference/climatodiagrama.md)

## Examples

``` r
data(clima_ejemplo)
head(clima_ejemplo)
#>   MES TMED  PTOT
#> 1 Jul 10.2   4.2
#> 2 Ago 11.5   8.5
#> 3 Set 12.8  22.0
#> 4 Oct 13.5  48.0
#> 5 Nov 13.8  75.5
#> 6 Dic 13.4 120.0
```
