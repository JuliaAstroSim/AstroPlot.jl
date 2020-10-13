function plot_trajectory!(scene, pos::Array{T,1};
                          xaxis = :x,
                          yaxis = :y,
                          ) where T<:PVector
    len = length(pos)
    x = zeros(len)
    y = zeros(len)

    for i in 1:len
        x[i] = getproperty(pos[i], xaxis)
        y[i] = getproperty(pos[i], yaxis)
    end
    
    Makie.lines!(scene, x, y, color = RGB(rand(3)...))
end

function plot_trajectory(pos::Dict{Int64, Array{AbstractPoint,1}}, u = u"kpc";
                         xaxis = :x,
                         yaxis = :y,
                         xlabel = "$xaxis [$u]",
                         ylabel = "$yaxis [$u]",
                         aspect_ratio = 1.0,
                         title = "Trajectory",
                         kw...)
    scene, layout = layoutscene()
    
    ax = layout[1,1] = LAxis(
        scene,
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
        aspect = AxisAspect(aspect_ratio),
    )

    scenes = [plot_trajectory!(ax, ustrip.(u, pos[key]); xaxis, yaxis) for key in keys(pos)]

    leg = layout[1,2] = LLegend(scene, scenes, string.(keys(pos)))

    return scene, layout
end

function plot_trajectory(folder::String, filenamebase::String, Counts::Array{Int64,1},
                         ids::Array{Int64,1}, suffix::String, FileType::AbstractOutputType, u = u"kpc";
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
        filename = joinpath(folder, string(filenamebase, @sprintf("%04d", i), suffix))
        
        if FileType == gadget2()
            header, data = read_gadget2(filename)
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

    return plot_trajectory(pos, u;
                           xaxis = xaxis,
                           yaxis = yaxis,
                           xlabel = xlabel,
                           ylabel = ylabel,
                           aspect_ratio = aspect_ratio,
                           title = title,
                           kw...)
end