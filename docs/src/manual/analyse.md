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
scene, layout = plot_densitycurve(data)
scene
```

```@example analysis
scene, layout = plot_rotationcurve(data)
scene
```