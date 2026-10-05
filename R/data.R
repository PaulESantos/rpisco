#' Datos climatológicos de prueba para climatodiagramas
#'
#' @description
#' Conjunto de datos de prueba con 12 observaciones mensuales representativas
#' de una estación andina (julio a junio), conteniendo temperatura media mensual
#' y precipitación total mensual para la construcción de climatodiagramas
#' de Walter-Lieth.
#'
#' @format Un data frame con 12 filas y 3 columnas:
#' \describe{
#'   \item{MES}{Abreviatura del mes de registro (\code{"Jul"} a \code{"Jun"}).}
#'   \item{TMED}{Temperatura media mensual en grados Celsius (\eqn{^\circ}C).}
#'   \item{PTOT}{Precipitación total mensual en milímetros (mm).}
#' }
#' @source Elaboración propia con datos climatológicos típicos de la región andina.
#' @seealso \code{\link{climatodiagrama}}
#' @examples
#' data(clima_ejemplo)
#' head(clima_ejemplo)
"clima_ejemplo"
