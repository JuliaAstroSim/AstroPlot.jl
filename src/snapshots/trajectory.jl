function plot_trajectory!(ax, pos::Array{T,1};
                          xaxis = :x,
                          yaxis = :y,
                          xlims = nothing,
                          ylims = nothing,
                          color = nothing
                          ) where T<:PVector
    len = length(pos)
    x = zeros(len)
    y = zeros(len)

    for i in 1:len
        x[i] = getproperty(pos[i], xaxis)
        y[i] = getproperty(pos[i], yaxis)
    end
    
    if isnothing(color)
        s = Makie.lines!(ax, x, y, color = RGB(rand(3)...))
    else
        s = Makie.lines!(ax, x, y, color = color)
    end

    if !isnothing(xlims)
        Makie.xlims!(ax, xlims)
    end
    
    if !isnothing(ylims)
        Makie.ylims!(ax, ylims)
    end

    return s
end

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
                         kw...)
    scene, layout = layoutscene()
    
    ax = layout[1,1] = LAxis(
        scene,
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
        aspect = AxisAspect(aspect_ratio),
    )

    if isnothing(colors)
        scenes = [plot_trajectory!(ax, ustrip.(u, pos[key]); xaxis, yaxis, color = RGB(rand(3)...)) for key in keys(pos)]
    else
        scenes = [plot_trajectory!(ax, ustrip.(u, pos[collect(keys(pos))[i]]); xaxis, yaxis, color = colors[i]) for i in 1:length(keys(pos))]
    end

    leg = layout[1,1] = LLegend(
        scene, scenes,
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

    return scene, layout
end

function plot_trajectory(folder::String, filenamebase::String, Counts::Array{Int64,1},
                         ids::Array{Int64,1}, suffix::String, FileType::AbstractOutputType, u = u"kpc";
                         xaxis = :x,
                         yaxis = :y,
                         xlims = nothing,
                         ylims = nothing,
                         xlabel = "$xaxis [$u]",
                         ylabel = "$yaxis [$u]",
                         aspect_ratio = 1.0,
                         title = "Trajectory",
                         colors = nothing,
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
            data = read_gadget2_pos(filename)
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
                           xlims = xlims,
                           ylims = ylims,
                           xlabel = xlabel,
                           ylabel = ylabel,
                           aspect_ratio = aspect_ratio,
                           title = title,
                           colors = colors,
                           kw...)
end

function plot_trajectory!(scene, layout, ax, index, pos::Dict{Int64, Array{AbstractPoint,1}}, u = u"kpc";
                         xaxis = :x,
                         yaxis = :y,
                         xlims = nothing,
                         ylims = nothing,
                         xlabel = "$xaxis [$u]",
                         ylabel = "$yaxis [$u]",
                         aspect_ratio = 1.0,
                         title = "Trajectory",
                         colors = nothing,
                         kw...)
    if isnothing(colors)
        scenes = [plot_trajectory!(ax, ustrip.(u, pos[key]); xaxis, yaxis, color = RGB(rand(3)...)) for key in keys(pos)]
    else
        scenes = [plot_trajectory!(ax, ustrip.(u, pos[collect(keys(pos))[i]]); xaxis, yaxis, color = colors[i]) for i in 1:length(keys(pos))]
    end
    
    if !isnothing(xlims)
        Makie.xlims!(ax, xlims)
    end
    
    if !isnothing(ylims)
        Makie.ylims!(ax, ylims)
    end

    return scenes, string.(keys(pos))
end

function plot_trajectory!(scene, layout, ax, index, folder::String, filenamebase::String, Counts::Array{Int64,1},
                         ids::Array{Int64,1}, suffix::String, FileType::AbstractOutputType, u = u"kpc";
                         xaxis = :x,
                         yaxis = :y,
                         xlims = nothing,
                         ylims = nothing,
                         xlabel = "$xaxis [$u]",
                         ylabel = "$yaxis [$u]",
                         aspect_ratio = 1.0,
                         title = "Trajectory",
                         colors = nothing,
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
            data = read_gadget2_pos(filename)
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

    return plot_trajectory!(scene, layout, ax, index, pos, u;
                           xaxis = xaxis,
                           yaxis = yaxis,
                           xlims = xlims,
                           ylims = ylims,
                           xlabel = xlabel,
                           ylabel = ylabel,
                           aspect_ratio = aspect_ratio,
                           title = title,
                           colors = colors,
                           kw...)
end