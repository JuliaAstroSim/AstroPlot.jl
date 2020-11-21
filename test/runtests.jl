using Test

using Distributed
pids = addprocs(3)
@everywhere using PhysicalTrees, PhysicalParticles, UnitfulAstro, PhysicalMeshes

using AstroPlot
using Makie

@testset "Mesh" begin
    scene = plot_makie(Cube(PVector(0.0,0.0,0.0), PVector(1.0,1.0,1.0)), nothing)
    result = Makie.save("cube.png", scene)
    @test isnothing(result)
end

@testset "Tree" begin
    scene = plot_peano(3)
    result = Makie.save("peano.png", scene)
    @test isnothing(result)

    d = randn_pvector(15)
    t = octree(d)
    scene = plot_makie(t)
    result = Makie.save("tree.png", scene)
    @test isnothing(result)
end

@testset "Analysis" begin
    scene, layout = plot_profiling("profiling.csv")
    result = Makie.save("profiling.png", scene)
    @test isnothing(result)

    scene, layout = plot_energy("energy.csv")
    result = Makie.save("energy.png", scene)
    @test isnothing(result)
end

@testset "Snapshots" begin
    result = plot_positionslice(
        "snapshots", "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
        xlims = (-0.05, +0.05), ylims = (-0.05, +0.05),
        times = collect(0.0:0.01:0.1) * u"Gyr",
    )
    @test isnothing(result)

    scene, layout = plot_trajectory(
        "snapshots/", "snapshot_", collect(0:20:200), [1,2,3], ".gadget2", gadget2(),
    )
    result = Makie.save("trajectory.png", scene)
    @test isnothing(result)

    ScaleScene, ScaleLayout, LagrangeScene, LagrangeLayout, df = plot_radii(
        "snapshots/", "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
        times = collect(0.0:0.01:0.1) * u"Gyr", title = "Direct Sum const",
    )
    result1 = Makie.save("ScaleRadius.png", ScaleScene)
    result2 = Makie.save("LagrangeRadii.png", LagrangeScene)
end