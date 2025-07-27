"""
$(TYPEDSIGNATURES)
Add 2D scatter plot of positions to `fig`.
`data` can be array or dict of arrays, of points or particles.

`collection`: filter the type of particles

## Keywords
$_common_keyword_axis
"""
function plot_positionslice!(fig, data, u::Union{Nothing, Unitful.FreeUnits} = nothing;
                             xaxis = :x,
                             yaxis = :y,
                             markersize = estimate_markersize(data, u; xaxis, yaxis),
                             markerspace=:data,
                             kw...)
    xu, yu = pack_xy(data; xaxis, yaxis)
    x = ustrip.(u, xu)
    y = ustrip.(u, yu)
    Makie.scatter!(fig, x, y; markersize, markerspace, kw...)
end

function plot_positionslice!(fig, data, collection::Collection, u::Union{Nothing, Unitful.FreeUnits} = nothing; kw...)
    d = filter(p->p.Collection == collection, data)
    if isempty(d)
        @warn "No $collection particle found."
        return fig
    else
        plot_positionslice!(fig, d, u; kw...)
    end
end

"""
$(TYPEDSIGNATURES)
2D scatter plot of positions

`collection`: filter the type of particles

## Keywords
$_common_keyword_figure
$_common_keyword_aspect

## Examples
```jl
julia> fig = plot_positionslice(randn_pvector(100); title = "Positions")
```
"""
function plot_positionslice(data, u::Union{Nothing, Unitful.FreeUnits} = nothing;
                            xaxis = :x,
                            yaxis = :y,
                            xlabel = "",
                            ylabel = "",
                            xlims = nothing,
                            ylims = nothing,
                            aspect_ratio = 1.0,
                            title = "Positions",
                            markersize = (isnothing(xlims) && isnothing(ylims)) ? estimate_markersize(data, u; xaxis, yaxis) : estimate_markersize((xlims[2] - xlims[1]) * (ylims[2] - ylims[1])),
                            markerspace=:data,
                            size = (1000, 1000),
                            kw...)
    xu, yu = pack_xy(data; xaxis, yaxis)
    x = ustrip.(u, xu)
    y = ustrip.(u, yu)

    fig = Figure(; size)

    ax = GLMakie.Axis(
        fig[1,1]; title, xlabel, ylabel,
        aspect = AxisAspect(aspect_ratio),
    )

    Makie.scatter!(ax, x, y; markersize, markerspace, kw...)

    if !isnothing(xlims)
        Makie.xlims!(ax, xlims)
    end

    if !isnothing(ylims)
        Makie.ylims!(ax, ylims)
    end

    return fig
end

function plot_positionslice(data, collection::Collection, u::Union{Nothing, Unitful.FreeUnits} = nothing; kw...)
    d = filter(p->p.Collection == collection, data)
    if isempty(d)
        @warn "No $collection particle found."
        return nothing
    else
        return plot_positionslice(d, u; kw...)
    end
end

"""
$(TYPEDSIGNATURES)
2D scatter plot of positions in snapshots

## Arguments
$_common_argument_snapshot

## Keywords
$_common_keyword_figure
$_common_keyword_snapshot
$_common_keyword_aspect
- `collection`: filter the type of particles

## Examples
```jl
julia plot_positionslice(joinpath(pathof(AstroPlot), "../../test/snapshots"), "snapshot_", collect(0:20:200), ".gadget2", gadget2(), size = (800,800),
        xlims = (-0.05, +0.05), ylims = (-0.05, +0.05), times = collect(0.0:0.01:0.1) * u"Gyr")
```
"""
function plot_positionslice(folder::String, filenamebase::String, Counts::Array{Int64,1},
                            suffix::String, FileType::AbstractOutputType, units = uAstro, fileunits = uGadget2;
                            times = Counts,
                            xaxis = :x,
                            yaxis = :y,
                            xlims = nothing,
                            ylims = nothing,
                            collection::Union{Nothing, Collection} = nothing,
                            xlabel = "$(xaxis)$(axisunit(getuLength(units)))",
                            ylabel = "$(yaxis)$(axisunit(getuLength(units)))",
                            formatstring = "%04d",
                            type = Star,
                            kw...)
    progress = Progress(length(Counts), desc = "Loading data and plotting: ")
    for i in eachindex(Counts)
        snapshot_index = Printf.format(Printf.Format(formatstring), Counts[i])
        filename = joinpath(folder, string(filenamebase, snapshot_index, suffix))
    
        if FileType == gadget2()
            header, data = read_gadget2(filename, units, fileunits; type)
        elseif FileType == jld2()
            data = read_jld(filename)
        end
    
        if isnothing(collection)
            fig = plot_positionslice(data, getuLength(units); title = "Positions at " * @sprintf("%.6f ", ustrip(times[i])) * string(unit(times[i])),
                                        xaxis, yaxis, xlims, ylims, xlabel, ylabel,
                                        kw...)
        else
            fig = plot_positionslice(data, collection, getuLength(units); title = "Positions at " * @sprintf("%.6f ", ustrip(times[i])) * string(unit(times[i])),
                                        xaxis, yaxis, xlims, ylims, xlabel, ylabel,
                                        kw...)
        end

        outputfilename = joinpath(folder, string("pos_", snapshot_index, ".png"))
        Makie.save(outputfilename, fig)
        next!(progress, showvalues = [("iter", i), ("file", filename)])
    end
    return true
