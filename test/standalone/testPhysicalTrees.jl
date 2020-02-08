@info "Loading"
using PhysicalParticles

using Distributed
pids = addprocs(4)
@everywhere using PhysicalTrees

include("..\\..\\src\\AstroPlot.jl")
# include("AstroPlot.jl/src/AstroPlot.jl")
using Main.AstroPlot

using Plotly

d = randn_pvector(50)
t = octree(d, pids = [1])

@info "Plotting tree"
p = plotly_tree(t)

Plotly.plot(p)