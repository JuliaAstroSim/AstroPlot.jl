#=
cd("AstroPlot.jl/test")
=#

using Test

using PhysicalParticles
using PhysicalTrees, PhysicalMeshes
using Unitful, UnitfulAstro

using AstroPlot
using AstroIO
using GLMakie

function plotsuccess(result)
    return !isnothing(result)
end

header, data = read_gadget2("plummer/snapshot_0000.gadget2", uAstro, uGadget2, type=Star)
h, d = read_gadget2("plummer_unitless.gadget2", nothing, uGadget2, type=Star)

@testset "Mesh" begin
    @testset "Cube" begin
        c = Cube(PVector(0.0,0.0,0.0), PVector(1.0,1.0,1.0))
        fig = plot_makie(c, nothing)
        result = Makie.save("cube.png", fig)
        @test plotsuccess(result)
    
        f = Figure()
        ax = Axis3(f[1,1])
        plot_makie!(ax, c, nothing)
        result = Makie.save("cube_axis.png", f)
        @test plotsuccess(result)
    end

    @testset "MeshCartesianStatic" begin
        m = MeshCartesianStatic(d)
        
        result = unicode_projection_density(m)
        @test plotsuccess(result)

        f = projection_density(m)
        Makie.save("mesh_projection_rho.png", f)
        @test plotsuccess(f)

        result = unicode_slice(m, :rho, 5)
        @test plotsuccess(result)

        f = plot_slice(m, :pos, 5)
        result = Makie.save("mesh_slice_rho.png", f)
        @test plotsuccess(result)
    end
end

@testset "Tree" begin
    fig = plot_peano(3)
    result = Makie.save("peano.png", fig)
    @test plotsuccess(result)

    d = randn_pvector(15)
    t = octree(d)
    figure, axis, plot = plot_makie(t)
    result = Makie.save("tree.png", figure)
    @test plotsuccess(result)
end

@testset "Analyse" begin
    fig = plot_profiling("profiling.csv")
    result = Makie.save("profiling.png", fig)
    @test plotsuccess(result)

    fig, df = plot_energy("energy.csv")
    result = Makie.save("energy.png", fig)
    @test plotsuccess(result)

    fig, df = plot_energy_delta("energy.csv")
    result = Makie.save("energydelta.png")
    @test plotsuccess(result)

    fig = plot_densitycurve(data)
    result = Makie.save("density.png", fig)
    @test plotsuccess(result)

    fig = plot_rotationcurve(data)
    result = Makie.save("rotationcurve.png", fig)
    @test plotsuccess(result)
end

@testset "Snapshots" begin
    result = plot_positionslice(
        "plummer", "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
        xlims = (-0.05, +0.05), ylims = (-0.05, +0.05),
        times = collect(0.0:0.01:0.1) * u"Gyr",
    )
    @test plotsuccess(result)

    fig, pos = plot_trajectory(
        "plummer/", "snapshot_", collect(0:20:200), [1,2,3], ".gadget2", gadget2(),
    )
    result = Makie.save("trajectory.png", fig)
    @test plotsuccess(result)

    FigScale, FigLagrange, df = plot_radii(
        "plummer/", "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
        times = collect(0.0:0.01:0.1) * u"Gyr", title = "Direct Sum const",
    )
    result1 = Makie.save("ScaleRadius.png", FigScale)
    result2 = Makie.save("LagrangeRadii.png", FigLagrange)
    @test plotsuccess(result1)
    @test plotsuccess(result2)
    
end

@testset "Mosaic view" begin
    plot_positionslice("mosaic/", "snapshot_", collect(1:9:100), ".gadget2", gadget2(),
        size = (800,800),
        xlims = (-0.06, +0.06), ylims = (-0.06, +0.06),
        times = collect(0.0:0.00005:0.005) * u"Gyr",
    )
    plt = mosaicview("mosaic/", "pos_", collect(1:9:100), ".png"; fillvalue = 0.5, npad = 3, ncol = 4, rowmajor = true)
    save("mosaic-TDE-pseudo.png", plt)
    @test plotsuccess(plt)
end

@testset "Video" begin
    @test png2video("mosaic/", "pos_", ".png", "TDE.mp4")
end

@testset "Unitcode Plot" begin
    result = unicode_scatter(d, nothing)
    @test plotsuccess(result)

    result = unicode_density(d, nothing)
    @test plotsuccess(result)

    result = unicode_rotationcurve(d, nothing)
    @test plotsuccess(result)
end