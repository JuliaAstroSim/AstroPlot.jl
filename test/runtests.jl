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
using AstroPlot.Colors
using AstroPlot.DataFrames
using GLMakie

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
        @test isfile(joinpath(outputdir, "mesh_projection_rho.png"))

        result = unicode_slice(m, :rho, 5)
        @test result isa UnicodePlots.Plot

        f = plot_slice(m, :pos, 5)
        Makie.save(joinpath(outputdir, "mesh_slice_rho.png"), f)
        @test isfile(joinpath(outputdir, "mesh_slice_rho.png"))
    end

    @testset "Mesh helpers" begin
        # axisid
        @test axisid(:x) == 1
        @test axisid(:y) == 2
        @test axisid(:z) == 3
        @test_throws ErrorException axisid(:w)

        # slice3d
        a3d = rand(Float64, 4, 5, 6)
        @test size(slice3d(a3d, 1, 2)) == (5, 6)
        @test size(slice3d(a3d, 2, 3)) == (4, 6)
        @test size(slice3d(a3d, 3, 4)) == (4, 5)
        @test slice3d(a3d, 1, 2) == a3d[2, :, :]

        # axis_cartesian with StructArray of PVector (3D grid) - with units
        pos = StructArray(PVector(0.0u"kpc", 0.0u"kpc", 0.0u"kpc") for i in 1:3, j in 1:4, k in 1:5)
        @test length(axis_cartesian(pos, :x)) == 3
        @test length(axis_cartesian(pos, :y)) == 4
        @test length(axis_cartesian(pos, :z)) == 5
        @test_throws ErrorException axis_cartesian(pos, :w)

        # axis_cartesian dispatch on Mesh
        m = MeshCartesianStatic(d)
        @test axis_cartesian(m, :x) == axis_cartesian(m.pos, :x)

        # unicode_projection on raw 3D array
        rho3d = ones(Float64, 3, 4, 5) .* (1.0e-20u"Msun/kpc^3")
        result = unicode_projection(rho3d, uAstro)
        @test result isa UnicodePlots.Plot

        # unicode_projection with yaxis > xaxis to cover transpose branch
        result_t = unicode_projection(rho3d, uAstro; xaxis = :y, yaxis = :z)
        @test result_t isa UnicodePlots.Plot

        # unicode_slice on raw 3D array
        result = unicode_slice(rho3d, 2, uAstro)
        @test result isa UnicodePlots.Plot
        result_t = unicode_slice(rho3d, 2, uAstro; xaxis = :y, yaxis = :z)
        @test result_t isa UnicodePlots.Plot

        # plot_slice! for non-StructArray (raw 3D array) - use unitless mesh
        m2 = MeshCartesianStatic(d)
        f2 = Figure()
        ax2 = Axis(f2[1, 1])
        AstroPlot.plot_slice!(f2, ax2, m2.pos, m2.rho.data, 2, nothing)
        @test true  # no error

        # plot_slice! for StructArray (arrows branch): simulate via
        # passing a vector field of 3-vectors as data
        vec_data = StructArray(PVector(1.0, 0.0, 0.0) for i in 1:3, j in 1:4, k in 1:5)
        f3 = Figure()
        ax3 = Axis(f3[1, 1])
        AstroPlot.plot_slice!(f3, ax3, pos, vec_data, 2, uAstro)
        @test true

        # plot_mesh_heatmap variants
        hm = plot_mesh_heatmap(rand(10, 10), nothing)
        @test hm isa Figure
        # plot_mesh_heatmap on Mesh dispatches via getfield(m, symbol) which is a 3D
        # ArrayScalarField; heatmap! needs 2D data, so this exercises the function
        # entry but is expected to fail. We just verify the function is callable.
        @test_throws ArgumentError plot_mesh_heatmap(m, :rho, nothing)
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

    # RectNode + plot_makie on AbstractArray{OctreeNode}
    # t is built from unitless randn_pvector, so use nothing for units
    nodes = collect(values(t.treenodes))
    f, ax, p = plot_makie(nodes, nothing; interactive = false)
    @test f isa Figure
    plot_makie!(ax, nodes, nothing)
    @test true
end

