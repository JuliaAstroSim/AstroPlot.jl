module AstroPlot

__precompile__(true)

using Unitful, UnitfulAstro
using LaTeXStrings
using Printf
using Plotly
using Plots
using Statistics
using UnicodePlots
using ProgressMeter

using ParallelOperations
using PhysicalParticles
using PhysicalTrees
using PhysicalMeshes
using AstroIO

import Unitful: Units
import AstroIO: jld2, gadget2, hdf5

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
    plot_rotationcurve,
    plot_trajectory,
    plot_positionslice,
    plot_positionslice_adapt,

    rotvel,
    radialvel,
    distribution,

    jld2, gadget2, hdf5

pyplot()

include("PhysicalParticles.jl")

include("mesh/cube.jl")

include("tree/octreenodes.jl")
include("tree/octree.jl")
include("tree/peano.jl")

include("snapshots/analyse.jl")
include("snapshots/trajectory.jl")
include("snapshots/positions.jl")

include("RotationCurve.jl")
include("Density.jl")

end