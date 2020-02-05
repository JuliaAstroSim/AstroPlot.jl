module AstroPlot

using Unitful, UnitfulAstro
using LaTeXStrings
using Plotly
using PyPlot
using Statistics
using UnicodePlots

using PhysicalParticles

import Unitful: Units

export
    plotly_scatter

include("PhysicalParticles.jl")
include("PhysicalTrees.jl")
include("PhysicalMeshes.jl")
include("RotationCurve.jl")
include("Density.jl")

end