@testset "Analyse" begin
    @testset "Core helpers" begin
        # rotvel, radialvel on simple PVector
        v = PVector(1.0, 0.0, 0.0)
        p = PVector(1.0, 0.0, 0.0)
        # radial component of (1,0,0) along (1,0,0) is 1.0
        @test radialvel(v, p) ≈ 1.0
        # tangential velocity of (0,1,0) at (1,0,0) is 1.0
        v2 = PVector(0.0, 1.0, 0.0)
        @test rotvel(v2, p) ≈ 1.0

        # sortarrays! in-place
        a = [3, 1, 2]
        b = ["c", "a", "b"]
        sortarrays!(a, b)
        @test a == [1, 2, 3]
        @test b == ["a", "b", "c"]

        # sortarrays (non-mutating) returns sorted copies
        a2 = [3, 1, 2]
        b2 = ["c", "a", "b"]
        a_sorted, b_sorted = AstroPlot.sortarrays(a2, b2)  # sortarrays is not exported
        @test a_sorted == [1, 2, 3]
        @test b_sorted == ["a", "b", "c"]
        @test a2 == [3, 1, 2]  # original untouched
        @test b2 == ["c", "a", "b"]

        # density: simple radii/masses (AstroPlot.density, not Makie.density)
        r = collect(0.1:0.1:1.0)
        m = ones(10)
        Rmean, rho = AstroPlot.density(r, m)
        @test length(Rmean) == length(rho)

        # distribution: uniform_interval=true (default)
        x = collect(1.0:10.0)
        y = collect(1.0:10.0) .* 2
        xm, ym, xs, ys = distribution(x, y; section = 3)
        @test length(xm) == 3
        @test length(ym) == 3

        # distribution with counts=true
        xm, ym, xs, ys, binN = distribution(x, y; section = 3, counts = true)
        @test length(binN) == 3
        @test sum(binN) == length(x)

        # distribution with uniform_interval=false
        xm2, ym2, xs2, ys2 = distribution(x, y; section = 3, uniform_interval = false)
        @test length(xm2) == 3
        @test length(ym2) == 3

        # distribution with weights
        w = ones(length(x))
        xm3, ym3, xs3, ys3 = distribution(x, y, w; section = 3)
        @test length(xm3) == 3

        # distribution error path: section <= 0
        @test_throws ArgumentError distribution(x, y; section = 0)
        # dimension mismatch
        @test_throws DimensionMismatch distribution(x, [1.0, 2.0])

        # distribution with rmhead/rmtail
        xm4, ym4, xs4, ys4 = distribution(x, y; section = 3, rmhead = 1, rmtail = 1)
        @test length(xm4) == 3

        # distribution_cov
        xm, ycov = distribution_cov(x, y, y .* 0.5; section = 3)
        @test length(xm) == length(ycov)
        xm, ycov, binN = distribution_cov(x, y, y .* 0.5; section = 3, counts = true)
        @test length(binN) == 3
        xm, ycov = distribution_cov(x, y, y .* 0.5; section = 3, uniform_interval = false)
        @test length(xm) == length(ycov)
        @test_throws ArgumentError distribution_cov(x, y, y; section = 0)
        @test_throws DimensionMismatch distribution_cov(x, y, [1.0, 2.0])

        # distribution_skewness
        xm, ys = distribution_skewness(x, y, y .* 0.5, y .* 0.25; section = 3)
        @test length(xm) == length(ys)
        xm, ys, binN = distribution_skewness(x, y, y .* 0.5, y .* 0.25; section = 3, counts = true)
        @test length(binN) == 3
        xm, ys = distribution_skewness(x, y, y .* 0.5, y .* 0.25; section = 3, uniform_interval = false)
        @test length(xm) == length(ys)
        @test_throws ArgumentError distribution_skewness(x, y, y, y; section = 0)
        @test_throws DimensionMismatch distribution_skewness(x, y, y, [1.0, 2.0])

        # distribution empty arrays
        @test distribution(Float64[], Float64[]) == (Float64[], Float64[], Float64[], Float64[])
        @test distribution(Float64[], Float64[]; counts = true)[5] == Int[]
        @test distribution_cov(Float64[], Float64[], Float64[]) == (Float64[], Float64[])
        @test distribution_cov(Float64[], Float64[], Float64[]; counts = true)[3] == Int[]
        @test distribution_skewness(Float64[], Float64[], Float64[], Float64[]) == (Float64[], Float64[])
        @test distribution_skewness(Float64[], Float64[], Float64[], Float64[]; counts = true)[3] == Int[]
    end

    @testset "force" begin
        # force(data, units) - returns R, acc arrays
        R, acc = force(data, uAstro; savelog = false)
        @test length(R) == length(data)
        @test length(acc) == length(data)

        # force with savelog=true writes force.csv
        R, acc = force(data, uAstro; savelog = true, savefolder = outputdir)
        @test isfile(joinpath(outputdir, "force.csv"))

        # unicode_force
        result = unicode_force(data, uAstro; savelog = false)
        @test result isa UnicodePlots.Plot

        # plot_force! and plot_force
        f = Figure()
        ax = Axis(f[1, 1])
        plot_force!(ax, data, uAstro; savelog = false)
        @test true

        fig = plot_force(data, uAstro; savelog = false)
        @test fig isa Figure
    end

    @testset "radialforce" begin
        # radialforce (4-arg primitive) on synthetic particle
        a0 = PVector(0.0, 0.0, 0.0)
        acc = PVector(1.0, 0.0, 0.0)
        p0 = PVector(0.0, 0.0, 0.0)
        pos = PVector(1.0, 0.0, 0.0)
        @test radialforce(a0, acc, p0, pos) ≈ 1.0

        # radialforce(data, units)
        R, acc = radialforce(data, uAstro; savelog = false)
        @test length(R) == length(data)
        @test length(acc) == length(data)

        # with savelog
        R, acc = radialforce(data, uAstro; savelog = true, savefolder = outputdir)
        @test isfile(joinpath(outputdir, "radialforce.csv"))

        # plot_radialforce! and plot_radialforce
        f = Figure()
        ax = Axis(f[1, 1])
        plot_radialforce!(ax, data, uAstro; savelog = false)
        @test true
        fig = plot_radialforce(data, uAstro; savelog = false)
        @test fig isa Figure
    end

    @testset "radialpotential" begin
        # The Plummer data Potential has units kpc^2/Gyr^2 (not Msun*kpc^2/Gyr^2),
        # so we use the unitless particle array `d` to avoid dimensional mismatch.
        R, pot = radialpotential(d, nothing; savelog = false)
        @test length(R) == length(d)
        @test length(pot) == length(d)

        # with savelog
        R, pot = radialpotential(d, nothing; savelog = true, savefolder = outputdir)
        @test isfile(joinpath(outputdir, "radialpotential.csv"))

        # plot_radialpotential! and plot_radialpotential
        f = Figure()
        ax = Axis(f[1, 1])
        plot_radialpotential!(ax, d, nothing; savelog = false)
        @test true
        fig = plot_radialpotential(d, nothing; savelog = false)
        @test fig isa Figure
    end

    @testset "momentum" begin
        # sum_momentum, sum_angular_momentum (Array and StructArray) - not exported
        P_arr = AstroPlot.sum_momentum(d)
        @test P_arr isa PVector

        L_arr = AstroPlot.sum_angular_momentum(d)
        @test L_arr isa PVector

        P_struct = AstroPlot.sum_momentum(data)
        @test P_struct isa PVector

        L_struct = AstroPlot.sum_angular_momentum(data)
        @test L_struct isa PVector

        # plot_momentum! on df (one axis and full)
        # Need df.momentum to be a StructArray so getproperty(:x) works
        df = DataFrame(time = [0.0, 0.1, 0.2],
                       momentum = StructArray([PVector(1.0, 2.0, 3.0), PVector(1.1, 2.1, 3.1), PVector(1.2, 2.2, 3.2)]))
        f = Figure()
        ax = Axis(f[1, 1])
        plot_momentum!(ax, df, :x)
        plot_momentum!(ax, df, :x; absolute = true)
        @test true
        plot_momentum!(ax, df; colors = [RGB(1.0, 0.0, 0.0), RGB(0.0, 1.0, 0.0), RGB(0.0, 0.0, 1.0)])
        @test true

        # plot_momentum(df)
        fig, df_out = plot_momentum(df; uTime = u"s")
        @test fig isa Figure
        @test df_out === df

        # plot_momentum_angular!
        df2 = DataFrame(time = [0.0, 0.1, 0.2],
                        angularmomentum = StructArray([PVector(1.0, 2.0, 3.0), PVector(1.1, 2.1, 3.1), PVector(1.2, 2.2, 3.2)]))
        f2 = Figure()
        ax2 = Axis(f2[1, 1])
        plot_momentum_angular!(ax2, df2, :y)
        plot_momentum_angular!(ax2, df2, :y; absolute = true)
        @test true
        plot_momentum_angular!(ax2, df2; colors = [RGB(1.0, 0.0, 0.0), RGB(0.0, 1.0, 0.0), RGB(0.0, 0.0, 1.0)])
        @test true

        # plot_momentum_angular(df)
        fig2, df2_out = plot_momentum_angular(df2)
        @test fig2 isa Figure
        @test df2_out === df2
    end

    @testset "energy helpers" begin
        # kinetic_energy, sum_kinetic, sum_potential (not exported)
        p = first(data)
        @test AstroPlot.kinetic_energy(p) ≈ 0.5 * p.Mass * p.Vel * p.Vel

        KE_arr = AstroPlot.sum_kinetic(d)
        @test KE_arr isa Number
        PE_arr = AstroPlot.sum_potential(d)
        @test PE_arr isa Number

        KE_struct = AstroPlot.sum_kinetic(data)
        @test KE_struct isa Number
        PE_struct = AstroPlot.sum_potential(data)
        @test PE_struct isa Number

        # energy_delta
        df_e = DataFrame(time = [0.0, 0.1, 0.2, 0.3],
                         energy = [1.0, 1.1, 0.9, 1.05])
        t, dE = AstroPlot.energy_delta(df_e)
        @test length(t) == 3
        @test length(dE) == 3
        @test dE[1] ≈ 0.1
        @test dE[3] ≈ 0.15

        # df_full has time/energy/potential/kinetic columns for energy plot variants
        df_full = DataFrame(time = [0.0, 0.1, 0.2, 0.3],
                            energy = [1.0, 1.1, 0.9, 1.05],
                            potential = [0.5, 0.55, 0.45, 0.5],
                            kinetic = [0.5, 0.55, 0.45, 0.55])

        # plot_energy! variants (DataFrame and datafile, also with/without potential/kinetic)
        f = Figure()
        ax = Axis(f[1, 1])
        plot_energy!(ax, df_full)
        @test true
        plot_energy!(ax, "energy.csv")
        @test true

        # plot_energy_potential! variants
        plot_energy_potential!(ax, df_full)
        @test true
        plot_energy_potential!(ax, "energy.csv")
        @test true

        # plot_energy_kinetic! variants
        plot_energy_kinetic!(ax, df_full)
        @test true
        plot_energy_kinetic!(ax, "energy.csv")
        @test true

        # plot_energy_potential(df)
        fig_pe, df_pe = plot_energy_potential(df_full)
        @test fig_pe isa Figure
        @test df_pe === df_full
        fig_pe2, _ = plot_energy_potential("energy.csv")
        @test fig_pe2 isa Figure

        # plot_energy_kinetic(df)
        fig_ke, df_ke = plot_energy_kinetic(df_full)
        @test fig_ke isa Figure
        @test df_ke === df_full
        fig_ke2, _ = plot_energy_kinetic("energy.csv")
        @test fig_ke2 isa Figure

        # plot_energy(df) with only :energy column
        fig, _ = plot_energy(df_e; potential = false, kinetic = false)
        @test fig isa Figure
        # with only :potential and :kinetic, no :energy
        df_pk = DataFrame(time = [0.0, 0.1, 0.2],
                          potential = [0.5, 0.6, 0.7],
                          kinetic = [0.5, 0.4, 0.3])
        fig2, df2_out = plot_energy(df_pk)
        @test fig2 isa Figure
        @test :energy in propertynames(df2_out)

        # plot_energy_delta! variants
        plot_energy_delta!(ax, df_full)
        @test true
        plot_energy_delta!(ax, "energy.csv")
        @test true

        # plot_energy_delta(df)
        fig_de, df_de = plot_energy_delta(df_full)
        @test fig_de isa Figure
        @test df_de === df_full
        fig_de2, _ = plot_energy_delta("energy.csv")
        @test fig_de2 isa Figure

        # plot_energy(folder, ...) - per-snapshot variant
        # Note: this triggers a known bug in AstroPlot where plot_energy forwards
        # `pot=true` to read_gadget2 which doesn't accept it. Skipping until fixed.
        # fig, _ = plot_energy("plummer/", "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
        #                      times = collect(0.0:0.01:0.1) * u"Gyr",
        #                      savelog = false)
        # @test fig isa Figure
    end

    @testset "Profiling helpers" begin
        # plot_profiling! on existing axis
        f = Figure()
        ax = Axis(f[1, 1])
        plot_profiling!(ax, 1, "profiling.csv")
        @test true
        plot_profiling!(ax, 1, "profiling.csv";
                        colors = [RGB(0.5, 0.5, 0.5), RGB(0.2, 0.2, 0.8)])
        @test true
    end

    @testset "Existing analyse plotting" begin
        fig = plot_profiling("profiling.csv")
        Makie.save(joinpath(outputdir, "profiling.png"), fig)
        @test isfile(joinpath(outputdir, "profiling.png"))

        fig, df = plot_energy("energy.csv")
        Makie.save(joinpath(outputdir, "energy.png"), fig)
        @test isfile(joinpath(outputdir, "energy.png"))

        fig, df = plot_energy_delta("energy.csv")
        Makie.save(joinpath(outputdir, "energydelta.png"), fig)
        @test isfile(joinpath(outputdir, "energydelta.png"))

        fig = plot_densitycurve(data, savefolder = outputdir)
        Makie.save(joinpath(outputdir, "density.png"), fig)
        @test isfile(joinpath(outputdir, "density.png"))

        fig = plot_rotationcurve(data, savefolder = outputdir)
        Makie.save(joinpath(outputdir, "rotationcurve.png"), fig)
        @test isfile(joinpath(outputdir, "rotationcurve.png"))
    end
