"""
    function axisid(axis::Symbol)

Convert axis to `Int`
- return `1` if `axis == :x`
- return `2` if `axis == :y`
- return `3` if `axis == :z`
"""
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

"""
    function unicode_projection(ρ; kw...)

Plot 2D projection sum over one dimension.

# Keywords
$_common_keyword_axis_label_title
$_common_keyword_unicode_colormap
"""
function unicode_projection(ρ;
        xaxis = :x, yaxis = :y,
        xlabel = "$(xaxis)", ylabel = "$(yaxis)",
        zlabel = "ρ",
        title = "Projection",
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
        UnicodePlots.heatmap(transpose(rho); xlabel, ylabel, zlabel, title, colormap, kw...)
    else
        UnicodePlots.heatmap(rho; xlabel, ylabel, zlabel, title, colormap, kw...)
    end
end

"""
    function unicode_projection_density(mesh::MeshCartesianStatic; kw...)

Plot 2D projection sum of mesh density over one dimension.

# Keywords
$_common_keyword_axis_label_title
$_common_keyword_unicode_colormap
"""
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

"""
    function projection_density(mesh::MeshCartesianStatic; kw...)

Plot 2D projection sum of mesh density over one dimension.

# Keywords
$_common_keyword_aspect
$_common_keyword_figure
"""
function projection_density(mesh::MeshCartesianStatic;
        resolution = (900, 900),
        xaxis = :x, yaxis = :y,
        xlabel = "$(xaxis)", ylabel = "$(yaxis)",
        title = "Density projection",
        aspect_ratio = 1.0,
        kw...
    )
    xid = axisid(xaxis)
    yid = axisid(yaxis)
    d = 6 - xid - yid
    
    s = collect(size(mesh.rho))
    popat!(s, d)
    
    rho = reshape(sum(mesh.rho, dims = d), s...)
    pos = slice3d(mesh.pos, d, 1)
    
    xy = pack_xy(pos; xaxis, yaxis)
    
    f = Figure(; resolution)
    ax = CairoMakie.Axis(f[1,1]; xlabel, ylabel, title, aspect = AxisAspect(aspect_ratio))

    if xid > yid
        CairoMakie.heatmap!(ax, xy[:,1], xy[:,2], transpose(rho); kw...)
    else
        CairoMakie.heatmap!(ax, xy[:,1], xy[:,2], rho; kw...)
    end
    return f
end