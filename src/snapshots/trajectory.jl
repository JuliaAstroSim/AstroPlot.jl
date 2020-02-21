function plot_trajectory(p::Plots.Plot, pos::Array{AbstractPoint,1};
                         xaxis = :x,
                         yaxis = :y,
                         aspect_ratio=:equal,
                         kw...)
    len = length(pos)
    x = zeros(len)
    y = zeros(len)

    for i in 1:len
        x[i] = getproperty(pos[i], xaxis)
        y[i] = getproperty(pos[i], yaxis)
    end

    Plots.plot!(p, x, y; aspect_ratio = aspect_ratio, kw...)
end

function plot_trajectory(pos::Dict{Int64, Array{AbstractPoint,1}}, u::Units = u"kpc";
                         xaxis = :x,
                         yaxis = :y,
                         xlabel = "$xaxis [$u]",
                         ylabel = "$yaxis [$u]",
                         kw...)
    p = Plots.plot()
    for key in keys(pos)
        pos[key] = ustrip.(u, pos[key])
        plot_trajectory(p, pos[key], xaxis = xaxis, yaxis = yaxis, label = "particle $key"; kw...)
    end
    return p
end

function plot_trajectory(folder::String, filenamebase::String, Counts::Array{Int64,1},
                         ids::Array{Int64,1}, ::jld2, u::Units = u"kpc";
                         kw...
                         )
    pos = Dict{Int64, Array{AbstractPoint,1}}()
    for id in ids
        pos[id] = Array{AbstractPoint,1}()
    end

    progress = Progress(length(Counts), "Loading data: ")
    for i in Counts
        filename = joinpath(folder, string(filenamebase, @sprintf("%05d", i), ".jld2"))
        data = read_jld(filename)
        for p in data
            if p.ID in ids
                push!(pos[p.ID], p.Pos)
            end
        end
        next!(progress)
    end

    plot_trajectory(pos, u; kw...)
end