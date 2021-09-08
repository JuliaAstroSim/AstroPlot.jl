"""
    function pos_from_center(particles, u = u"kpc")
    function pos_from_center(pos::Array{T,1}, u = u"kpc") where T <: AbstractPoint

Return a unitless array of positions relative to the center.
"""
function pos_from_center(particles, u = u"kpc")
    p0 = median(particles, :Pos)
    return [ustrip(u, p.Pos - p0) for p in particles]
end

function pos_from_center(pos::Array{T,1}, u = u"kpc") where T <: AbstractPoint
    p0 = median(pos)
    return [ustrip(u, p - p0) for p in pos]
end

"""
    function lagrange_radii(data, u = u"kpc")

Return a `Tuple` of scale radius and Lagrange radii. Designed for spherically symmetric systems.
"""
function lagrange_radii(data, u = u"kpc")
    pos = pos_from_center(data, u)

    R = norm.(pos)
    sort!(R)

    N = length(data)
    ScaleRadius = R[floor(Int64, N / 2.718281828459)]

    len = div(N, 10)
    index = collect(len : len : N)
    return ScaleRadius, [R[i] for i in index]
end

function plot_scaleradius!(ax, df::DataFrame;
                           kw...)
    Makie.lines!(ax, df.Time, df.ScaleRadius; kw...)
end

"""
    function plot_scaleradius(df::DataFrame, uTime::Units, uLength::Units; kw...)

Plot evolution of scale radius by time. `df` contains columns named `Time` and `ScaleRadius`

Return a `Tuple` of scene and layout

# Keywords
$_common_keyword_label
- `title`: title line of the figure
- `resolution`: figure size
"""
function plot_scaleradius(df::DataFrame, uTime::Units, uLength::Units;
                          xlabel = "t$(axisunit(uTime))",
                          ylabel = "r$(axisunit(uLength))",
                          title = "Scale radius",
                          resolution = (1600, 900),
                          kw...)
    scene, layout = layoutscene(; resolution)

    ax = layout[1,1] = GLMakie.Axis(
        scene; title, xlabel, ylabel,
    )

    plot_scaleradius!(ax, df; kw...)

    return scene, layout
end

"""
    function plot_lagrangeradii!(scene, ax, layout, df::DataFrame; kw...)

Plot evolution of Lagrange radii by time. `df` contains columns named `Time` and `L10`, `L20`, ..., `L100`

Return a `Tuple` of scenes and layouts of different line plots

# Keywords
$_common_keyword_title
$_common_keyword_axis_label
"""
function plot_lagrangeradii!(scene, ax, layout, df::DataFrame;
                            colors = nothing,
                            kw...)
    if isnothing(colors)
        colors = [RGB(rand(3)...) for i in 1:10]
    else
        if length(colors) < 10
            colors = [colors...; [RGB(rand(3)...) for i in 1:10-length(colors)]]
        end
    end

    p1 = Makie.lines!(ax, df.Time, df.L10, color = colors[1]; kw...)
    p2 = Makie.lines!(ax, df.Time, df.L20, color = colors[2]; kw...)
    p3 = Makie.lines!(ax, df.Time, df.L30, color = colors[3]; kw...)
    p4 = Makie.lines!(ax, df.Time, df.L40, color = colors[4]; kw...)
    p5 = Makie.lines!(ax, df.Time, df.L50, color = colors[5]; kw...)
    p6 = Makie.lines!(ax, df.Time, df.L60, color = colors[6]; kw...)
    p7 = Makie.lines!(ax, df.Time, df.L70, color = colors[7]; kw...)
    p8 = Makie.lines!(ax, df.Time, df.L80, color = colors[8]; kw...)
    p9 = Makie.lines!(ax, df.Time, df.L90, color = colors[9]; kw...)
    p10 = Makie.lines!(ax, df.Time, df.L100, color = colors[10]; kw...)

    scenes = [p10, p9, p8, p7, p6, p5, p4, p3, p2, p1]
    columns = ["100%", "90%", "80%", "70%", "60%", "50%", "40%", "30%", "20%", "10%"]
    leg = layout[1,2] = Legend(scene, scenes, columns)

    return scenes, columns
end

"""
    function plot_lagrangeradii(df::DataFrame, uTime::Units, uLength::Units; kw...)

Plot evolution of Lagrange radii by time. `df` contains columns named `Time` and `L10`, `L20`, ..., `L100`

Return a `Tuple` of scene and layout

# Keywords
$_common_keyword_title
$_common_keyword_axis_label
"""
function plot_lagrangeradii(df::DataFrame, uTime::Units, uLength::Units;
                            xlabel = "t$(axisunit(uTime))",
                            ylabel = "r$(axisunit(uLength))",
                            title = "Lagrange radii",
                            colors = nothing,
                            resolution = (1600, 900),
                            kw...)
    scene, layout = layoutscene(; resolution)

    ax = layout[1,1] = GLMakie.Axis(
        scene; title, xlabel, ylabel,
    )

    plot_lagrangeradii!(scene, ax, layout, df; colors, kw...)

    return scene, layout
end