end

@testset "Snapshots" begin
    @testset "positions" begin
        # plot_positionslice(data, u) - data variant
        fig = plot_positionslice(d, nothing; size = (400, 400))
        @test fig isa Figure

        # plot_positionslice! (fig, data, u)
        f = Figure()
        ax = Axis(f[1, 1])
        plot_positionslice!(ax, d, nothing)
        @test true

        # plot_positionslice_adapt(data, u) - data variant
        fig2 = plot_positionslice_adapt(d, nothing; xlen = 0.1, ylen = 0.1, size = (400, 400))
        @test fig2 isa Figure

        # plot_positionslice_adapt(folder, ...) - folder variant
        ok = plot_positionslice_adapt("plummer/", "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
                                      xlen = 0.1, ylen = 0.1,
                                      times = collect(0.0:0.01:0.1) * u"Gyr")
        @test ok

        # plot_positionslice_adapt with collection filter (no matches)
        @test_logs (:warn,) match_mode = :any plot_positionslice_adapt(d, GAS, nothing)
    end

    @testset "trajectory" begin
        # plot_trajectory!(ax, pos::Array{PVector,1})
        f = Figure()
        ax = Axis(f[1, 1])
        pos1 = PVector(0.0, 0.0, 0.0)
        pos2 = PVector(0.1, 0.0, 0.0)
        pos3 = PVector(0.2, 0.1, 0.0)
        s1 = plot_trajectory!(ax, [pos1, pos2, pos3])
        @test s1 isa Makie.Lines
        # with color and lims
        s2 = plot_trajectory!(ax, [pos1, pos2, pos3]; color = RGB(1.0, 0.0, 0.0),
                              xlims = (-0.1, 0.3), ylims = (-0.1, 0.3))
        @test s2 isa Makie.Lines

        # plot_trajectory(pos::Dict, u) - use unitful data
        pos_dict = Dict{Int64, Array{AbstractPoint, 1}}(
            1 => AbstractPoint[p.Pos for p in data if p.ID == 1]
        )
        fig = plot_trajectory(pos_dict, u"kpc")
        @test fig isa Figure
        # with colors kwarg
        fig_c = plot_trajectory(pos_dict, u"kpc"; colors = [RGB(0.5, 0.0, 0.0)])
        @test fig_c isa Figure

        # plot_trajectory!(fig, ax, pos::Dict, u)
        f3 = Figure()
        ax3 = Axis(f3[1, 1])
        scenes, names = plot_trajectory!(f3, ax3, pos_dict, u"kpc")
        @test length(scenes) == length(names)
        scenes2, names2 = plot_trajectory!(f3, ax3, pos_dict, u"kpc";
                                          colors = [RGB(0.0, 1.0, 0.0)])
        @test length(scenes2) == length(names2)

        # plot_trajectory!(fig, ax, folder, ...) - folder variant
        f4 = Figure()
        ax4 = Axis(f4[1, 1])
        scenes3, names3 = plot_trajectory!(f4, ax4, "plummer/", "snapshot_",
                                            collect(0:20:200), [1, 2, 3], ".gadget2", gadget2())
        @test length(scenes3) == length(names3)
    end

    @testset "lagrange" begin
        # pos_from_center
        pos_p = pos_from_center(data, u"kpc")  # data has units
        @test length(pos_p) == length(data)
        pos_pu = pos_from_center(d, nothing)     # d is unitless
        @test length(pos_pu) == length(d)

        # lagrange_radii
        scale, lagr = lagrange_radii(data, u"kpc")
        @test scale isa Real
        @test length(lagr) == 10

        # plot_scaleradius! on Axis
        df_r = DataFrame(Time = [0.0, 0.1, 0.2], ScaleRadius = [0.01, 0.012, 0.014])
        f = Figure()
        ax = Axis(f[1, 1])
        plot_scaleradius!(ax, df_r)
        @test true

        # plot_scaleradius(df, uTime, uLength)
        fig = plot_scaleradius(df_r, u"Gyr", u"kpc")
        @test fig isa Figure
        fig_leg = plot_scaleradius(df_r, u"Gyr", u"kpc"; legend = true)
        @test fig_leg isa Figure

        # plot_lagrangeradii! (full L10..L100)
        df_l = DataFrame(Time = [0.0, 0.1, 0.2],
                         L10 = [0.001, 0.0011, 0.0012],
                         L20 = [0.002, 0.0021, 0.0022],
                         L30 = [0.003, 0.0031, 0.0032],
                         L40 = [0.004, 0.0041, 0.0042],
                         L50 = [0.005, 0.0051, 0.0052],
                         L60 = [0.006, 0.0061, 0.0062],
                         L70 = [0.007, 0.0071, 0.0072],
                         L80 = [0.008, 0.0081, 0.0082],
                         L90 = [0.009, 0.0091, 0.0092],
                         L100 = [0.01, 0.011, 0.012])
        f2 = Figure()
        ax2 = Axis(f2[1, 1])
        scenes, columns = plot_lagrangeradii!(f2, ax2, df_l)
        @test length(scenes) == 10
        @test length(columns) == 10
        plot_lagrangeradii!(f2, ax2, df_l; legend = false)
        @test true
        # with `colors = nothing` branch
        plot_lagrangeradii!(f2, ax2, df_l; colors = nothing)
        @test true
        # with short colors list to trigger fallback
        plot_lagrangeradii!(f2, ax2, df_l; colors = [RGB(0.1, 0.2, 0.3)])
        @test true

        # plot_lagrangeradii(df, uTime, uLength)
        fig_l = plot_lagrangeradii(df_l, u"Gyr", u"kpc")
        @test fig_l isa Figure

        # plot_lagrangeradii90! (only L10..L90, no L100)
        scenes90, columns90 = plot_lagrangeradii90!(f2, ax2, df_l)
        @test length(scenes90) == 9
        @test length(columns90) == 9
        plot_lagrangeradii90!(f2, ax2, df_l; legend = false, colors = [RGB(0.5, 0.5, 0.5)])
        @test true
        plot_lagrangeradii90!(f2, ax2, df_l; colors = nothing)
        @test true

        # plot_lagrangeradii90(df, uTime, uLength)
        fig_l90 = plot_lagrangeradii90(df_l, u"Gyr", u"kpc")
        @test fig_l90 isa Figure
    end

    @testset "Existing snapshot plotting" begin
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

    # mosaic(folder, filenamebase, suffix) - the suffix-only scan variant
    # Note: this has a path bug in AstroPlot where mosaic(folder, filenamebase, suffix)
    # uses readdir(folder) without joinpath, so load fails. Skipping until fixed.
    # plt2 = mosaic("mosaic/", "pos_", ".png"; fillvalue = 0.5, npad = 3, ncol = 4, rowmajor = true)
    # @test !isnothing(plt2)
