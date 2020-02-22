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

function plot_positionslice(data::Array{T, N}, u = nothing;
                            xaxis = :x,
                            yaxis = :y,
                            xlabel = "",
                            ylabel = "",
                            aspect_ratio = 1.0,
                            title = "Positions",
                            label = nothing,
                            markersize = 1.0,
                            kw...) where T <: AbstractParticle where N
    len = length(data)
    x = zeros(len)
    y = zeros(len)

    for i in 1:len
        x[i] = ustrip(u, getproperty(data[i].Pos, xaxis))
        y[i] = ustrip(u, getproperty(data[i].Pos, yaxis))
    end

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
        filename = joinpath(folder, string(filenamebase, @sprintf("%05d", Counts[i]), ".jld2"))
        data = read_jld(filename)
        p = plot_positionslice(data, u; title = "Positions at $(times[i])",
                                        xaxis = xaxis,
                                        yaxis = yaxis,
                                        xlabel = xlabel,
                                        ylabel = ylabel,
                                        label = label,
                                        markersize = markersize,
                                        kw...)

        outputfilename = joinpath(folder, string("pos_", @sprintf("%05d", Counts[i]), ".png"))
        png(p, outputfilename)
        next!(progress)
    end
end