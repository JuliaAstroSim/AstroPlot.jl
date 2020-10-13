function lagrange_radii(particles, u = u"kpc")
    p0 = median(particles, :Pos)
    pos = [ustrip(u, p.Pos - p0) for p in Iterators.flatten(values(particles))]

    R = norm.(pos)
    sort!(R)

    N = countdata(particles)
    ScaleRadius = R[floor(Int64, N / 2.718281828459)]

    len = div(N, 10)
    index = collect(len : len : N)
    return ScaleRadius, [R[i] for i in index]
end

function plot_scaleradius(df::DataFrame, uTime::Units, uLength::Units;
                          xlabel = "t [$uTime]",
                          ylabel = "r [$uLength]",
                          kw...)
    scene, layout = layoutscene()

    ax = layout[1,1] = LAxis(
        scene,
        title = "Scale radius",
        xlabel = xlabel,
        ylabel = ylabel,
    )

    Makie.lines!(ax, df.Time, df.ScaleRadius)

    return scene, layout
end

function plot_lagrangeradii(df::DataFrame, uTime::Units, uLength::Units;
                            xlabel = "t [$uTime]",
                            ylabel = "r [$uLength]",
                            kw...)
    scene, layout = layoutscene()

    ax = layout[1,1] = LAxis(
        scene,
        title = "Lagrange radii",
        xlabel = xlabel,
        ylabel = ylabel,
    )

    p1 = Makie.lines!(ax, df.Time, df.L10, color = RGB(rand(3)...))
    p2 = Makie.lines!(ax, df.Time, df.L20, color = RGB(rand(3)...))
    p3 = Makie.lines!(ax, df.Time, df.L30, color = RGB(rand(3)...))
    p4 = Makie.lines!(ax, df.Time, df.L40, color = RGB(rand(3)...))
    p5 = Makie.lines!(ax, df.Time, df.L50, color = RGB(rand(3)...))
    p6 = Makie.lines!(ax, df.Time, df.L60, color = RGB(rand(3)...))
    p7 = Makie.lines!(ax, df.Time, df.L70, color = RGB(rand(3)...))
    p8 = Makie.lines!(ax, df.Time, df.L80, color = RGB(rand(3)...))
    p9 = Makie.lines!(ax, df.Time, df.L90, color = RGB(rand(3)...))
    p10 = Makie.lines!(ax, df.Time, df.L100, color = RGB(rand(3)...))

    leg = layout[1,2] = LLegend(scene,
        [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10],
        ["10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%"]
    )

    return scene, layout
end

"""
function plot_lagrangeradii90(df::DataFrame, uTime::Units, uLength::Units, kw...)

    plot Lagrange radii without 100% radius for better looking.
"""
function plot_lagrangeradii90(df::DataFrame, uTime::Units, uLength::Units;
                              xlabel = "t [$uTime]",
                              ylabel = "r [$uLength]",
                              kw...)
    scene, layout = layoutscene()

    ax = layout[1,1] = LAxis(
        scene,
        title = "Lagrange radii",
        xlabel = xlabel,
        ylabel = ylabel,
    )

    p1 = Makie.lines!(ax, df.Time, df.L10, color = RGB(rand(3)...))
    p2 = Makie.lines!(ax, df.Time, df.L20, color = RGB(rand(3)...))
    p3 = Makie.lines!(ax, df.Time, df.L30, color = RGB(rand(3)...))
    p4 = Makie.lines!(ax, df.Time, df.L40, color = RGB(rand(3)...))
    p5 = Makie.lines!(ax, df.Time, df.L50, color = RGB(rand(3)...))
    p6 = Makie.lines!(ax, df.Time, df.L60, color = RGB(rand(3)...))
    p7 = Makie.lines!(ax, df.Time, df.L70, color = RGB(rand(3)...))
    p8 = Makie.lines!(ax, df.Time, df.L80, color = RGB(rand(3)...))
    p9 = Makie.lines!(ax, df.Time, df.L90, color = RGB(rand(3)...))

    leg = layout[1,2] = LLegend(scene,
        [p1, p2, p3, p4, p5, p6, p7, p8, p9],
        ["10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%"]
    )

    return scene, layout
end

function plot_radii(folder::String, filenamebase::String,
                    Counts::Array{Int64,1}, suffix::String,
                    FileType::AbstractOutputType, units = uAstro;
                    times = Counts,
                    savelog = true,
                    savefolder = pwd(),
                    legend = :topright,
                    kw...)

    uTime = getuTime(uAstro)
    uLength = getuLength(uAstro)

    df = DataFrame(
        Time = Float64[],
        ScaleRadius = Float64[],
        L10 = Float64[],
        L20 = Float64[],
        L30 = Float64[],
        L40 = Float64[],
        L50 = Float64[],
        L60 = Float64[],
        L70 = Float64[],
        L80 = Float64[],
        L90 = Float64[],
        L100 = Float64[],
    )

    progress = Progress(length(Counts), "Loading data and precessing: ")
    for i in eachindex(Counts)
        filename = joinpath(folder, string(filenamebase, @sprintf("%04d", Counts[i]), suffix))

        if FileType == gadget2()
            header, data = read_gadget2(filename)
        elseif FileType == jld2()
            data = read_jld(filename)
        end

        ScaleRadius, LagrangeRadii = lagrange_radii(data, uLength)

        push!(df, [ustrip(uTime, times[i]); ScaleRadius; LagrangeRadii])

        next!(progress, showvalues = [("iter", i), ("time", times[i]), ("file", filename), ("scale radius", ScaleRadius * uLength)])
    end

    if savelog
        outputfile = joinpath(savefolder, "radii.csv")
        CSV.write(outputfile, df)
        println("Radii data saved to ", outputfile)
    end

    println("Plotting scale radius")
    ScaleScene, ScaleLayout = plot_scaleradius(df, uTime, uLength; kw...)

    println("Plotting Lagrange radii")
    LagrangeScene, LagrangeLayout = plot_lagrangeradii90(df, uTime, uLength; kw...)

    return ScaleScene, ScaleLayout, LagrangeScene, LagrangeLayout, df
end