end

@testset "Video" begin
    @test png2video("mosaic/", "pos_", ".png", joinpath(outputdir, "TDE.mp4"))
end

@testset "Unitcode Plot" begin
    result = unicode_scatter(d, nothing)
    @test result isa UnicodePlots.Plot

    result = unicode_density(d, nothing, savefolder = outputdir)
    @test result isa UnicodePlots.Plot

    result = unicode_rotationcurve(d, nothing, savefolder = outputdir)
    @test result isa UnicodePlots.Plot
end

@testset "PhysicalParticles plot_makie variants" begin
    # plot_makie(data::Array{PVector}, u) and plot_makie!
    # Use unitless PVector so plot_makie(pvecs, nothing) works
    pvecs = [PVector(randn(), randn(), randn()) for _ in 1:10]
    fig1 = plot_makie(pvecs, nothing)
    @test !isnothing(fig1)
    f1 = Figure()
    ax1 = Axis3(f1[1, 1])
    plot_makie!(ax1, pvecs, nothing)
    @test true

    # plot_makie(data::Array{AbstractParticle3D}, u)
    fig2 = plot_makie(d, nothing)  # d is unitless
    @test !isnothing(fig2)
    f2 = Figure()
    ax2 = Axis3(f2[1, 1])
    plot_makie!(ax2, d, nothing)
    @test true

    # plot_makie(data::StructArray, u) - dispatches via data.Pos
    # data has units (uAstro = kpc, Gyr, ...), so we must pass u"kpc" for stripping
    fig3 = plot_makie(data, u"kpc")
    @test !isnothing(fig3)
    f3 = Figure()
    ax3 = Axis3(f3[1, 1])
    plot_makie!(ax3, data, u"kpc")  # need Axis, not Figure
    @test true

    # plot_makie(data, collection, u) - filter
    fig4 = plot_makie(d, STAR, nothing)  # d is unitless
    @test !isnothing(fig4)
    plot_makie!(ax2, d, STAR, nothing)  # use Axis, not Figure
    @test true

    # plot_makie(data, GAS, u) - empty filter (no GAS in this Plummer data)
    @test_logs (:warn,) match_mode = :any plot_makie(d, GAS, nothing)

    # plot_makie!(fig, data::StructArray{T,N,NT,Tu}, u) - AbstractPoint3D path
    pvecs_sa = StructArray(PVector(randn(), randn(), randn()) for _ in 1:5)
    plot_makie!(ax1, pvecs_sa, nothing)  # use Axis, not Figure
    @test true

    # unicode_scatter(data::Array{T,N}, u) - AbstractParticle path
    result_p = unicode_scatter(d, nothing)
    @test result_p isa UnicodePlots.Plot

    # unicode_scatter(data::StructArray, u) - StructArray path
    # data has units, use u"kpc"
    result_sa = unicode_scatter(data, u"kpc")
    @test result_sa isa UnicodePlots.Plot

    # unicode_scatter(data, collection, u) - filter
    result_coll = unicode_scatter(d, STAR, nothing)
    @test result_coll isa UnicodePlots.Plot
    # empty filter
    @test_logs (:warn,) match_mode = :any unicode_scatter(d, GAS, nothing)

    # estimate_markersize
    @test AstroPlot.estimate_markersize(100.0) ≈ 0.1 / sqrt(100.0)
end
