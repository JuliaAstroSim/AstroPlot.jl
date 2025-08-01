"""
$(TYPEDSIGNATURES)
        
Plot `pos` as particle trajectory

## Keywords
$_common_keyword_axis
$_common_keyword_lims
- `color`: color of the trajectory line
"""
function plot_trajectory!(ax, pos::Array{T,1};
                          xaxis = :x,
                          yaxis = :y,
                          xlims = nothing,
                          ylims = nothing,
                          color = nothing,
                          kw...
                          ) where T<:PVector
    len = length(pos)
    x = zeros(len)
    y = zeros(len)

    for i in 1:len
        x[i] = getproperty(pos[i], xaxis)
        y[i] = getproperty(pos[i], yaxis)
    end
    
    if isnothing(color)
        s = Makie.lines!(ax, x, y, color = RGB(rand(3)...); kw...)
    else
        s = Makie.lines!(ax, x, y, color = color; kw...)
    end

    if !isnothing(xlims)
        Makie.xlims!(ax, xlims)
    end
    
    if !isnothing(ylims)
        Makie.ylims!(ax, ylims)
    end

    return s
end

"""
$(TYPEDSIGNATURES)

## Keywords
$_common_keyword_figure
- colors: use different colors for different particles
$_common_keyword_aspect
"""
function plot_trajectory(pos::Dict{Int64, Array{AbstractPoint,1}}, u = u"kpc";
                         xaxis = :x,
                         yaxis = :y,
                         xlims = nothing,
                         ylims = nothing,
                         xlabel = "$xaxis [$u]",
                         ylabel = "$yaxis [$u]",
                         aspect_ratio = 1.0,
                         title = "Trajectory",
                         colors = nothing,
                         size = (1600, 900),
                         kw...)
    fig = Figure(; size)
    
    ax = GLMakie.Axis(
        fig[1,1],
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
        aspect = AxisAspect(aspect_ratio),
    )

    if isnothing(colors)
        scenes = [plot_trajectory!(ax, ustrip.(u, pos[key]); xaxis, yaxis, color = RGB(rand(3)...), kw...) for key in keys(pos)]
    else
        scenes = [plot_trajectory!(ax, ustrip.(u, pos[collect(keys(pos))[i]]); xaxis, yaxis, color = colors[i], kw...) for i in 1:length(keys(pos))]
    end

    leg = Legend(
        fig[1,1], scenes,
        string.(keys(pos)),
        tellheight = false,
        tellwidth = false,
        halign = :right,
        valign = :top,
        margin = (10, 10, 10, 10),
    )

    if !isnothing(xlims)
        Makie.xlims!(ax, xlims)
    end
    
    if !isnothing(ylims)
        Makie.ylims!(ax, ylims)
    end

    return fig
end

"""
$(TYPEDSIGNATURES)

Plot trajectories of particles from a series of snapshots

## Arguments
$_common_argument_snapshot
- `ids`: plot trajectories of selected particles whose ID is in `ids`

## Keywords
$_common_keyword_figure
- `colors`: use different colors for different particles
$_common_keyword_snapshot
$_common_keyword_aspect

## Examples
```jl
julia fig, pos = plot_trajectory(joinpath(pathof(AstroPlot), "../../test/snapshots"), "snapshot_", collect(0:20:200),
            [1,2,3], ".gadget2", gadget2(), size = (800,800))
```
"""
function plot_trajectory(folder::String, filenamebase::String, Counts::Array{Int64,1},
                         ids::Array{Int64,1}, suffix::String, FileType::AbstractOutputType, units = uAstro, fileunits = uGadget2;
                         xaxis = :x,
                         yaxis = :y,
                         xlims = nothing,
                         ylims = nothing,
                         xlabel = "$xaxis [$(getuLength(units))]",
                         ylabel = "$yaxis [$(getuLength(units))]",
                         aspect_ratio = 1.0,
                         title = "Trajectory",
                         colors = nothing,
                         formatstring = "%04d",
                         type = Star,
                         kw...
                         )
    pos = Dict{Int64, Array{AbstractPoint,1}}()
    for id in ids
        pos[id] = Array{AbstractPoint,1}()
    end

    progress = Progress(length(Counts), desc = "Loading data: ")
    for i in Counts
        snapshot_index = Printf.format(Printf.Format(formatstring), i)
        filename = joinpath(folder, string(filenamebase, snapshot_index, suffix))
        
        if FileType == gadget2()
            header, data = read_gadget2(filename, units, fileunits; type)
        elseif FileType == jld2()
            data = read_jld(filename)
        end

        for p in Iterators.flatten(values(data))
            if p.ID in ids
                push!(pos[p.ID], p.Pos)
            end
        end
        next!(progress, showvalues = [("iter", i), ("file", filename)])
    end

    fig = plot_trajectory(pos, getuLength(units); xaxis, yaxis, xlims, ylims, xlabel, ylabel, aspect_ratio, title, colors, kw...)
    return fig, pos
end

"""
$(TYPEDSIGNATURES)

Plot trajectories in `ax`

## Keywords
$_common_keyword_axis
$_common_keyword_lims
"""
function plot_trajectory!(fig, ax, pos::Dict{Int64, Array{AbstractPoint,1}}, u = u"kpc";
                         xaxis = :x,
                         yaxis = :y,
                         xlims = nothing,
                         ylims = nothing,
                         colors = nothing,
                         kw...)
    if isnothing(colors)
        scenes = [plot_trajectory!(ax, ustrip.(u, pos[key]); xaxis, yaxis, color = RGB(rand(3)...), kw...) for key in keys(pos)]
    else
        scenes = [plot_trajectory!(ax, ustrip.(u, pos[collect(keys(pos))[i]]); xaxis, yaxis, color = colors[i], kw...) for i in 1:length(keys(pos))]
    end
    
    if !isnothing(xlims)
        Makie.xlims!(ax, xlims)
    end
    
    if !isnothing(ylims)
        Makie.ylims!(ax, ylims)
    end

    return scenes, string.(keys(pos))
end

"""
$(TYPEDSIGNATURES)

Plot trajectories in `ax`

## Arguments
$_common_argument_snapshot

## Keywords
$_common_keyword_axis
$_common_keyword_lims
$_common_keyword_snapshot
"""
function plot_trajectory!(fig, ax, folder::String, filenamebase::String, Counts::Array{Int64,1},
                         ids::Array{Int64,1}, suffix::String, FileType::AbstractOutputType, units = uAstro, fileunits = uGadget2;
                         xaxis = :x,
                         yaxis = :y,
                         xlims = nothing,
                         ylims = nothing,
                         colors = nothing,
                         formatstring = "%04d",
                         type = Star,
                         kw...
                         )
    pos = Dict{Int64, Array{AbstractPoint,1}}()
    for id in ids
        pos[id] = Array{AbstractPoint,1}()
    end

    progress = Progress(length(Counts), desc = "Loading data: ")
    for i in eachindex(Counts)
        snapshot_index = Printf.format(Printf.Format(formatstring), Counts[i])
        filename = joinpath(folder, string(filenamebase, snapshot_index, suffix))
        
        if FileType == gadget2()
            header, data = read_gadget2(filename, units, fileunits; type)
        elseif FileType == jld2()
            data = read_jld(filename)
        end

        for p in Iterators.flatten(values(data))
            if p.ID in ids
                push!(pos[p.ID], p.Pos)
            end
        end
        next!(progress, showvalues = [("iter", i), ("file", filename)])
    end

    return plot_trajectory!(fig, ax, pos, getuLength(units);
            xaxis, yaxis, xlims, ylims, colors,kw...)
end