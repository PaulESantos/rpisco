#' Climatodiagrama de Walter-Lieth
#'
#' @description
#' Dibuja un climatodiagrama de Walter-Lieth a partir de la temperatura media
#' mensual y la precipitación media mensual de una estación meteorológica.
#' Devuelve un objeto [ggplot2::ggplot()], por lo que se puede seguir
#' modificando con `+` (temas, títulos, etc.) y guardar con
#' [ggplot2::ggsave()].
#'
#' @details
#' **Convención de Walter-Lieth.** La temperatura y la precipitación se
#' representan con una relación de 1 °C = 2 mm. Cuando la curva de
#' precipitación queda por debajo de la de temperatura el periodo es **seco**
#' (la precipitación no compensa la evapotranspiración); cuando queda por
#' encima, el periodo es **húmedo**. Por encima de 100 mm la escala de
#' precipitación se comprime 10 veces y esa zona se considera **perhúmeda**.
#'
#' **Estilos.**
#' * `estilo = "color"`: las zonas se rellenan con color y se añade una leyenda.
#' * `estilo = "trama"`: estilo clásico en blanco y negro. El periodo seco se
#'   dibuja con rayas verticales, el húmedo con puntos y el perhúmedo con
#'   relleno sólido. Los segmentos se dibujan con `geom_segment()`, así que no
#'   se necesitan paquetes adicionales. La leyenda se muestra como texto al
#'   pie del gráfico.
#'
#' **Colores.** Todos los argumentos `color_*` aceptan nombres de color de R
#' (p. ej. `"firebrick"`) o códigos hexadecimales (p. ej. `"#E8B04A"`). Si se
#' dejan en `NULL` se usan los colores por defecto del estilo elegido. En
#' `estilo = "trama"`, `color_seco` y `color_humedo` son los colores de las
#' rayas y de los puntos.
#'
#' **Datos de entrada.** `datos` debe tener exactamente 12 filas (un mes por
#' fila, en el orden en que se quieran mostrar; tradicionalmente de julio a
#' junio en el hemisferio sur). Los nombres de las columnas pueden cambiarse
#' con `col_mes`, `col_temp` y `col_prec`.
#'
#' @param datos Data frame o tibble con 12 filas y las columnas del mes, la
#'   temperatura media mensual (°C) y la precipitación media mensual (mm).
#' @param estacion Nombre de la estación meteorológica (texto).
#' @param elevacion Elevación de la estación en m s. n. m.
#' @param anios Años de registro. Un valor (`"6"`) si la temperatura y la
#'   precipitación tienen el mismo periodo de registro, o dos valores
#'   separados por un guion (`"5-6"`): el primero para la temperatura y el
#'   segundo para la precipitación.
#' @param estilo Estilo de las áreas: `"color"` (por defecto) o `"trama"`
#'   (rayas y puntos en blanco y negro). Ver *Details*.
#' @param col_mes,col_temp,col_prec Nombres de las columnas de `datos` con el
#'   mes, la temperatura media y la precipitación total. Por defecto `"MES"`,
#'   `"TMED"` y `"PTOT"`.
#' @param color_seco,color_humedo,color_perhumedo Colores de los periodos seco,
#'   húmedo y perhúmedo. En `estilo = "trama"` son los colores de las rayas
#'   (seco), los puntos (húmedo) y el relleno sólido (perhúmedo).
#' @param color_temp,color_prec Colores de las curvas de temperatura y de
#'   precipitación. También se usan para los títulos de los ejes.
#' @param color_fondo Color de fondo del panel. Por defecto `"white"`.
#' @param alpha_area Transparencia (0 a 1) del relleno de las áreas. Solo se
#'   aplica a `estilo = "color"`. Por defecto `0.85`.
#' @param grosor_linea Grosor de las curvas de temperatura y precipitación.
#'   Por defecto `1`.
#' @param densidad_trama Separación horizontal entre rayas y puntos, en
#'   unidades de mes: un valor menor da una trama más densa. Solo se aplica a
#'   `estilo = "trama"`. Por defecto `0.07`.
#' @param leyenda Si es `TRUE` (por defecto) se muestra la leyenda (o el texto
#'   explicativo en `estilo = "trama"`).
#' @param res Número de puntos usados para interpolar cada tramo entre meses.
#'   Valores más altos dan un cruce más preciso entre las curvas. Por defecto
#'   `100`.
#'
#' @return Un objeto [ggplot2::ggplot()].
#'
#' @references
#' Walter, H. y Lieth, H. (1960). *Klimadiagramm-Weltatlas*. VEB Gustav
#' Fischer Verlag, Jena.
#'
#' @seealso [clima_ejemplo] para un conjunto de datos de prueba.
#'
#' @examples
#' # Estilo con colores (por defecto)
#' climatodiagrama(clima_ejemplo,
#'                 estacion = "Estación de ejemplo", elevacion = 2000,
#'                 anios = "6")
#'
#' # Estilo clásico de rayas y puntos en blanco y negro
#' climatodiagrama(clima_ejemplo,
#'                 estacion = "Estación de ejemplo", elevacion = 2000,
#'                 anios = "6", estilo = "trama")
#'
#' # Trama con colores propios
#' climatodiagrama(clima_ejemplo,
#'                 estacion = "Estación de ejemplo", elevacion = 2000,
#'                 anios = "6", estilo = "trama",
#'                 color_seco = "#B2182B", color_humedo = "#2166AC",
#'                 color_perhumedo = "grey20")
#'
#' # Colores personalizados y años de registro distintos (temperatura-precipitación)
#' climatodiagrama(clima_ejemplo,
#'                 estacion = "Estación de ejemplo", elevacion = 2000,
#'                 anios = "5-6",
#'                 color_seco = "#D95F02", color_humedo = "#66C2A5",
#'                 color_perhumedo = "#08306B",
#'                 color_temp = "#B2182B", color_prec = "#2166AC",
#'                 color_fondo = "#FAFAF5", alpha_area = 0.9)
#'
#' # Como devuelve un ggplot, se puede seguir modificando
#' climatodiagrama(clima_ejemplo, "Estación de ejemplo", 2000, "6") +
#'   ggplot2::theme(text = ggplot2::element_text(family = "serif"))
#'
#' \dontrun{
#' # Leer los datos desde un CSV con columnas MES, TMED y PTOT
#' datos <- utils::read.csv("mis_datos.csv")
#' g <- climatodiagrama(datos, "ROCOTAL", 2010, "6")
#' ggplot2::ggsave("climatodiagrama.png", g, width = 7, height = 5.5, dpi = 300)
#' }
#' @importFrom stats approx setNames
#' @importFrom grDevices col2rgb
#' @export
climatodiagrama <- function(datos,
                            estacion,
                            elevacion,
                            anios,
                            estilo = c("color", "trama"),
                            col_mes  = "MES",
                            col_temp = "TMED",
                            col_prec = "PTOT",
                            color_seco      = NULL,
                            color_humedo    = NULL,
                            color_perhumedo = NULL,
                            color_temp      = NULL,
                            color_prec      = NULL,
                            color_fondo     = "white",
                            alpha_area      = 0.85,
                            grosor_linea    = 1,
                            densidad_trama  = 0.07,
                            leyenda         = TRUE,
                            res = 100) {

  # 1. Validación de argumentos ----------------------------------------------
  estilo   <- match.arg(estilo)
  es_trama <- estilo == "trama"

  if (!is.data.frame(datos)) {
    stop("`datos` debe ser un data frame o tibble.", call. = FALSE)
  }
  faltan <- setdiff(c(col_mes, col_temp, col_prec), names(datos))
  if (length(faltan) > 0) {
    stop("Faltan columnas en `datos`: ", paste(faltan, collapse = ", "), ".",
         call. = FALSE)
  }
  if (nrow(datos) != 12) {
    stop("Se esperan 12 filas (una por mes); `datos` tiene ", nrow(datos), ".",
         call. = FALSE)
  }
  if (length(estacion) != 1 || length(elevacion) != 1 || length(anios) != 1) {
    stop("`estacion`, `elevacion` y `anios` deben tener un solo valor.",
         call. = FALSE)
  }

  validar_color(color_seco,      "color_seco")
  validar_color(color_humedo,    "color_humedo")
  validar_color(color_perhumedo, "color_perhumedo")
  validar_color(color_temp,      "color_temp")
  validar_color(color_prec,      "color_prec")
  validar_color(color_fondo,     "color_fondo")
  validar_numero(alpha_area,     "alpha_area",     min = 0, max = 1)
  validar_numero(grosor_linea,   "grosor_linea",   min = 0, incluye_min = FALSE)
  validar_numero(densidad_trama, "densidad_trama", min = 0, incluye_min = FALSE)
  validar_numero(res,            "res",            min = 2)
  validar_logico(leyenda,        "leyenda")

  # 2. Colores por defecto según el estilo -----------------------------------
  def <- colores_defecto(estilo)
  color_seco      <- color_seco      %||% def$seco
  color_humedo    <- color_humedo    %||% def$humedo
  color_perhumedo <- color_perhumedo %||% def$perhumedo
  color_temp      <- color_temp      %||% def$temp
  color_prec      <- color_prec      %||% def$prec

  # 3. Estandarización de los datos ------------------------------------------
  base <- data.frame(
    mes  = factor(datos[[col_mes]], levels = unique(datos[[col_mes]])),
    temp = suppressWarnings(as.numeric(datos[[col_temp]])),
    prec = suppressWarnings(as.numeric(datos[[col_prec]])),
    stringsAsFactors = FALSE
  )
  base$x <- seq_len(nrow(base))

  if (anyNA(base$temp) || anyNA(base$prec)) {
    stop("Hay valores faltantes o no num\u00e9ricos en temperatura o precipitaci\u00f3n.",
         call. = FALSE)
  }
  if (any(base$prec < 0)) {
    stop("La precipitaci\u00f3n no puede ser negativa.", call. = FALSE)
  }

  base$temp2  <- 2 * base$temp                      # temperatura en escala 1:2
  base$prec_c <- comprimir_precip(base$prec)        # precipitación comprimida

  # 4. Interpolación fina ----------------------------------------------------
  fino <- calcular_bandas(seq(1, 12, length.out = 11 * res + 1), base)

  # 5. Límites y cortes de los ejes ------------------------------------------
  y_max <- max(UMBRAL_PERHUMEDO,
               ceiling(max(base$prec_c, base$temp2) * 1.12 / 20) * 20)
  y_min <- min(0, floor(min(base$temp2) / 20) * 20)   # admite temperaturas < 0 °C

  cortes_y <- seq(y_min, UMBRAL_PERHUMEDO, by = 20)
  cortes_prec_mm <- c(seq(0, UMBRAL_PERHUMEDO, by = 20),
                      seq(200, by = 200, length.out = 20))
  cortes_prec_mm <- cortes_prec_mm[comprimir_precip(cortes_prec_mm) <= y_max]

  # 6. Textos informativos ---------------------------------------------------
  etq <- etiquetas()
  txt_estacion <- paste0(estacion, " (", elevacion, " m)")
  txt_anios    <- paste0("[", anios, " a\u00f1os]")
  txt_temp     <- paste0(format(round(mean(base$temp), 1), nsmall = 1), " \u00b0C")
  txt_prec     <- paste0(format(round(sum(base$prec), 0), big.mark = ","), " mm")

  # 7. Capas de las áreas y las curvas según el estilo -----------------------
  if (!es_trama) {
    capas_area <- list(
      ggplot2::geom_ribbon(
        ggplot2::aes(ymin = .data$seco_min, ymax = .data$seco_max, fill = etq$seco),
        alpha = alpha_area
      ),
      ggplot2::geom_ribbon(
        ggplot2::aes(ymin = .data$humedo_min, ymax = .data$humedo_max, fill = etq$humedo),
        alpha = alpha_area
      ),
      ggplot2::geom_ribbon(
        ggplot2::aes(ymin = .data$perhum_min, ymax = .data$perhum_max, fill = etq$perhum)
      )
    )
    capas_curvas <- list(
      ggplot2::geom_line(ggplot2::aes(y = .data$temp2,  colour = etq$temp), linewidth = grosor_linea),
      ggplot2::geom_line(ggplot2::aes(y = .data$prec_c, colour = etq$prec), linewidth = grosor_linea)
    )
    escalas_color <- list(
      ggplot2::scale_fill_manual(
        name = NULL,
        values = stats::setNames(c(color_seco, color_humedo, color_perhumedo),
                                 c(etq$seco, etq$humedo, etq$perhum))
      ),
      ggplot2::scale_colour_manual(
        name = NULL,
        values = stats::setNames(c(color_temp, color_prec), c(etq$temp, etq$prec))
      ),
      ggplot2::guides(
        fill = ggplot2::guide_legend(order = 1),
        colour = ggplot2::guide_legend(order = 2)
      )
    )
    texto_pie <- NULL
  } else {
    # Rayas y puntos: segmentos verticales equiespaciados dentro de cada zona
    trama <- calcular_bandas(seq(1, 12, by = densidad_trama), base)
    min_grosor <- 0.2   # evita dibujar astillas donde las curvas casi se tocan

    trama_seco   <- trama[trama$seco_max - trama$seco_min > min_grosor, , drop = FALSE]
    trama_humedo <- trama[trama$humedo_max - trama$humedo_min > min_grosor, , drop = FALSE]

    capas_area <- list(
      # perhúmedo: relleno sólido
      ggplot2::geom_ribbon(
        data = fino,
        ggplot2::aes(ymin = .data$perhum_min, ymax = .data$perhum_max),
        fill = color_perhumedo
      ),
      # seco: rayas verticales continuas
      ggplot2::geom_segment(
        data = trama_seco,
        ggplot2::aes(x = .data$x, xend = .data$x,
                     y = .data$seco_min, yend = .data$seco_max),
        colour = color_seco, linewidth = 0.35, lineend = "butt"
      ),
      # húmedo: puntos (líneas verticales punteadas)
      ggplot2::geom_segment(
        data = trama_humedo,
        ggplot2::aes(x = .data$x, xend = .data$x,
                     y = .data$humedo_min, yend = .data$humedo_max),
        colour = color_humedo, linewidth = 0.45,
        linetype = "dotted", lineend = "butt"
      )
    )
    capas_curvas <- list(
      ggplot2::geom_line(ggplot2::aes(y = .data$temp2),  colour = color_temp, linewidth = grosor_linea),
      ggplot2::geom_line(ggplot2::aes(y = .data$prec_c), colour = color_prec, linewidth = grosor_linea)
    )
    escalas_color <- list()
    texto_pie <- if (leyenda) etq$trama
  }

  # 8. Gráfico ---------------------------------------------------------------
  ggplot2::ggplot(fino, ggplot2::aes(x = .data$x)) +
    capas_area +
    ggplot2::geom_hline(
      yintercept = UMBRAL_PERHUMEDO,
      linewidth = 0.3,
      linetype = "dashed",
      colour = "grey40"
    ) +
    capas_curvas +
    # Cabecera: estación, años, temperatura media y precipitación total
    ggplot2::annotate("text", x = 1,  y = y_max,         label = txt_estacion,
                      hjust = 0, vjust = 1, fontface = "bold", size = 4) +
    ggplot2::annotate("text", x = 1,  y = y_max * 0.925, label = txt_anios,
                      hjust = 0, vjust = 1, size = 3.5) +
    ggplot2::annotate("text", x = 12, y = y_max,         label = txt_temp,
                      hjust = 1, vjust = 1, size = 4) +
    ggplot2::annotate("text", x = 12, y = y_max * 0.925, label = txt_prec,
                      hjust = 1, vjust = 1, size = 3.5) +
    ggplot2::scale_x_continuous(
      breaks = base$x,
      labels = as.character(base$mes),
      expand = ggplot2::expansion(add = 0.05)
    ) +
    ggplot2::scale_y_continuous(
      name = etq$temp,
      limits = c(y_min, y_max),
      breaks = cortes_y,
      labels = function(y) y / 2,                         # posición -> °C (1 °C = 2 mm)
      expand = ggplot2::expansion(mult = c(0, 0)),
      sec.axis = ggplot2::sec_axis(
        function(y) descomprimir_precip(y),
        name = etq$prec,
        breaks = cortes_prec_mm
      )
    ) +
    escalas_color +
    ggplot2::labs(x = "Meses", caption = texto_pie) +
    ggplot2::theme_classic(base_size = 12) +
    ggplot2::theme(
      legend.position = if (!es_trama && leyenda) "bottom" else "none",
      legend.box = "vertical",
      legend.spacing.y = ggplot2::unit(0, "pt"),
      plot.caption = ggplot2::element_text(hjust = 0.5, size = 9, colour = "grey30"),
      axis.title.y.left  = ggplot2::element_text(colour = color_temp),
      axis.title.y.right = ggplot2::element_text(colour = color_prec),
      panel.background = ggplot2::element_rect(fill = color_fondo, colour = NA),
      panel.border = ggplot2::element_rect(colour = "black", fill = NA, linewidth = 0.6),
      axis.line = ggplot2::element_blank()
    )
}

