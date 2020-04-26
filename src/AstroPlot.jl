module AstroPlot

using Unitful, UnitfulAstro
using LaTeXStrings
using Printf
using Plotly
using Plots
using Statistics
using UnicodePlots
using ProgressMeter
using DataFrames
using CSV
using ApproxFun
using StatsPlots

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

    # Analyse
    rotationcurve,
    plot_rotationcurve,

    plot_trajectory,

    plot_positionslice,
    plot_positionslice_adapt,

    plot_energy,
    plot_profiling,

    rotvel,
    radialvel,
    distribution,

    lagrange_radii,
    plot_radii,

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
include("snapshots/lagrange.jl")
include("snapshots/energy.jl")
include("snapshots/profiling.jl")
include("snapshots/animation.jl")

include("RotationCurve.jl")
include("Density.jl")

end