test_that("climatodiagrama works with default color style on clima_ejemplo", {
  data("clima_ejemplo", package = "rpisco")
  expect_equal(nrow(clima_ejemplo), 12)

  p <- climatodiagrama(
    datos = clima_ejemplo,
    estacion = "Estación Cusco",
    elevacion = 3249,
    anios = "1981-2016",
    estilo = "color"
  )

  expect_s3_class(p, "ggplot")
})

test_that("climatodiagrama works with trama style", {
  data("clima_ejemplo", package = "rpisco")

  p <- climatodiagrama(
    datos = clima_ejemplo,
    estacion = "Estación Cusco",
    elevacion = 3249,
    anios = "1981-2016",
    estilo = "trama"
  )

  expect_s3_class(p, "ggplot")
})

test_that("climatodiagrama supports custom column names and colors", {
  df_custom <- data.frame(
    month = c("Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Set", "Oct", "Nov", "Dic"),
    temperatura = c(12, 12.5, 13, 12.8, 12, 11, 10.5, 11.2, 12, 12.8, 13.1, 12.6),
    lluvia = c(150, 140, 100, 45, 10, 5, 2, 8, 25, 50, 80, 115)
  )

  p <- climatodiagrama(
    datos = df_custom,
    estacion = "Andes Centrales",
    elevacion = 2800,
    anios = "30",
    col_mes = "month",
    col_temp = "temperatura",
    col_prec = "lluvia",
    color_seco = "#FFA500",
    color_humedo = "#1E90FF",
    color_perhumedo = "#00008B",
    color_temp = "red",
    color_prec = "blue"
  )

  expect_s3_class(p, "ggplot")
})

test_that("climatodiagrama validates input parameters correctly", {
  data("clima_ejemplo", package = "rpisco")

  # datos not a data.frame
  expect_error(
    climatodiagrama(1:10, "Est", 2000, "10"),
    "`datos` debe ser un data frame o tibble"
  )

  # wrong number of rows
  expect_error(
    climatodiagrama(clima_ejemplo[1:10, ], "Est", 2000, "10"),
    "Se esperan 12 filas"
  )

  # missing columns
  expect_error(
    climatodiagrama(clima_ejemplo[, 1:2], "Est", 2000, "10"),
    "Faltan columnas en `datos`: PTOT"
  )

  # non-numeric temperature
  bad_df <- clima_ejemplo
  bad_df$TMED[1] <- "no_number"
  expect_error(
    climatodiagrama(bad_df, "Est", 2000, "10"),
    "Hay valores faltantes o no numéricos"
  )

  # negative precipitation
  bad_prec <- clima_ejemplo
  bad_prec$PTOT[1] <- -5
  expect_error(
    climatodiagrama(bad_prec, "Est", 2000, "10"),
    "La precipitación no puede ser negativa"
  )

  # invalid color
  expect_error(
    climatodiagrama(clima_ejemplo, "Est", 2000, "10", color_seco = "not_a_valid_color_xyz"),
    "no es un color válido en R"
  )

  # invalid numeric bounds
  expect_error(
    climatodiagrama(clima_ejemplo, "Est", 2000, "10", alpha_area = 1.5),
    "menor o igual que 1"
  )
})