# ==============================================================================
# Helper functions for Walter-Lieth Climatodiagram
# ==============================================================================

UMBRAL_PERHUMEDO <- 100

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

comprimir_precip <- function(p) {
  ifelse(p <= UMBRAL_PERHUMEDO, p, UMBRAL_PERHUMEDO + (p - UMBRAL_PERHUMEDO) / 10)
}

descomprimir_precip <- function(y) {
  ifelse(y <= UMBRAL_PERHUMEDO, y, UMBRAL_PERHUMEDO + (y - UMBRAL_PERHUMEDO) * 10)
}

calcular_bandas <- function(x_out, base) {
  t2_interp <- stats::approx(base$x, base$temp2, xout = x_out)$y
  pc_interp <- stats::approx(base$x, base$prec_c, xout = x_out)$y

  es_seco   <- pc_interp < t2_interp
  es_humedo <- pc_interp > t2_interp

  seco_min <- ifelse(es_seco, pc_interp, t2_interp)
  seco_max <- t2_interp

  h_max <- pmin(pc_interp, UMBRAL_PERHUMEDO)
  humedo_min <- ifelse(es_humedo, pmin(t2_interp, h_max), h_max)
  humedo_max <- h_max

  perhum_min <- UMBRAL_PERHUMEDO
  perhum_max <- pmax(UMBRAL_PERHUMEDO, pc_interp)

  data.frame(
    x          = x_out,
    temp2      = t2_interp,
    prec_c     = pc_interp,
    seco_min   = seco_min,
    seco_max   = seco_max,
    humedo_min = humedo_min,
    humedo_max = humedo_max,
    perhum_min = perhum_min,
    perhum_max = perhum_max,
    stringsAsFactors = FALSE
  )
}

