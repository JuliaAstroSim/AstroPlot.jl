function plot_momentum!(ax, df::DataFrame, axis::Symbol; kw...)
    Makie.lines!(ax, df.time, getproperty(df.momentum, axis); kw...)
end

function plot_momentum!(ax, df::DataFrame; axis = [:x, :y, :z], colors = nothing, kw...)
    if isnothing(colors)
        scenes = [plot_momentum!(ax, df, axis[i]; color = RGB(rand(3)...), kw...) for i in 1:length(axis)]
    else
        scenes = [plot_momentum!(ax, df, axis[i]; color = colors[i], kw...) for i in 1:length(axis)]
    end
    return scenes
end

function plot_momentum(df::DataFrame;
        uTime = u"Gyr",
        uMomentum = u"Msun * kpc / Gyr",
        title = "Total Momentum",
        xlabel = "t [$uTime]",
        ylabel = "E [$uMomentum]",
        resolution = (1600, 900),
        legendposition = :rt,
        axis = [:x, :y, :z],
        colors = nothing,
        kw...
    )
    scene, layout = layoutscene(; resolution)

    ax = layout[1,1] = GLMakie.Axis(
        scene,
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
    )

    scenes = plot_momentum!(ax, df; colors, kw...)

    axislegend(ax, scenes, string.("p", axis), position = legendposition)

    return scene, layout, df
end

function plot_momentum(datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    df.momentum = StructArray(parse.(PVector, df.momentum))
    df.angularmomentum = StructArray(parse.(PVector, df.angularmomentum))
    return plot_momentum(df; kw...)
end





function plot_momentum_angular!(ax, df::DataFrame, axis::Symbol; kw...)
    Makie.lines!(ax, df.time, getproperty(df.angularmomentum, axis); kw...)
end

function plot_momentum_angular!(ax, df::DataFrame; axis = [:x, :y, :z], colors = nothing, kw...)
    if isnothing(colors)
        scenes = [plot_momentum_angular!(ax, df, axis[i]; color = RGB(rand(3)...), kw...) for i in 1:length(axis)]
    else
        scenes = [plot_momentum_angular!(ax, df, axis[i]; color = colors[i], kw...) for i in 1:length(axis)]
    end
    return scenes
end

function plot_momentum_angular(df::DataFrame;
        uTime = u"Gyr",
        uMomentum = u"Msun * kpc / Gyr",
        title = "Total Angular Momentum",
        xlabel = "t [$uTime]",
        ylabel = "E [$uMomentum]",
        resolution = (1600, 900),
        legendposition = :rt,
        axis = [:x, :y, :z],
        colors = nothing,
        kw...
    )
    scene, layout = layoutscene(; resolution)

    ax = layout[1,1] = GLMakie.Axis(
        scene,
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
    )

    scenes = plot_momentum_angular!(ax, df; colors, kw...)

    axislegend(ax, scenes, string.("p", axis), position = legendposition)

    return scene, layout, df
end

function plot_momentum_angular(datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    df.momentum = StructArray(parse.(PVector, df.momentum))
    df.angularmomentum = StructArray(parse.(PVector, df.angularmomentum))
    return plot_momentum_angular(df; kw...)
end