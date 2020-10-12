using Test

using Distributed
pids = addprocs(3)
@everywhere using PhysicalTrees, PhysicalParticles, UnitfulAstro, PhysicalMeshes

using AstroPlot
using Makie

include("snapshots.jl")
include("mesh.jl")
include("tree.jl")