validar_color <- function(x, nombre) {
  if (is.null(x)) return(invisible(NULL))
  if (!is.character(x) || length(x) != 1 || is.na(x)) {
    stop(sprintf("`%s` debe ser una cadena de texto con un color v\u00e1lido.", nombre), call. = FALSE)
  }
  valido <- tryCatch({
    grDevices::col2rgb(x)
    TRUE
  }, error = function(e) FALSE)
  if (!valido) {
    stop(sprintf("`%s` ('%s') no es un color v\u00e1lido en R.", nombre, x), call. = FALSE)
  }
  invisible(NULL)
}

validar_numero <- function(x, nombre, min = NULL, max = NULL, incluye_min = TRUE, incluye_max = TRUE) {
  if (!is.numeric(x) || length(x) != 1 || is.na(x)) {
    stop(sprintf("`%s` debe ser un n\u00famero \u00fanico.", nombre), call. = FALSE)
  }
  if (!is.null(min)) {
    if (incluye_min && x < min) {
      stop(sprintf("`%s` debe ser mayor o igual que %s.", nombre, min), call. = FALSE)
    } else if (!incluye_min && x <= min) {
      stop(sprintf("`%s` debe ser estrictamente mayor que %s.", nombre, min), call. = FALSE)
    }
  }
  if (!is.null(max)) {
    if (incluye_max && x > max) {
      stop(sprintf("`%s` debe ser menor o igual que %s.", nombre, max), call. = FALSE)
    } else if (!incluye_max && x >= max) {
      stop(sprintf("`%s` debe ser estrictamente menor que %s.", nombre, max), call. = FALSE)
    }
  }
  invisible(NULL)
}

