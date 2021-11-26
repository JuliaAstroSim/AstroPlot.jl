# AstroPlot.jl

Ready-to-use plotting functions of astrophysical N-body simulation data.

[![codecov](https://codecov.io/gh/JuliaAstroSim/AstroPlot.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaAstroSim/AstroPlot.jl)
[![][docs-dev-img]][docs-dev-url]

## Installation

```julia
]add AstroPlot
```

or

```julia
using Pkg; Pkg.add("AstroPlot")
```

or

```julia
using Pkg; Pkg.add("https://github.com/JuliaAstroSim/AstroPlot.jl")
```

To test the Package:
```julia
]test AstroPlot
```

## Documentation

- [**Dev**][docs-dev-url] &mdash; *documentation of the in-development version.*

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://juliaastrosim.github.io/AstroPlot.jl/dev

For beginners, it is highly recommended to read the [documentation of PhysicalParticles.jl](https://juliaastrosim.github.io/PhysicalParticles.jl/dev/).

## Package ecosystem

- Basic data structure: [PhysicalParticles.jl](https://github.com/JuliaAstroSim/PhysicalParticles.jl)
- File I/O: [AstroIO.jl](https://github.com/JuliaAstroSim/AstroIO.jl)
- Initial Condition: [AstroIC.jl](https://github.com/JuliaAstroSim/AstroIC.jl)
- Parallelism: [ParallelOperations.jl](https://github.com/JuliaAstroSim/ParallelOperations.jl)
- Trees: [PhysicalTrees.jl](https://github.com/JuliaAstroSim/PhysicalTrees.jl)
- Meshes: [PhysicalMeshes.jl](https://github.com/JuliaAstroSim/PhysicalMeshes.jl)
- Plotting: [AstroPlot.jl](https://github.com/JuliaAstroSim/AstroPlot.jl)
- Simulation: [ISLENT](https://github.com/JuliaAstroSim/ISLENT)