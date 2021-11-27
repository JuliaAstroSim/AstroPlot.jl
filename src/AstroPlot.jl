module AstroPlot

using Reexport
using Unitful, UnitfulAstro
using LaTeXStrings
using Printf
using Statistics
using UnicodePlots
using ProgressMeter
using DataFrames
using CSV
using GLMakie
using CairoMakie
using Colors
using ColorSchemes
using DocStringExtensions
using FileIO
using VideoIO
using Images
using StructArrays
using LoopVectorization
using Polyester

using ParallelOperations
@reexport using PhysicalParticles
@reexport using PhysicalTrees
@reexport using PhysicalMeshes
@reexport using AstroIO

import Unitful: Units
import AstroIO: jld2, gadget2, hdf5
import GLMakie: plot, plot!, Rect, scatter, scatter!

export
    unicode_scatter,
    unicode_density,
    unicode_force,
    unicode_radialforce,
    unicode_radialpotential,
    unicode_rotationcurve,

    plot_makie, plot_makie!,

    plot_peano,

    # Analyse
    rotvel,
    radialvel,
    distribution,

    rotationcurve,
    plot_rotationcurve, plot_rotationcurve!,

    densitycurve,
    plot_densitycurve, plot_densitycurve!,

    radialforce,
    plot_radialforce, plot_radialforce!,
    
    force,
    plot_force, plot_force!,
    
    radialpotential,
    plot_radialpotential, plot_radialpotential!,

    plot_trajectory, plot_trajectory!,

    plot_positionslice, plot_positionslice!,
    plot_positionslice_adapt,

    plot_energy, plot_energy!,
    plot_energy_delta, plot_energy_delta!,
    plot_energy_potential, plot_energy_potential!,
    plot_energy_kinetic, plot_energy_kinetic!,
    plot_profiling, plot_profiling!,

    plot_momentum, plot_momentum!,
    plot_momentum_angular, plot_momentum_angular!,

    lagrange_radii,
    plot_radii, plot_radii!,
    plot_scaleradius, plot_scaleradius!,
    plot_lagrangeradii, plot_lagrangeradii!,
    plot_lagrangeradii90, plot_lagrangeradii90!,

    # Mesh
    axisid,
    axis_cartesian,
    slice3d,
    projection,
    projection_density,
    unicode_projection,
    unicode_projection_density,
    unicode_slice,
    plot_slice,

    # tools
    pack_xy,
    sortarrays!,
    pos_from_center,

    # video
    png2video,
    mosaicview,

    jld2, gadget2, hdf5

# Parameters
"Control number of bins"
SectionIndex = 7.0 / 12.0

include("comments.jl")

include("PhysicalParticles.jl")

include("mesh/cube.jl")
include("mesh/slice.jl")
include("mesh/projection.jl")

include("tree/octreenodes.jl")
include("tree/octree.jl")
include("tree/peano.jl")

include("analyse/analyse.jl")
include("analyse/energy.jl")
include("analyse/rotationcurve.jl")
include("analyse/density.jl")
include("analyse/force.jl")
include("analyse/radialforce.jl")
include("analyse/radialpotential.jl")
include("analyse/momentum.jl")

include("snapshots/trajectory.jl")
include("snapshots/positions.jl")
include("snapshots/lagrange.jl")
include("snapshots/profiling.jl")

include("video.jl")
include("images.jl")

end