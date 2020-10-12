function plot_trajectory(p::Plots.Plot, pos::Array{AbstractPoint,1};
                         xaxis = :x,
                         yaxis = :y,
                         xlabel = "",
                         ylabel = "",
                         aspect_ratio = 1.0,
                         title = "Trajectory",
                         kw...)
    len = length(pos)
    x = zeros(len)
    y = zeros(len)

    for i in 1:len
        x[i] = getproperty(pos[i], xaxis)
        y[i] = getproperty(pos[i], yaxis)
    end

    Plots.plot!(p, x, y;
                xaxis = xaxis,
                yaxis = yaxis,
                xlabel = xlabel,
                ylabel = ylabel,
                aspect_ratio = aspect_ratio,
                title = title,
                kw...)
end

function plot_trajectory(pos::Dict{Int64, Array{AbstractPoint,1}}, u = u"kpc";
                         xaxis = :x,
                         yaxis = :y,
                         xlabel = "$xaxis [$u]",
                         ylabel = "$yaxis [$u]",
                         aspect_ratio = 1.0,
                         title = "Trajectory",
                         kw...)
    p = Plots.plot()
    for key in keys(pos)
        pos[key] = ustrip.(u, pos[key])
        plot_trajectory(p, pos[key],
                        xaxis = xaxis,
                        yaxis = yaxis,
                        xlabel = xlabel,
                        ylabel = ylabel,
                        aspect_ratio = aspect_ratio,
                        label = "particle $key"; kw...)
    end
    return p
end

function plot_trajectory(folder::String, filenamebase::String, Counts::Array{Int64,1},
                         ids::Array{Int64,1}, ::jld2, u = u"kpc";
                         xaxis = :x,
                         yaxis = :y,
                         xlabel = "$xaxis [$u]",
                         ylabel = "$yaxis [$u]",
                         aspect_ratio = 1.0,
                         title = "Trajectory",
                         kw...
                         )
    pos = Dict{Int64, Array{AbstractPoint,1}}()
    for id in ids
        pos[id] = Array{AbstractPoint,1}()
    end

    progress = Progress(length(Counts), "Loading data: ")
    for i in Counts
        filename = joinpath(folder, string(filenamebase, @sprintf("%04d", i), ".jld2"))
        data = read_jld(filename)
        for p in Iterators.flatten(values(data))
            if p.ID in ids
                push!(pos[p.ID], p.Pos)
            end
        end
        next!(progress, showvalues = [("iter", i), ("file", filename)])
    end

    return plot_trajectory(pos, u;
                           xaxis = xaxis,
                           yaxis = yaxis,
                           xlabel = xlabel,
                           ylabel = ylabel,
                           aspect_ratio = aspect_ratio,
                           title = title,
                           kw...)
end