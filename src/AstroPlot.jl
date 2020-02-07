module AstroPlot

using Unitful, UnitfulAstro
using LaTeXStrings
using Plotly
using PyPlot
using Statistics
using UnicodePlots

using PhysicalParticles
using PhysicalTrees
using PhysicalMeshes

import Unitful: Units

export
    plotly_scatter,
    plotly_mesh,
    plotly_tree,
    plotly_treenode,
    plotly_peano    


include("PhysicalParticles.jl")

include("mesh/cube.jl")

include("tree/octreenodes.jl")
include("tree/octree.jl")
include("tree/peano.jl")

include("RotationCurve.jl")
include("Density.jl")

end