validar_logico <- function(x, nombre) {
  if (!is.logical(x) || length(x) != 1 || is.na(x)) {
    stop(sprintf("`%s` debe ser TRUE o FALSE.", nombre), call. = FALSE)
  }
  invisible(NULL)
}

colores_defecto <- function(estilo = c("color", "trama")) {
  estilo <- match.arg(estilo)
  if (estilo == "color") {
    list(
      seco       = "#E8B04A",   # Dorado/naranja cálido
      humedo     = "#4575B4",   # Azul húmedo
      perhumedo  = "#08306B",   # Azul oscuro perhúmedo
      temp       = "firebrick", # Rojo curva temperatura
      prec       = "#1F78B4"    # Azul curva precipitación
    )
  } else {
    list(
      seco       = "black",
      humedo     = "black",
      perhumedo  = "black",
      temp       = "black",
      prec       = "black"
    )
  }
}

etiquetas <- function() {
  list(
    seco    = "Per\u00edodo seco",
    humedo  = "Per\u00edodo h\u00famedo",
    perhum  = "Per\u00edodo perh\u00famedo (> 100 mm)",
    temp    = "Temperatura media (\u00b0C)",
    prec    = "Precipitaci\u00f3n mensual (mm)",
    trama   = "Rayas: per\u00edodo seco | Puntos: per\u00edodo h\u00famedo | S\u00f3lido: per\u00edodo perh\u00famedo (> 100 mm)"
  )
}

utils::globalVariables(c(".data"))