end

"""
$(TYPEDSIGNATURES)
Plot position slice with an adaptive center but fixed box length

`collection`: filter the type of particles

## Keywords
$_common_keyword_figure
$_common_keyword_adapt_len
$_common_keyword_aspect

## Examples
```jl
julia> fig = plot_positionslice_adapt(randn_pvector(100); title = "Positions")
```
"""
function plot_positionslice_adapt(data, u::Union{Nothing, Unitful.FreeUnits} = nothing;
                                  xaxis = :x,
                                  yaxis = :y,
                                  xlabel = "",
                                  ylabel = "",
                                  xlen = 1.0,
                                  ylen = 1.0,
                                  aspect_ratio = 1.0,
                                  title = "Positions",
                                  markersize = estimate_markersize(xlen * ylen),
                                  markerspace=:data,
                                  size = (1000, 1000),
                                  kw...)
    xu, yu = pack_xy(data; xaxis, yaxis)
    x = ustrip.(u, xu)
    y = ustrip.(u, yu)

    xcenter = middle(x)
    ycenter = middle(y)

    fig = Figure(; size)

    ax = GLMakie.Axis(
        fig[1,1]; title, xlabel, ylabel,
        aspect = AxisAspect(aspect_ratio),
    )

    Makie.scatter!(ax, x, y; markersize, markerspace, kw...)

    Makie.xlims!(ax, xcenter - 0.5 * xlen, xcenter + 0.5 * xlen)
    Makie.ylims!(ax, ycenter - 0.5 * ylen, ycenter + 0.5 * ylen)

    return fig
end

function plot_positionslice_adapt(data, collection::Collection, u::Union{Nothing, Unitful.FreeUnits} = nothing; kw...)
    d = filter(p->p.Collection == collection, data)
    if isempty(d)
        @warn "No $collection particle found."
        return nothing
    else
        return plot_positionslice_adapt(d, u; kw...)
    end
end

"""
$(TYPEDSIGNATURES)
Plot position slice with an adaptive center but fixed box length

## Arguments
$_common_argument_snapshot

## Keywords
$_common_keyword_figure
$_common_keyword_snapshot
$_common_keyword_adapt_len
$_common_keyword_aspect
- `collection`: filter the type of particles

## Examples
```jl
julia> plot_positionslice_adapt(joinpath(pathof(AstroPlot), "../../test/snapshots"), "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
        size = (800,800), xlen = 0.1, ylen = 0.1, times = collect(0.0:0.01:0.1) * u"Gyr")
```
"""
function plot_positionslice_adapt(folder::String, filenamebase::String, Counts::Array{Int64,1},
                                  suffix::String, FileType::AbstractOutputType, units = uAstro, fileunits = uGadget2;
                                  times = Counts,
                                  xaxis = :x,
                                  yaxis = :y,
                                  collection::Union{Nothing, Collection} = nothing,
                                  xlabel = "$(xaxis)$(axisunit(getuLength(units)))",
                                  ylabel = "$(yaxis)$(axisunit(getuLength(units)))",
                                  xlen = 0.2,
                                  ylen = 0.2,
                                  formatstring = "%04d",
                                  type = Star,
                                  kw...)
    progress = Progress(length(Counts), desc = "Loading data and plotting: ")
    for i in eachindex(Counts)
        snapshot_index = Printf.format(Printf.Format(formatstring), Counts[i])
        filename = joinpath(folder, string(filenamebase, snapshot_index, suffix))
        
        if FileType == gadget2()
            header, data = read_gadget2(filename, units, fileunits; type)
        elseif FileType == jld2()
            data = read_jld(filename)
        end

        if isnothing(collection)
            fig = plot_positionslice_adapt(data, getuLength(units); title = "Positions at " * @sprintf("%.6f ", ustrip(times[i])) * string(unit(times[i])),
                                                 xaxis, yaxis, xlabel, ylabel, xlen, ylen,
                                                 kw...)
        else
            fig = plot_positionslice_adapt(data, collection, getuLength(units); title = "Positions at " * @sprintf("%.6f ", ustrip(times[i])) * string(unit(times[i])),
                                                 xaxis, yaxis, xlabel, ylabel, xlen, ylen,
                                                 kw...)
        end

        outputfilename = joinpath(folder, string("pos_", snapshot_index, ".png"))
        Makie.save(outputfilename, fig)
        next!(progress, showvalues = [("iter", i), ("file", filename)])
    end
    return true
end