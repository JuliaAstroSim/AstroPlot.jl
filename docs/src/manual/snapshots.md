# Plot snapshots

```@repl snapshots
using AstroPlot
plot_positionslice("mosaic/", "snapshot_", collect(0:100), ".gadget2", gadget2(),
    dpi = 300, resolution = (800,800),
    xlims = (-0.06, +0.06), ylims = (-0.06, +0.06),
    times = collect(0.0:0.00005:0.005) * u"Gyr",
    markersize = 5.0,
)
```

```@example snapshots
scene, layout = plot_trajectory(
    "plummer/", "snapshot_", collect(0:20:200), [1,2,3], ".gadget2", gadget2(),
)
scene
```

```@example snapshots
ScaleScene, ScaleLayout, LagrangeScene, LagrangeLayout, df = plot_radii(
    "plummer/", "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
    times = collect(0.0:0.01:0.1) * u"Gyr", title = "Direct Sum const",
)
ScaleScene
```

```@example snapshots
LagrangeScene
```