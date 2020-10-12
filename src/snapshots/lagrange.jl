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
    return Plots.plot(
        df.Time, df.ScaleRadius;
        title = "Scale radius",
        label = nothing,
        xlabel = xlabel,
        ylabel = ylabel,
        kw...
    )
end

function plot_lagrangeradii(df::DataFrame, uTime::Units, uLength::Units;
                            xlabel = "t [$uTime]",
                            ylabel = "r [$uLength]",
                            kw...)
    return Plots.plot(
        df.Time,
        [df.L10, df.L20, df.L30, df.L40, df.L50, df.L60, df.L70, df.L80, df.L90, df.L100];
        title = "Lagrange radii",
        label = ["10%" "20%" "30%" "40%" "50%" "60%" "70%" "80%" "90%" "100%"],
        xlabel = xlabel,
        ylabel = ylabel,
        kw...
    )
end

"""
function plot_lagrangeradii90(df::DataFrame, uTime::Units, uLength::Units, kw...)

    plot Lagrange radii without 100% radius for better looking.
"""
function plot_lagrangeradii90(df::DataFrame, uTime::Units, uLength::Units;
                              xlabel = "t [$uTime]",
                              ylabel = "r [$uLength]",
                              kw...)
    return Plots.plot(
        df.Time,
        [df.L10, df.L20, df.L30, df.L40, df.L50, df.L60, df.L70, df.L80, df.L90];
        title = "Lagrange radii",
        label = ["10%" "20%" "30%" "40%" "50%" "60%" "70%" "80%" "90%"],
        xlabel = xlabel,
        ylabel = ylabel,
        kw...
    )
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
    ScalePlot = plot_scaleradius(df, uTime, uLength; legend = legend, kw...)

    println("Plotting Lagrange radii")
    LagrangePlot = plot_lagrangeradii90(df, uTime, uLength; legend = legend, kw...)

    return ScalePlot, LagrangePlot, df
end