module AstroPlot

__precompile__(true)

using Unitful, UnitfulAstro
using LaTeXStrings
using Plotly
using Plots
using Statistics
using UnicodePlots

using ParallelOperations
using PhysicalParticles
using PhysicalTrees
using PhysicalMeshes

import Unitful: Units

export
    plotly_scatter,
    plotly_mesh,
    plotly_tree,
    plotly_treenode,
    plotly_peano,

    unicode_scatter,
    unicode_density,
    unicode_rotationcurve,

    rotationcurve,
    plotrotationcurve,

    rotvel,
    radialvel,
    distribution


axisunit(::Nothing) = ""
axisunit(u::Units) = string(" [", u, "]")
axisunit(s::AbstractString, u::Units) = string(s, " [", u, "]")

include("PhysicalParticles.jl")

include("mesh/cube.jl")

include("tree/octreenodes.jl")
include("tree/octree.jl")
include("tree/peano.jl")

include("Analyse.jl")

include("RotationCurve.jl")
include("Density.jl")

end