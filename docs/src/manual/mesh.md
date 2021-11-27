# Plot meshes

## Cube

```@example mesh
using PhysicalMeshes
using AstroPlot

c = Cube(PVector(0.0,0.0,0.0), PVector(1.0,1.0,1.0))
scene = plot_makie(c, nothing)
```

## Static Cartesian Mesh

```@repl mesh
using AstroIC
h, d = read_gadget2("plummer_unitless.gadget2", nothing, uGadget2)

m = MeshCartesianStatic(d)
unicode_projection_density(m)
```

```@example mesh
projection_density(m)
```

```@repl mesh
unicode_slice(m, :rho, 5)
```

```@example mesh
plot_slice(m, :pos, 5)
```