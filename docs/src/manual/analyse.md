# Analysis

```@example analysis
using AstroPlot
fig = plot_profiling("profiling.csv")
```

```@example analysis
fig = plot_energy("energy.csv")
```

```@example analysis
fig = plot_energy_delta("energy.csv")
```

```@example analysis
using AstroIO
header, data = read_gadget2("plummer/snapshot_0000.gadget2", uAstro, uGadget2)

fig = plot_densitycurve(data)
```

```@example analysis
fig = plot_rotationcurve(data)
```