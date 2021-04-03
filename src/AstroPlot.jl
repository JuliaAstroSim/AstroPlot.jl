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
using AbstractPlotting.MakieLayout
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
    unicode_radialforce,
    unicode_radialpotential,
    unicode_rotationcurve,

    plot_makie, plot_makie!,

    plot_peano,

    pack_xy,

    # Analyse
    rotationcurve,
    plot_rotationcurve, plot_rotationcurve!,
    plot_densitycurve, plot_densitycurve!,
    plot_radialforce, plot_radialforce!,
    plot_radialpotential, plot_radialpotential!,

    plot_trajectory, plot_trajectory!,

    plot_positionslice, plot_positionslice!,
    plot_positionslice_adapt,

    plot_energy, plot_energy!,
    plot_energy_delta, plot_energy_delta!,
    plot_profiling, plot_profiling!,

    rotvel,
    radialvel,
    radialforce,
    radialpotential,
    distribution,

    lagrange_radii,
    plot_radii, plot_radii!,
    plot_scaleradius, plot_scaleradius!,
    plot_lagrangeradii, plot_lagrangeradii!,
    plot_lagrangeradii90, plot_lagrangeradii90!,

    jld2, gadget2, hdf5

# Parameters
SectionIndex = 7.0 / 12.0

include("PhysicalParticles.jl")

include("mesh/cube.jl")

include("tree/octreenodes.jl")
include("tree/octree.jl")
include("tree/peano.jl")

include("analyse/analyse.jl")
include("analyse/energy.jl")
include("analyse/rotationcurve.jl")
include("analyse/density.jl")
include("analyse/radialforce.jl")
include("analyse/radialpotential.jl")

include("snapshots/trajectory.jl")
include("snapshots/positions.jl")
include("snapshots/lagrange.jl")
include("snapshots/profiling.jl")

end