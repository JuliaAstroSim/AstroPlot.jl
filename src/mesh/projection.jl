function axisid(axis::Symbol)
    if axis == :x
        return 1
    elseif axis == :y
        return 2
    elseif axis == :z
        return 3
    else
        error("Only `:x`, `:y`, `:z` is supported!")
    end
end

function unicode_projection(ρ;
        xaxis = :x, yaxis = :y,
        xlabel = "$(xaxis)", ylabel = "$(yaxis)",
        zlabel = "ρ",
        colormap = :inferno,
        kw...
    )
    xid = axisid(xaxis)
    yid = axisid(yaxis)
    d = 6 - xid - yid

    s = collect(size(ρ))
    popat!(s, d)

    rho = reshape(sum(ρ, dims = d), s...)

    if xid > yid
        UnicodePlots.heatmap(transpose(rho); xlabel, ylabel, zlabel, colormap, kw...)
    else
        UnicodePlots.heatmap(rho; xlabel, ylabel, zlabel, colormap, kw...)
    end
end

function unicode_projection_density(mesh::MeshCartesianStatic;
        xaxis = :x, yaxis = :y,
        kw...
    )
    config = mesh.config
    xid = axisid(xaxis)
    yid = axisid(yaxis)
    xMin = config.Min[xid]
    xMax = config.Max[xid]
    yMin = config.Min[yid]
    yMax = config.Max[yid]
    s = size(mesh.rho)
    xfact = (xMax - xMin) / s[xid]
    yfact = (yMax - yMin) / s[yid]

    unicode_projection(mesh.rho; xfact, yfact, xoffset = xMin, yoffset = yMin)
end

function slice3d(a::AbstractArray, d::Int, n::Int)

end

function projection(mesh::MeshCartesianStatic;
    
    )

end

function projection_density(mesh::MeshCartesianStatic;
        resolution = (1600, 900),
        xaxis = :x, yaxis = :y,
        xlabel = "$(xaxis)", ylabel = "$(yaxis)",
        title = "Density projection",
    )
    scene, layout = layoutscene(; resolution)
    ax = layout[1,1] = GLMakie.Axis(scene; xlabel, ylabel, title)



    Makie.heatmap!(ax)

    return scene, layout
end