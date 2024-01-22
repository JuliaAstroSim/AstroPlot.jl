"""
$(TYPEDSIGNATURES)

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
$(TYPEDSIGNATURES)
Plot 2D projection sum over one dimension.

## Keywords
$_common_keyword_axis_label_title
$_common_keyword_unicode_colormap
"""
function unicode_projection(ρ, units = nothing;
        xaxis = :x, yaxis = :y,
        xlabel = "$(xaxis)$(axisunit(getuLength(units)))", ylabel = "$(yaxis)$(axisunit(getuLength(units)))",
        zlabel = "ρ$(axisunit(getuDensity(units)))",
        title = "Projection",
        colormap = :inferno,
        kw...
    )
    xid = axisid(xaxis)
    yid = axisid(yaxis)
    d = 6 - xid - yid

    s = collect(size(ρ))
    popat!(s, d)

    rho = ustrip.(getuDensity(units), reshape(sum(ρ, dims = d), s...))

    if xid > yid
        UnicodePlots.heatmap(transpose(rho); xlabel, ylabel, zlabel, title, colormap, kw...)
    else
        UnicodePlots.heatmap(rho; xlabel, ylabel, zlabel, title, colormap, kw...)
    end
end

"""
$(TYPEDSIGNATURES)
Plot 2D projection sum of mesh density over one dimension.

## Keywords
$_common_keyword_axis_label_title
$_common_keyword_unicode_colormap
"""
function unicode_projection_density(mesh::MeshCartesianStatic, units = nothing;
        xaxis = :x, yaxis = :y,
        kw...
    )
    config = mesh.config
    xid = axisid(xaxis)
    yid = axisid(yaxis)
    xMin = ustrip(getuLength(units), config.Min[xid])
    xMax = ustrip(getuLength(units), config.Max[xid])
    yMin = ustrip(getuLength(units), config.Min[yid])
    yMax = ustrip(getuLength(units), config.Max[yid])
    s = size(mesh.rho)
    xfact = (xMax - xMin) / s[xid]
    yfact = (yMax - yMin) / s[yid]

    unicode_projection(mesh.rho, units; xfact, yfact, xoffset = xMin, yoffset = yMin)
end

"""
$(TYPEDSIGNATURES)
Plot 2D projection sum of mesh density over one dimension.

## Keywords
$_common_keyword_aspect
$_common_keyword_figure
"""
function projection_density(m::MeshCartesianStatic, units = nothing;
        size = (900, 900),
        xaxis = :x, yaxis = :y,
        xlabel = "$(xaxis)$(axisunit(getuLength(units)))", ylabel = "$(yaxis)$(axisunit(getuLength(units)))",
        title = "Density projection",
        aspect_ratio = 1.0,
        kw...
    )
    xid = axisid(xaxis)
    yid = axisid(yaxis)
    d = 6 - xid - yid
    
    s = collect(size(m.rho))
    popat!(s, d)
    
    rho = ustrip.(getuDensity(units), reshape(sum(m.rho, dims = d), s...))
    pos = slice3d(m.pos, d, 1)
    
    xu, yu = pack_xy(pos; xaxis, yaxis)
    x = ustrip.(getuLength(units), xu)
    y = ustrip.(getuLength(units), yu)
    
    f = Figure(; size)
    ax = GLMakie.Axis(f[1,1]; xlabel, ylabel, title, aspect = AxisAspect(aspect_ratio))

    if xid > yid
        GLMakie.heatmap!(ax, x, y, transpose(rho); kw...)
    else
        GLMakie.heatmap!(ax, x, y, rho; kw...)
    end
    return f
end