@setup_workload begin
    @compile_workload begin
        foldertest = joinpath(@__DIR__, "../test")
        # foldertemp = joinpath(tempdir(), "AstroPlot.jl")

        header, data = read_gadget2(joinpath(foldertest, "plummer/snapshot_0000.gadget2"), uAstro, uGadget2, type=Star)
        h, d = read_gadget2(joinpath(foldertest, "plummer_unitless.gadget2"), nothing, uGadget2, type=Star)

        c = Cube(PVector(0.0,0.0,0.0), PVector(1.0,1.0,1.0))
        fig = plot_makie(c, nothing)
        f = Figure()
        ax = Axis3(f[1,1])
        plot_makie!(ax, c, nothing)

        m = MeshCartesianStatic(d)
        unicode_projection_density(m)
        # f = projection_density(m) #TODO
        unicode_slice(m, :rho, 5)
        f = plot_slice(m, :pos, 5)

        #! This is breaking. Anyway, tree plot is not often used
        # fig = plot_peano(3)
        # d = randn_pvector(15)
        # t = octree(d)
        # figure, axis, plot = plot_makie(t)

        fig = plot_profiling(joinpath(foldertest, "profiling.csv"))
        fig, df = plot_energy(joinpath(foldertest, "energy.csv"))
        fig, df = plot_energy_delta(joinpath(foldertest, "energy.csv"))
        fig = plot_densitycurve(data, savefolder = foldertest)
        fig = plot_rotationcurve(data, savefolder = foldertest)

        #TODO: there is something wrong???
        plot_positionslice(
            joinpath(foldertest, "plummer"), "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
            xlims = (-0.05, +0.05), ylims = (-0.05, +0.05),
            times = collect(0.0:0.01:0.1) * u"Gyr",
        )
        fig, pos = plot_trajectory(
            joinpath(foldertest, "plummer/"), "snapshot_", collect(0:20:200), [1,2,3], ".gadget2", gadget2(),
        )
        FigScale, FigLagrange, df = plot_radii(
            joinpath(foldertest, "plummer/"), "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
            times = collect(0.0:0.01:0.1) * u"Gyr", title = "Direct Sum const",
            savefolder = foldertest,
        )

        plot_positionslice(joinpath(foldertest, "mosaic/"), "snapshot_", collect(1:9:100), ".gadget2", gadget2(),
            size = (800,800),
            xlims = (-0.06, +0.06), ylims = (-0.06, +0.06),
            times = collect(0.0:0.00005:0.005) * u"Gyr",
        )
        plt = mosaicview(joinpath(foldertest, "mosaic/"), "pos_", collect(1:9:100), ".png"; fillvalue = 0.5, npad = 3, ncol = 4, rowmajor = true)

        png2video(joinpath(foldertest, "mosaic/"), "pos_", ".png", joinpath(foldertest, "TDE.mp4"))

        unicode_scatter(d, nothing)
        unicode_density(d, nothing, savefolder = foldertest)
        unicode_rotationcurve(d, nothing, savefolder = foldertest)
    end
end
