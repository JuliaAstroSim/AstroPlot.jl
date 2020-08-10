function plot_positionslice(pos::Array{T, N}, u = nothing;
                            xaxis = :x,
                            yaxis = :y,
                            xlabel = "",
                            ylabel = "",
                            aspect_ratio = 1.0,
                            title = "Positions",
                            label = nothing,
                            markersize = 1.0,
                            kw...) where T <: AbstractPoint where N
    len = length(pos)
    x = zeros(len)
    y = zeros(len)

    for i in 1:len
        x[i] = ustrip(u, getproperty(pos[i], xaxis))
        y[i] = ustrip(u, getproperty(pos[i], yaxis))
    end

    return Plots.scatter(x, y, aspect_ratio = aspect_ratio,
                               title = title,
                               xlabel = xlabel,
                               ylabel = ylabel,
                               label = label,
                               markersize = markersize,
                               ; kw...)
end

function plot_positionslice(data, u = nothing;
                            xaxis = :x,
                            yaxis = :y,
                            xlabel = "",
                            ylabel = "",
                            aspect_ratio = 1.0,
                            title = "Positions",
                            label = nothing,
                            markersize = 1.0,
                            kw...)
    x = [ustrip(u, getproperty(p.Pos, xaxis)) for p in Iterators.flatten(values(data))]
    y = [ustrip(u, getproperty(p.Pos, yaxis)) for p in Iterators.flatten(values(data))]

    return Plots.scatter(x, y, aspect_ratio = aspect_ratio,
                               title = title,
                               xlabel = xlabel,
                               ylabel = ylabel,
                               label = label,
                               markersize = markersize,
                               ; kw...)
end

function plot_positionslice(folder::String, filenamebase::String, Counts::Array{Int64,1}, ::jld2, u::Units = u"kpc";
                            times = Counts,
                            xaxis = :x,
                            yaxis = :y,
                            xlabel = "$xaxis [$u]",
                            ylabel = "$yaxis [$u]",
                            label = nothing,
                            markersize = 1.0,
                            kw...)
    progress = Progress(length(Counts), "Loading data and plotting: ")
    for i in eachindex(Counts)
        filename = joinpath(folder, string(filenamebase, @sprintf("%04d", Counts[i]), ".jld2"))
        data = read_jld(filename)
        p = plot_positionslice(data, u; title = "Positions at $(times[i])",
                                        xaxis = xaxis,
                                        yaxis = yaxis,
                                        xlabel = xlabel,
                                        ylabel = ylabel,
                                        label = label,
                                        markersize = markersize,
                                        kw...)

        outputfilename = joinpath(folder, string("pos_", @sprintf("%04d", Counts[i]), ".png"))
        png(p, outputfilename)
        next!(progress, showvalues = [("iter", i), ("file", filename)])
    end
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
                                  label = nothing,
                                  markersize = 1.0,
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

    return Plots.scatter(x, y, aspect_ratio = aspect_ratio,
                               title = title,
                               xlabel = xlabel,
                               ylabel = ylabel,
                               xlim = (xcenter - 0.5 * xlen, xcenter + 0.5 * xlen),
                               ylim = (ycenter - 0.5 * ylen, ycenter + 0.5 * ylen),
                               label = label,
                               markersize = markersize,
                               ; kw...)
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
                                  label = nothing,
                                  markersize = 1.0,
                                  kw...)
    x = [ustrip(u, getproperty(p.Pos, xaxis)) for p in Iterators.flatten(values(data))]
    y = [ustrip(u, getproperty(p.Pos, yaxis)) for p in Iterators.flatten(values(data))]

    xcenter = middle(x)
    ycenter = middle(y)

    return Plots.scatter(x, y, aspect_ratio = aspect_ratio,
                               title = title,
                               xlabel = xlabel,
                               ylabel = ylabel,
                               xlim = (xcenter - 0.5 * xlen, xcenter + 0.5 * xlen),
                               ylim = (ycenter - 0.5 * ylen, ycenter + 0.5 * ylen),
                               label = label,
                               markersize = markersize,
                               ; kw...)
end

function plot_positionslice_adapt(folder::String, filenamebase::String, Counts::Array{Int64,1}, ::jld2, u::Units = u"kpc";
                                  times = Counts,
                                  xaxis = :x,
                                  yaxis = :y,
                                  xlabel = "$xaxis [$u]",
                                  ylabel = "$yaxis [$u]",
                                  xlen = 0.2u"kpc",
                                  ylen = 0.2u"kpc",
                                  label = nothing,
                                  markersize = 1.0,
                                  kw...)
    progress = Progress(length(Counts), "Loading data and plotting: ")
    for i in eachindex(Counts)
        filename = joinpath(folder, string(filenamebase, @sprintf("%04d", Counts[i]), ".jld2"))
        data = read_jld(filename)
        p = plot_positionslice_adapt(data, u; title = "Positions at $(times[i])",
                                                 xaxis = xaxis,
                                                 yaxis = yaxis,
                                                 xlabel = xlabel,
                                                 ylabel = ylabel,
                                                 xlen = xlen,
                                                 ylen = ylen,
                                                 label = label,
                                                 markersize = markersize,
                                                 kw...)

        outputfilename = joinpath(folder, string("pos_", @sprintf("%04d", Counts[i]), ".png"))
        png(p, outputfilename)
        next!(progress, showvalues = [("iter", i), ("file", filename)])
    end
end