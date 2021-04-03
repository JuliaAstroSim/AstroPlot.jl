function plot_positionslice!(scene, data, u = nothing;
                             xaxis = :x,
                             yaxis = :y,
                             kw...)
    x, y = pack_xy(data, u; xaxis, yaxis)
    Makie.scatter!(scene, x, y; kw...)
end

function plot_positionslice(pos::Array{T, N}, u = nothing;
                            xaxis = :x,
                            yaxis = :y,
                            xlabel = "",
                            ylabel = "",
                            xlims = nothing,
                            ylims = nothing,
                            aspect_ratio = 1.0,
                            title = "Positions",
                            resolution = (1600, 900),
                            kw...) where T <: AbstractPoint where N
    len = length(pos)
    x = zeros(len)
    y = zeros(len)

    for i in 1:len
        x[i] = ustrip(u, getproperty(pos[i], xaxis))
        y[i] = ustrip(u, getproperty(pos[i], yaxis))
    end

    scene, layout = layoutscene(; resolution)

    ax = layout[1,1] = Axis(
        scene,
        title = title,
        xlabel = xlabel,
        ylabel = ylabel,
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

function plot_positionslice(data, u = nothing;
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
    x = [ustrip(u, getproperty(p.Pos, xaxis)) for p in Iterators.flatten(values(data))]
    y = [ustrip(u, getproperty(p.Pos, yaxis)) for p in Iterators.flatten(values(data))]

    scene, layout = layoutscene(; resolution)

    ax = layout[1,1] = Axis(
        scene,
        title = title,
        xlabel = xlabel,
        ylabel = ylabel,
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

"""
    plot_positionslice(folder::String, filenamebase::String, Counts::Array{Int64,1}, ::gadget2, u = u"kpc"; kw...)

Plot position slice 
"""
function plot_positionslice(folder::String, filenamebase::String, Counts::Array{Int64,1},
                            suffix::String, FileType::AbstractOutputType, u = u"kpc";
                            times = Counts,
                            xaxis = :x,
                            yaxis = :y,
                            xlims = nothing,
                            ylims = nothing,
                            xlabel = "$xaxis [$u]",
                            ylabel = "$yaxis [$u]",
                            formatstring = "%04d",
                            kw...)
    progress = Progress(length(Counts), "Loading data and plotting: ")
    for i in eachindex(Counts)
        snapshot_index = @eval @sprintf($formatstring, $(Counts[i]))
        filename = joinpath(folder, string(filenamebase, snapshot_index, suffix))
    
        if FileType == gadget2()
            data = read_gadget2_pos(filename)
        elseif FileType == jld2()
            data = read_jld(filename)
        end
    
        scene, layout = plot_positionslice(data, u; title = "Positions at " * @sprintf("%.6f ", ustrip(times[i])) * string(unit(times[i])),
                                        xaxis = xaxis,
                                        yaxis = yaxis,
                                        xlims = xlims,
                                        ylims = ylims,
                                        xlabel = xlabel,
                                        ylabel = ylabel,
                                        kw...)

        outputfilename = joinpath(folder, string("pos_", snapshot_index, ".png"))
        Makie.save(outputfilename, scene)
        next!(progress, showvalues = [("iter", i), ("file", filename)])
    end
    return true
end

function plot_positionslice_adapt(pos::Array{T, N}, u = nothing;
                                  xaxis = :x,
                                  yaxis = :y,
                                  xlabel = "",
                                  ylabel = "",
                                  xlen = 1.0u"kpc",
                                  ylen = 1.0u"kpc",
                                  aspect_ratio = 1.0,
                                  title = "Positions",
                                  resolution = (1600, 900),
                                  kw...) where T <: AbstractPoint where N
    len = length(pos)
    x = zeros(len)
    y = zeros(len)

    for i in 1:len
        x[i] = ustrip(u, getproperty(pos[i], xaxis))
        y[i] = ustrip(u, getproperty(pos[i], yaxis))
    end

    xcenter = middle(x)
    ycenter = middle(y)

    scene, layout = layoutscene(; resolution)

    ax = layout[1,1] = Axis(
        scene,
        title = title,
        xlabel = xlabel,
        ylabel = ylabel,
        aspect = AxisAspect(aspect_ratio),
    )

    Makie.scatter!(ax, x, y)

    xlims!(ax, xcenter - 0.5 * xlen, xcenter + 0.5 * xlen)
    ylims!(ax, ycenter - 0.5 * ylen, ycenter + 0.5 * ylen)

    return scene, layout
end

function plot_positionslice_adapt(data, u = nothing;
                                  xaxis = :x,
                                  yaxis = :y,
                                  xlabel = "",
                                  ylabel = "",
                                  xlen = 1.0u"kpc",
                                  ylen = 1.0u"kpc",
                                  aspect_ratio = 1.0,
                                  title = "Positions",
                                  resolution = (1600, 900),
                                  kw...)
    x = [ustrip(u, getproperty(p.Pos, xaxis)) for p in Iterators.flatten(values(data))]
    y = [ustrip(u, getproperty(p.Pos, yaxis)) for p in Iterators.flatten(values(data))]

    xcenter = middle(x)
    ycenter = middle(y)

    scene, layout = layoutscene(; resolution)

    ax = layout[1,1] = Axis(
        scene,
        title = title,
        xlabel = xlabel,
        ylabel = ylabel,
        aspect = AxisAspect(aspect_ratio),
    )

    Makie.scatter!(ax, x, y)

    xlims!(ax, xcenter - 0.5 * xlen, xcenter + 0.5 * xlen)
    ylims!(ax, ycenter - 0.5 * ylen, ycenter + 0.5 * ylen)

    return scene, layout
end

"""
    plot_positionslice_adapt(folder::String, filenamebase::String, Counts::Array{Int64,1}, ::jld2, u = u"kpc"; kw...)

Plot position slice with an adaptive center but fixed box length
"""
function plot_positionslice_adapt(folder::String, filenamebase::String, Counts::Array{Int64,1}, ::jld2, u = u"kpc";
                                  times = Counts,
                                  xaxis = :x,
                                  yaxis = :y,
                                  xlabel = "$xaxis [$u]",
                                  ylabel = "$yaxis [$u]",
                                  xlen = 0.2u"kpc",
                                  ylen = 0.2u"kpc",
                                  formatstring = "%04d",
                                  kw...)
    progress = Progress(length(Counts), "Loading data and plotting: ")
    for i in eachindex(Counts)
        snapshot_index = @eval @sprintf($formatstring, $(Counts[i]))
        filename = joinpath(folder, string(filenamebase, snapshot_index, ".jld2"))
        data = read_jld(filename)
        scene, layout = plot_positionslice_adapt(data, u; title = "Positions at " * @sprintf("%.6f ", ustrip(times[i])) * string(unit(times[i])),
                                                 xaxis = xaxis,
                                                 yaxis = yaxis,
                                                 xlabel = xlabel,
                                                 ylabel = ylabel,
                                                 xlen = xlen,
                                                 ylen = ylen,
                                                 kw...)

        outputfilename = joinpath(folder, string("pos_", snapshot_index, ".png"))
        png(outputfilename, scene)
        next!(progress, showvalues = [("iter", i), ("file", filename)])
    end
    return true
end