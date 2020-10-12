module AstroPlot

using Unitful, UnitfulAstro
using LaTeXStrings
using Printf
using Statistics
using UnicodePlots
using ProgressMeter
using DataFrames
using CSV
using Makie
using Makie.AbstractPlotting.MakieLayout
using Colors

using ParallelOperations
using PhysicalParticles
using PhysicalTrees
using PhysicalMeshes
using AstroIO

import Unitful: Units
import AstroIO: jld2, gadget2, hdf5
import Makie: plot, plot!, Rect, scatter, scatter!

export
    unicode_scatter,
    unicode_density,
    unicode_rotationcurve,

    plot_makie, plot_makie!,

    plot_peano,

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
    plot_scaleradius,
    plot_lagrangeradii,
    plot_lagrangeradii90,

    jld2, gadget2, hdf5


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