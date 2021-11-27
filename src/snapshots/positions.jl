"""
    function plot_positionslice!(scene, data, u::Union{Nothing, Unitful.FreeUnits} = nothing; kw...)
    function plot_positionslice!(scene, data, collection::Collection, u::Union{Nothing, Unitful.FreeUnits} = nothing; kw...)

Add 2D scatter plot of positions to `scene`.
`data` can be array or dict of arrays, of points or particles.

`collection`: filter the type of particles

# Keywords
$_common_keyword_axis
"""
function plot_positionslice!(scene, data, u::Union{Nothing, Unitful.FreeUnits} = nothing;
                             xaxis = :x,
                             yaxis = :y,
                             kw...)
    x, y = pack_xy(data, u; xaxis, yaxis)
    Makie.scatter!(scene, x, y; kw...)
end

function plot_positionslice!(scene, data, collection::Collection, u::Union{Nothing, Unitful.FreeUnits} = nothing; kw...)
    d = filter(p->p.Collection == collection, data)
    if isempty(d)
        @warn "No $collection particle found."
        return scene
    else
        plot_positionslice!(scene, d, u; kw...)
    end
end

"""
    function plot_positionslice(pos::Array{T, N}, u::Union{Nothing, Unitful.FreeUnits} = nothing; kw...)
    function plot_positionslice(data, u::Union{Nothing, Unitful.FreeUnits} = nothing; kw...)
    function plot_positionslice(data, u::Union{Nothing, Unitful.FreeUnits} = nothing; kw...)

2D scatter plot of positions

`collection`: filter the type of particles

# Keywords
$_common_keyword_figure
$_common_keyword_aspect

# Examples
```jl
julia> scene, layout = plot_positionslice(randn_pvector(100); title = "Positions")
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
                            resolution = (1600, 900),
                            kw...)
    x, y = pack_xy(data, u; xaxis, yaxis)

    scene, layout = layoutscene(; resolution)

    ax = layout[1,1] = GLMakie.Axis(
        scene; title, xlabel, ylabel,
        aspect = AxisAspect(aspect_ratio),
    )

    Makie.scatter!(ax, x, y; kw...)

    if !isnothing(xlims)
        Makie.xlims!(ax, xlims)
    end

    if !isnothing(ylims)
        Makie.ylims!(ax, ylims)
    end

    return scene, layout
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
    plot_positionslice(folder::String, filenamebase::String, Counts::Array{Int64,1}, ::gadget2, u::Union{Nothing, Unitful.FreeUnits} = u"kpc"; kw...)

2D scatter plot of positions in snapshots

# Arguments
$_common_argument_snapshot

# Keywords
$_common_keyword_figure
$_common_keyword_snapshot
$_common_keyword_aspect
- `collection`: filter the type of particles

# Examples
```jl
julia plot_positionslice(joinpath(pathof(AstroPlot), "../../test/snapshots"), "snapshot_", collect(0:20:200), ".gadget2", gadget2(), dpi = 300, resolution = (800,800),
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
                            kw...)
    progress = Progress(length(Counts), "Loading data and plotting: "; #=showspeed=true=#)
    for i in eachindex(Counts)
        snapshot_index = Printf.format(Printf.Format(formatstring), Counts[i])
        filename = joinpath(folder, string(filenamebase, snapshot_index, suffix))
    
        if FileType == gadget2()
            header, data = read_gadget2(filename, units, fileunits)
        elseif FileType == jld2()
            data = read_jld(filename)
        end
    
        if isnothing(collection)
            scene, layout = plot_positionslice(data, getuLength(units); title = "Positions at " * @sprintf("%.6f ", ustrip(times[i])) * string(unit(times[i])),
                                        xaxis, yaxis, xlims, ylims, xlabel, ylabel,
                                        kw...)
        else
            scene, layout = plot_positionslice(data, collection, getuLength(units); title = "Positions at " * @sprintf("%.6f ", ustrip(times[i])) * string(unit(times[i])),
                                        xaxis, yaxis, xlims, ylims, xlabel, ylabel,
                                        kw...)
        end

        outputfilename = joinpath(folder, string("pos_", snapshot_index, ".png"))
        Makie.save(outputfilename, scene)
        next!(progress, showvalues = [("iter", i), ("file", filename)])
    end
    return true
end

"""
    function plot_positionslice_adapt(pos::Array{T, N}, u::Union{Nothing, Unitful.FreeUnits} = nothing; kw...)
    function plot_positionslice_adapt(data, u::Union{Nothing, Unitful.FreeUnits} = nothing; kw...)
    function plot_positionslice_adapt(data, collection::Collection, u::Union{Nothing, Unitful.FreeUnits} = nothing; kw...)

