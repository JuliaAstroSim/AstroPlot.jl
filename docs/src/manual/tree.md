# Plot trees

```@example tree
using AstroPlot, PhysicalTrees, PhysicalParticles
plot_peano()
```

```@example tree
plot_peano(2)
```
```@example tree
plot_peano(3)
```

```@example tree
d = randn_pvector(15)
t = octree(d)
figure, axis, plot = plot_makie(t)
figure
```