"""
    function plot_lagrangeradii90!(scene, ax, layout, df::DataFrame; kw...)

Plot evolution of Lagrange radii by time. `df` contains columns named `Time` and `L10`, `L20`, ..., `L90`
`L100` is omitted, because in most cases, those escaping particles may over distort the figure.

Return a `Tuple` of scenes and layouts of different line plots

# Keywords
$_common_keyword_title
$_common_keyword_axis_label
"""
function plot_lagrangeradii90!(scene, ax, layout, df::DataFrame;
                               colors = nothing,
                               kw...)
    if isnothing(colors)
        colors = [RGB(rand(3)...) for i in 1:10]
    else
        if length(colors) < 10
            colors = [colors...; [RGB(rand(3)...) for i in 1:10-length(colors)]]
        end
    end

    p1 = Makie.lines!(ax, df.Time, df.L10, color = colors[1]; kw...)
    p2 = Makie.lines!(ax, df.Time, df.L20, color = colors[2]; kw...)
    p3 = Makie.lines!(ax, df.Time, df.L30, color = colors[3]; kw...)
    p4 = Makie.lines!(ax, df.Time, df.L40, color = colors[4]; kw...)
    p5 = Makie.lines!(ax, df.Time, df.L50, color = colors[5]; kw...)
    p6 = Makie.lines!(ax, df.Time, df.L60, color = colors[6]; kw...)
    p7 = Makie.lines!(ax, df.Time, df.L70, color = colors[7]; kw...)
    p8 = Makie.lines!(ax, df.Time, df.L80, color = colors[8]; kw...)
    p9 = Makie.lines!(ax, df.Time, df.L90, color = colors[9]; kw...)

    scenes = [p9, p8, p7, p6, p5, p4, p3, p2, p1]
    columns = ["90%", "80%", "70%", "60%", "50%", "40%", "30%", "20%", "10%"]
    leg = layout[1,2] = Legend(scene, scenes, columns)

    return scenes, columns
end

"""
    function plot_lagrangeradii90(df::DataFrame, uTime::Units, uLength::Units; kw...)

Plot evolution of Lagrange radii by time. `df` contains columns named `Time` and `L10`, `L20`, ..., `L90`
`L100` is omitted, because in most cases, those escaping particles may over distort the figure.

Return a `Tuple` of scene and layout

# Keywords
$_common_keyword_title
$_common_keyword_axis_label
"""
function plot_lagrangeradii90(df::DataFrame, uTime::Units, uLength::Units;
                              xlabel = "t [$uTime]",
                              ylabel = "r [$uLength]",
                              title = "Lagrange radii",
                              resolution = (1600, 900),
                              kw...)
    scene, layout = layoutscene(; resolution)

    ax = layout[1,1] = GLMakie.Axis(
        scene; title, xlabel, ylabel,
    )

    plot_lagrangeradii90!(scene, ax, layout, df; kw...)

    return scene, layout
end

"""
    function plot_radii(folder::String, filenamebase::String, Counts::Array{Int64,1}, suffix::String, FileType::AbstractOutputType, units = uAstro; kw...)

Plot scale radius and Lagrange radii (up to 90% by default)

Return `Tuple(ScaleScene, ScaleLayout, LagrangeScene, LagrangeLayout, df)`. `df` contains radii data

# Arguments
$_common_argument_snapshot

# Keywords
$_common_keyword_snapshot

# Examples
julia> ScaleScene, ScaleLayout, LagrangeScene, LagrangeLayout, df = plot_radii(
    joinpath(pathof(AstroPlot), "../../test/snapshots"), "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
    times = collect(0.0:0.01:0.1) * u"Gyr", title = "Radii plot")
"""
function plot_radii(folder::String, filenamebase::String,
                    Counts::Array{Int64,1}, suffix::String,
                    FileType::AbstractOutputType, units = uAstro;
                    times = Counts,
                    savelog = true,
                    savefolder = pwd(),
                    formatstring = "%04d",
                    kw...)

    uTime = getuTime(units)
    uLength = getuLength(units)

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
        snapshot_index = @eval @sprintf($formatstring, $(Counts[i]))
        filename = joinpath(folder, string(filenamebase, snapshot_index, suffix))

        if FileType == gadget2()
            data = read_gadget2_pos(filename)
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

    println("Plotting Lagrange radii 90%")
    LagrangeScene, LagrangeLayout = plot_lagrangeradii90(df, uTime, uLength; kw...)

    return ScaleScene, ScaleLayout, LagrangeScene, LagrangeLayout, df
end

"""
    function plot_radii(AS, SL, AL, LL, folder::String, filenamebase::String, Counts::Array{Int64,1}, suffix::String, FileType::AbstractOutputType, units = uAstro; kw...)

Plot scale radius and Lagrange radii (up to 90% by default)
Return radii data in `Dict`

# Arguments
- `AS`: `Axis` of scale radius scene
- `SL`: Lagrange radii scene
- `AL`: `Axis` of Lagrange radii scene
- `LL`: `layout` of Lagrange radii scene
$_common_argument_snapshot

# Keywords
$_common_keyword_snapshot

# Examples
julia> ScaleScene, ScaleLayout, LagrangeScene, LagrangeLayout, df = plot_radii(
    joinpath(pathof(AstroPlot), "../../test/snapshots"), "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
    times = collect(0.0:0.01:0.1) * u"Gyr", title = "Radii plot")
"""
function plot_radii!(AS, SL, AL, LL, folder::String, filenamebase::String,
                    Counts::Array{Int64,1}, suffix::String,
                    FileType::AbstractOutputType, units = uAstro;
                    times = Counts,
                    savelog = true,
                    savefolder = pwd(),
                    formatstring = "%04d",
                    kw...)
    uTime = getuTime(units)
    uLength = getuLength(units)

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
        snapshot_index = @eval @sprintf($formatstring, $(Counts[i]))
        filename = joinpath(folder, string(filenamebase, snapshot_index, suffix))

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
    plot_scaleradius!(AS, df; kw...)

    println("Plotting Lagrange radii")
    LScenes, LNames = plot_lagrangeradii90!(SL, AL, LL, df; kw...)

    return df
end