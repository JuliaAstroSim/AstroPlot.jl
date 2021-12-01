# Analysis

```@example analysis
using AstroPlot
scene, layout = plot_profiling("profiling.csv")
scene
```

```@example analysis
scene, layout = plot_energy("energy.csv")
scene
```

```@example analysis
scene, layout = plot_energy_delta("energy.csv")
scene
```

```@example analysis
using AstroIO
header, data = read_gadget2("plummer/snapshot_0000.gadget2", uAstro, uGadget2)

scene, layout = plot_densitycurve(data)
scene
```

```@example analysis
scene, layout = plot_rotationcurve(data)
scene
```