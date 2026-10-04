# Spatial Coverage Extent of PISCO

Returns the official geographic bounding coordinates for the PISCOp v3.0
domain, covering Peru and its transboundary hydrologic basins (2 deg N
to 19 deg S, 64 deg W to 82 deg W).

## Usage

``` r
pisco_extent(format = c("vector", "bbox", "ext"))

pisco_bbox()
```

## Arguments

- format:

  Character. Output format: `"vector"` (named numeric vector
  `c(xmin, ymin, xmax, ymax)`), `"bbox"`
  ([`sf::st_bbox`](https://r-spatial.github.io/sf/reference/st_bbox.html)
  object), or `"ext"`
  ([`terra::ext`](https://rspatial.github.io/terra/reference/ext.html)
  object). Default is `"vector"`.

## Value

A named numeric vector,
[`sf::st_bbox`](https://r-spatial.github.io/sf/reference/st_bbox.html),
or [`terra::ext`](https://rspatial.github.io/terra/reference/ext.html)
representing the domain boundaries.

## Examples

``` r
pisco_extent()
#> xmin ymin xmax ymax 
#>  -82  -19  -64    2 
pisco_extent("bbox")
#> xmin ymin xmax ymax 
#>  -82  -19  -64    2 
pisco_extent("ext")
#> SpatExtent : -82, -64, -19, 2 (xmin, xmax, ymin, ymax)
```