Plot position slice with an adaptive center but fixed box length

`collection`: filter the type of particles

# Keywords
$_common_keyword_figure
$_common_keyword_adapt_len
$_common_keyword_aspect

# Examples
```jl
julia> scene, layout = plot_positionslice_adapt(randn_pvector(100); title = "Positions")
```
"""
function plot_positionslice_adapt(data, u::Union{Nothing, Unitful.FreeUnits} = nothing;
                                  xaxis = :x,
                                  yaxis = :y,
                                  xlabel = "",
                                  ylabel = "",
                                  xlen::Float64 = 1.0,
                                  ylen::Float64 = 1.0,
                                  aspect_ratio = 1.0,
                                  title = "Positions",
                                  resolution = (1600, 900),
                                  kw...)
    x, y = pack_xy(data, u; xaxis, yaxis)

    xcenter = middle(x)
    ycenter = middle(y)

    scene, layout = layoutscene(; resolution)

    ax = layout[1,1] = GLMakie.Axis(
        scene; title, xlabel, ylabel,
        aspect = AxisAspect(aspect_ratio),
    )

    Makie.scatter!(ax, x, y; kw...)

    xlims!(ax, xcenter - 0.5 * xlen, xcenter + 0.5 * xlen)
    ylims!(ax, ycenter - 0.5 * ylen, ycenter + 0.5 * ylen)

    return scene, layout
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
    plot_positionslice_adapt(folder::String, filenamebase::String, Counts::Array{Int64,1}, ::jld2, u::Union{Nothing, Unitful.FreeUnits} = u"kpc"; kw...)

Plot position slice with an adaptive center but fixed box length

# Arguments
$_common_argument_snapshot

# Keywords
$_common_keyword_figure
$_common_keyword_snapshot
$_common_keyword_adapt_len
$_common_keyword_aspect
- `collection`: filter the type of particles

# Examples
```jl
julia> plot_positionslice_adapt(joinpath(pathof(AstroPlot), "../../test/snapshots"), "snapshot_", collect(0:20:200), ".gadget2", gadget2(),
        dpi = 300, resolution = (800,800), xlen = 0.1, ylen = 0.1, times = collect(0.0:0.01:0.1) * u"Gyr")
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
                                  xlen::Float64 = 0.2,
                                  ylen::Float64 = 0.2,
                                  formatstring = "%04d",
                                  kw...)
    progress = Progress(length(Counts), "Loading data and plotting: "; #=showspeed=true=#)
    for i in eachindex(Counts)
        snapshot_index = Printf.format(Printf.Format(formatstring), Counts[i])
        filename = joinpath(folder, string(filenamebase, snapshot_index, suffix))
        
        if FileType == gadget2()
            header, data = read_gadget2(filename, units, fileunits)
        elseif FileType == jld2()
            data = read_jld(filename)
        end

        if isnothing(collection)
            scene, layout = plot_positionslice_adapt(data, getuLength(units); title = "Positions at " * @sprintf("%.6f ", ustrip(times[i])) * string(unit(times[i])),
                                                 xaxis, yaxis, xlabel, ylabel, xlen, ylen,
                                                 kw...)
        else
            scene, layout = plot_positionslice_adapt(data, collection, getuLength(units); title = "Positions at " * @sprintf("%.6f ", ustrip(times[i])) * string(unit(times[i])),
                                                 xaxis, yaxis, xlabel, ylabel, xlen, ylen,
                                                 kw...)
        end

        outputfilename = joinpath(folder, string("pos_", snapshot_index, ".png"))
        Makie.save(outputfilename, scene)
        next!(progress, showvalues = [("iter", i), ("file", filename)])
    end
    return true
end