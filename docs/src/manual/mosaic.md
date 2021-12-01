# Mosaic view

```@example mosaic
using AstroPlot
mosaicview("mosaic", "pos_", collect(1:9:100), ".png"; fillvalue = 0.5, npad = 3, ncol = 4, rowmajor = true)
```