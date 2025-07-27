#=
cd("AstroPlot.jl/test")
=#

using Test

using AstroPlot
using AstroPlot.PhysicalParticles
using AstroPlot.PhysicalTrees
using AstroPlot.PhysicalMeshes
using AstroPlot.Unitful
using AstroPlot.UnitfulAstro

using AstroPlot.AstroSimBase
import AstroPlot.UnicodePlots
using AstroPlot.AstroIO
using AstroPlot.GLMakie

outputdir = joinpath(@__DIR__, "output")
mkpathIfNotExist(outputdir)

header, data = read_gadget2("plummer/snapshot_0000.gadget2", uAstro, uGadget2, type=Star)
h, d = read_gadget2("plummer_unitless.gadget2", nothing, uGadget2, type=Star)

@testset "Mesh" begin
    @testset "Cube" begin
        c = Cube(PVector(0.0,0.0,0.0), PVector(1.0,1.0,1.0))
        fig = plot_makie(c, nothing)
        Makie.save(joinpath(outputdir, "cube.png"), fig)
        @test isfile(joinpath(outputdir, "cube.png"))
    
        f = Figure()
        ax = Axis3(f[1,1])
        plot_makie!(ax, c, nothing)
        Makie.save(joinpath(outputdir, "cube_axis.png"), f)
        @test isfile(joinpath(outputdir, "cube_axis.png"))
    end

    @testset "MeshCartesianStatic" begin
        m = MeshCartesianStatic(d)
        
        result = unicode_projection_density(m)
        @test result isa UnicodePlots.Plot

        f = projection_density(m)
        Makie.save(joinpath(outputdir, "mesh_projection_rho.png"), f)
        isfile(joinpath(outputdir, "mesh_projection_rho.png"))

        result = unicode_slice(m, :rho, 5)
        @test result isa UnicodePlots.Plot

        f = plot_slice(m, :pos, 5)
        Makie.save(joinpath(outputdir, "mesh_slice_rho.png"), f)
        isfile(joinpath(outputdir, "mesh_slice_rho.png"))
    end
end

@testset "Tree" begin
    fig = plot_peano(3)
    Makie.save(joinpath(outputdir, "peano.png"), fig)
    @test isfile(joinpath(outputdir, "peano.png"))

    d = randn_pvector(15)
    t = octree(d)
    figure, axis, plot = plot_makie(t)
    Makie.save(joinpath(outputdir, "tree.png"), figure)
    @test isfile(joinpath(outputdir, "tree.png"))
end

@testset "Analyse" begin
    fig = plot_profiling("profiling.csv")
    Makie.save(joinpath(outputdir, "profiling.png"), fig)
    @test isfile(joinpath(outputdir, "profiling.png"))

    fig, df = plot_energy("energy.csv")
    Makie.save(joinpath(outputdir, "energy.png"), fig)
    @test isfile(joinpath(outputdir, "energy.png"))

    fig, df = plot_energy_delta("energy.csv")
    Makie.save(joinpath(outputdir, "energydelta.png"), fig)
    @test isfile(joinpath(outputdir, "energydelta.png"))

    fig = plot_densitycurve(data)
    Makie.save(joinpath(outputdir, "density.png"), fig)
    @test isfile(joinpath(outputdir, "density.png"))

    fig = plot_rotationcurve(data)
    Makie.save(joinpath(outputdir, "rotationcurve.png"), fig)
    @test isfile(joinpath(outputdir, "rotationcurve.png"))
end

@testset "Snapshots" begin
    result = plot_positionslice(
        "plummer", "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
        xlims = (-0.05, +0.05), ylims = (-0.05, +0.05),
        times = collect(0.0:0.01:0.1) * u"Gyr",
    )
    @test !isnothing(result)

    fig, pos = plot_trajectory(
        "plummer/", "snapshot_", collect(0:20:200), [1,2,3], ".gadget2", gadget2(),
    )
    Makie.save(joinpath(outputdir, "trajectory.png"), fig)
    @test isfile(joinpath(outputdir, "trajectory.png"))

    FigScale, FigLagrange, df = plot_radii(
        "plummer/", "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
        times = collect(0.0:0.01:0.1) * u"Gyr", title = "Direct Sum const",
    )
    Makie.save(joinpath(outputdir, "ScaleRadius.png"), FigScale)
    Makie.save(joinpath(outputdir, "LagrangeRadii.png"), FigLagrange)
    @test isfile(joinpath(outputdir, "ScaleRadius.png"))
    @test isfile(joinpath(outputdir, "LagrangeRadii.png"))
    
end

@testset "Mosaic view" begin
    plot_positionslice("mosaic/", "snapshot_", collect(1:9:100), ".gadget2", gadget2(),
        size = (800,800),
        xlims = (-0.06, +0.06), ylims = (-0.06, +0.06),
        times = collect(0.0:0.00005:0.005) * u"Gyr",
    )
    plt = mosaic("mosaic/", "pos_", collect(1:9:100), ".png"; fillvalue = 0.5, npad = 3, ncol = 4, rowmajor = true)
    save(joinpath(outputdir, "mosaic-TDE-pseudo.png"), plt)
    @test !isnothing(plt)
end

@testset "Video" begin
    @test png2video("mosaic/", "pos_", ".png", joinpath(outputdir, "TDE.mp4"))
end

@testset "Unitcode Plot" begin
    result = unicode_scatter(d, nothing)
    @test result isa UnicodePlots.Plot

    result = unicode_density(d, nothing)
    @test result isa UnicodePlots.Plot

    result = unicode_rotationcurve(d, nothing)
    @test result isa UnicodePlots.Plot
end