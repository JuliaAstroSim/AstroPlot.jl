function plot_momentum!(ax, df::DataFrame, axis::Symbol; absolute = false, kw...)
    if absolute
        return Makie.lines!(ax, df.time, abs.(getproperty(df.momentum, axis)); kw...)
    else
        return Makie.lines!(ax, df.time, getproperty(df.momentum, axis); kw...)
    end
end

function plot_momentum!(ax, df::DataFrame; axis = [:x, :y, :z], colors = nothing, kw...)
    if isnothing(colors)
        scenes = [plot_momentum!(ax, df, axis[i]; color = RGB(rand(3)...), kw...) for i in 1:length(axis)]
    else
        scenes = [plot_momentum!(ax, df, axis[i]; color = colors[i], kw...) for i in 1:length(axis)]
    end
    return scenes
end

"""
$(TYPEDSIGNATURES)
Plot total momentum in `df` which contains columns named `time` and `momentum`

## Keywords
$_common_keyword_figure
"""
function plot_momentum(df::DataFrame;
        uTime = u"Gyr",
        uMomentum = u"Msun * kpc / Gyr",
        title = "Total Momentum",
        xlabel = "t [$uTime]",
        ylabel = "P [$uMomentum]",
        resolution = (1600, 900),
        legendposition = :rt,
        axis = [:x, :y, :z],
        colors = nothing,
        kw...
    )
    fig = Figure(; resolution)

    ax = GLMakie.Axis(
        fig[1,1],
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
    )

    scenes = plot_momentum!(ax, df; colors, kw...)

    axislegend(ax, scenes, string.("P", axis), position = legendposition)

    return fig, df
end

"""
$(TYPEDSIGNATURES)
Plot total momentum in `datafile` which is a `CSV` file containing columns named `time` and `momentum`

## Keywords
$_common_keyword_figure
"""
function plot_momentum(datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    df.momentum = StructArray(parse.(PVector, df.momentum))
    df.angularmomentum = StructArray(parse.(PVector, df.angularmomentum))
    return plot_momentum(df; kw...)
end





function plot_momentum_angular!(ax, df::DataFrame, axis::Symbol; absolute = false, kw...)
    if absolute
        Makie.lines!(ax, df.time, abs.(getproperty(df.angularmomentum, axis)); kw...)
    else
        Makie.lines!(ax, df.time, getproperty(df.angularmomentum, axis); kw...)
    end
end

function plot_momentum_angular!(ax, df::DataFrame; axis = [:x, :y, :z], colors = nothing, kw...)
    if isnothing(colors)
        scenes = [plot_momentum_angular!(ax, df, axis[i]; color = RGB(rand(3)...), kw...) for i in 1:length(axis)]
    else
        scenes = [plot_momentum_angular!(ax, df, axis[i]; color = colors[i], kw...) for i in 1:length(axis)]
    end
    return scenes
end

"""
$(TYPEDSIGNATURES)
Plot total angular momentum in `df` which contains columns named `time` and `angularmomentum`

## Keywords
$_common_keyword_figure
"""
function plot_momentum_angular(df::DataFrame;
        uTime = u"Gyr",
        uMomentumAngular = u"Msun * kpc^2 / Gyr",
        title = "Total Angular Momentum",
        xlabel = "t [$uTime]",
        ylabel = "L [$uMomentumAngular]",
        resolution = (1600, 900),
        legendposition = :rt,
        axis = [:x, :y, :z],
        colors = nothing,
        kw...
    )
    fig = Figure(; resolution)

    ax = GLMakie.Axis(
        fig[1,1],
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
    )

    scenes = plot_momentum_angular!(ax, df; colors, kw...)

    axislegend(ax, scenes, string.("L", axis), position = legendposition)

    return fig, df
end

"""
$(TYPEDSIGNATURES)
Plot total angular momentum in `datafile` which is a `CSV` file containing columns named `time` and `angularmomentum`

## Keywords
$_common_keyword_figure
"""
function plot_momentum_angular(datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    df.momentum = StructArray(parse.(PVector, df.momentum))
    df.angularmomentum = StructArray(parse.(PVector, df.angularmomentum))
    return plot_momentum_angular(df; kw...)
end

function sum_momentum(data::Array)
    vm = [p.Vel * p.Mass for p in data]
    return sum(vm)
end

function sum_momentum(data::StructArray)
    vm = StructArray(data.Vel .* data.Mass)
    return sum(vm)
end

function sum_angular_momentum(data::Array)
    rvm = [p.Mass * cross(p.Pos, p.Vel) for p in data]
    return sum(rvm)
end

function sum_angular_momentum(data::StructArray)
    rvm = data.Mass .* cross.(data.Pos, data.Vel)
    return sum(rvm)
end

"""
$(TYPEDSIGNATURES)
Plot total momentum and total angular momentum of particles in each snapshot.

## Arguments
$_common_argument_snapshot

## Keywords
$_common_keyword_snapshot
$_common_keyword_figure
$_common_keyword_log
"""
function plot_momentum(
    folder::String, filenamebase::String,
    Counts::Vector{Int64}, suffix::String,
    FileType::AbstractOutputType, units = uAstro, fileunits = uGadget2;
    times = Counts,
    savelog = true,
    savefolder = pwd(),
    formatstring = "%04d",
    type = Star,
    kw...
)
    uTime = getuTime(units)
    uMomentum = getuMomentum(units)
    uMomentumAngular = getuMomentumAngular(units)
    df = DataFrame(
        time = Array{Float64}(undef, length(Counts)),
        momentum = StructArray{PVector{Float64}}(undef, length(Counts)),
        angularmomentum = StructArray{PVector{Float64}}(undef, length(Counts)),
    )
    
    progress = Progress(length(Counts), "Loading data and precessing: "; #=showspeed=true=#)
    for i in eachindex(Counts)
        snapshot_index = Printf.format(Printf.Format(formatstring), Counts[i])
        filename = joinpath(folder, string(filenamebase, snapshot_index, suffix))

        if FileType == gadget2()
            header, data = read_gadget2(filename, units, fileunits; type)
        elseif FileType == jld2()
            data = read_jld(filename)
        end

        P = sum_momentum(data)
        L = sum_angular_momentum(data)
        df.time[i] = ustrip(uTime, times[i])
        df.momentum[i] = ustrip(uMomentum, P)
        df.angularmomentum[i] = ustrip(uMomentumAngular, L)

        next!(progress, showvalues = [
            ("iter", i),
            ("time", times[i]),
            ("file", filename),
            ("momentum", P),
            ("angular momentum", L),
        ])
    end

    if savelog
        outputfile = joinpath(savefolder, "momentum.csv")
        CSV.write(outputfile, df)
        println("Momentum data saved to ", outputfile)
    end

    println("Plotting momentum")
    return plot_momentum(df; uTime, uMomentum, kw...), plot_momentum_angular(df; uTime, uMomentum, kw...)
end