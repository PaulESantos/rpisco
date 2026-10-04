# Plot SpatRaster and SpatVector Objects

S3 plot methods for
[terra::SpatRaster](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
and
[terra::SpatVector](https://rspatial.github.io/terra/reference/SpatVector-class.html)
objects, ensuring that `plot(r)` works seamlessly when `rpisco` is
loaded, even if [`library(terra)`](https://rspatial.org/) has not been
explicitly attached.

## Usage

``` r
# S3 method for class 'SpatRaster'
plot(x, y, ...)

# S3 method for class 'SpatVector'
plot(x, y, ...)
```

## Arguments

- x:

  A
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  or
  [`terra::SpatVector`](https://rspatial.github.io/terra/reference/SpatVector-class.html)
  object.

- y:

  Optional second argument for bivariate plotting in terra.

- ...:

  Additional graphical parameters forwarded to
  [`terra::plot()`](https://rspatial.github.io/terra/reference/plot.html).

## Value

Invisibly returns the plotted object or `NULL`, creating a plot on the
active device.
