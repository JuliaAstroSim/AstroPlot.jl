# Mosaic view

```@example mosaic
using AstroPlot
plot_positionslice("mosaic/", "snapshot_", collect(1:9:100), ".gadget2", gadget2(),
    dpi = 300, resolution = (800,800),
    xlims = (-0.06, +0.06), ylims = (-0.06, +0.06),
    times = collect(0.0:0.00005:0.005) * u"Gyr",
);
mosaicview("mosaic", "pos_", collect(1:9:100), ".png"; fillvalue = 0.5, npad = 3, ncol = 4, rowmajor = true)
```