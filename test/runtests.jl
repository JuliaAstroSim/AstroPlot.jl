using Test

using Distributed
pids = addprocs(3)
@everywhere using PhysicalTrees, PhysicalParticles, UnitfulAstro, PhysicalMeshes

using AstroPlot
using AstroIO
using Makie

function plotsuccess(result)
    return !isnothing(result)
end

header, data = read_gadget2("snapshots/snapshot_0000.gadget2")

@testset "Mesh" begin
    scene = plot_makie(Cube(PVector(0.0,0.0,0.0), PVector(1.0,1.0,1.0)), nothing)
    result = Makie.save("cube.png", scene)
    @test plotsuccess(result)
end

@testset "Tree" begin
    scene = plot_peano(3)
    result = Makie.save("peano.png", scene)
    @test plotsuccess(result)

    d = randn_pvector(15)
    t = octree(d)
    scene = plot_makie(t)
    result = Makie.save("tree.png", scene)
    @test plotsuccess(result)
end

@testset "Analysis" begin
    scene, layout = plot_profiling("profiling.csv")
    result = Makie.save("profiling.png", scene)
    @test plotsuccess(result)

    scene, layout = plot_energy("energy.csv")
    result = Makie.save("energy.png", scene)
    @test plotsuccess(result)

    scene, layout = plot_densitycurve(data)
    result = Makie.save("density.png", scene)
    @test plotsuccess(result)

    scene, layout = plot_rotationcurve(data)
    result = Makie.save("rotationcurve.png", scene)
    @test plotsuccess(result)
end

@testset "Snapshots" begin
    result = plot_positionslice(
        "snapshots", "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
        xlims = (-0.05, +0.05), ylims = (-0.05, +0.05),
        times = collect(0.0:0.01:0.1) * u"Gyr",
    )
    @test plotsuccess(result)

    scene, layout = plot_trajectory(
        "snapshots/", "snapshot_", collect(0:20:200), [1,2,3], ".gadget2", gadget2(),
    )
    result = Makie.save("trajectory.png", scene)
    @test plotsuccess(result)

    ScaleScene, ScaleLayout, LagrangeScene, LagrangeLayout, df = plot_radii(
        "snapshots/", "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
        times = collect(0.0:0.01:0.1) * u"Gyr", title = "Direct Sum const",
    )
    result1 = Makie.save("ScaleRadius.png", ScaleScene)
    result2 = Makie.save("LagrangeRadii.png", LagrangeScene)
    @test plotsuccess(result1)
    @test plotsuccess(result2)
end

@testset "Unitcode Plot" begin
    result = unicode_scatter(data)
    @test plotsuccess(result)

    result = unicode_density(data)
    @test plotsuccess(result)

    result = unicode_rotationcurve(data)
    @test plotsuccess(result)
end