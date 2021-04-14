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
using DocStringExtensions

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
    unicode_force,
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
    plot_force, plot_force!,
    plot_radialpotential, plot_radialpotential!,

    plot_trajectory, plot_trajectory!,

    plot_positionslice, plot_positionslice!,
    plot_positionslice_adapt,

    plot_energy, plot_energy!,
    plot_energy_delta, plot_energy_delta!,
    plot_energy_potential, plot_energy_potential!,
    plot_energy_kinetic, plot_energy_kinetic!,
    plot_profiling, plot_profiling!,

    rotvel,
    radialvel,
    force,
    radialforce,
    radialpotential,
    distribution,

    lagrange_radii,
    plot_radii, plot_radii!,
    plot_scaleradius, plot_scaleradius!,
    plot_lagrangeradii, plot_lagrangeradii!,
    plot_lagrangeradii90, plot_lagrangeradii90!,

    # tools
    pos_from_center,

    jld2, gadget2, hdf5

# Parameters
SectionIndex = 7.0 / 12.0

_common_keyword_axis = """
- `xaxis`: `Symbol` to plot on x-axis. Default is `:x`
- `yaxis`: `Symbol` to plot on y-axis. Defualt is `:y`
"""

_common_keyword_label = """
- `xlabel`: label of x-axis
- `ylabel`: label of y-axis
"""

_common_keyword_axis_label = _common_keyword_axis * _common_keyword_label

_common_keyword_lims = """
- `xlims`: set x-limit of the plot. Default is `nothing`
- `ylims`: set y-limit of the plot. Default is `nothing`
"""

_common_keyword_figure = """
- `title`: title line of the figure
- `resolution`: figure size
- `aspect_ratio`: aspect ratio of axes. Default is `1.0` to avoid stretching. Pass to `Makie` as `AxisAspect(aspect_ratio)`
""" * _common_keyword_axis_label * _common_keyword_lims

_common_keyword_adapt_len = """
- `xlen::Float64`: box length at x-axis
- `ylne::Float64`: box length at y-axis
"""

_common_argument_snapshot = """
- `folder`: directory holding snapshots
- `filenamebase`, `Counts`, `suffix`:
    snapshots are commonly named as `snapshot_0000.gadget2`, in this way `filenamebase = "snapshot_"`, `suffix = ".gadget2`.
    `Counts` is an array to choose snapshots, and it is printed to formatted string (controled by keyword `formatstring`) in `for` loops.
- `FileType`: Trait argument to dispatch on different snapshot format. It is to be set manually because some output types cannot be deduced automatically
- `u = u"kpc"`: length unit. Set `u` as `nothing` in unitless cases.
"""

_common_keyword_snapshot = """
- `formatstring`: formatted string to control snapshot index. Default is `"%04d"`
"""

include("PhysicalParticles.jl")

include("mesh/cube.jl")

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

include("snapshots/trajectory.jl")
include("snapshots/positions.jl")
include("snapshots/lagrange.jl")
include("snapshots/profiling.jl")

end