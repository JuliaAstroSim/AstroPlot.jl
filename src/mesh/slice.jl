function slice3d(a::AbstractArray{T,3}, d::Int, n::Int) where T
    if d == 1
        return view(a, n, :, :)
    elseif d == 2
        return view(a, :, n, :)
    elseif d == 3
        return view(a, :, :, n)
    end
end

"""
$(TYPEDSIGNATURES)
Plot 2D slice of a 3D array. Vector plot is not supported in unicode mode.

## Keywords
$_common_keyword_axis_label
$_common_keyword_unicode_colormap
"""
function unicode_slice(data::AbstractArray{T,3}, n::Int, units = nothing;
        xaxis = :x,
        yaxis = :y,
        xlabel = "$(xaxis)$(axisunit(getuLength(units)))", ylabel = "$(yaxis)$(axisunit(getuLength(units)))",
        colormap = :inferno,
        kw...
    ) where T
    xid = axisid(xaxis)
    yid = axisid(yaxis)
    d = 6 - xid - yid

    z = ustrip.(slice3d(data, d, n))

    if data isa StructArray
        error("Vector plot is not supported!")
    end

    if xid > yid
        UnicodePlots.heatmap(transpose(z); xlabel, ylabel, colormap, kw...)
    else
        UnicodePlots.heatmap(z; xlabel, ylabel, colormap, kw...)
    end
end

"""
$(TYPEDSIGNATURES)
Plot 2D slice of 3D data `symbol` in `m`.

## Keywords
$_common_keyword_axis_label
$_common_keyword_unicode_colormap
"""
function unicode_slice(m::MeshCartesianStatic, symbol::Symbol, n::Int, units = nothing;
        xaxis = :x,
        yaxis = :y,
        kw...
    )
    config = m.config
    xid = axisid(xaxis)
    yid = axisid(yaxis)
    xMin = ustrip.(getuLength(units), config.Min[xid])
    xMax = ustrip.(getuLength(units), config.Max[xid])
    yMin = ustrip.(getuLength(units), config.Min[yid])
    yMax = ustrip.(getuLength(units), config.Max[yid])
    s = size(m.rho)
    xfact = (xMax - xMin) / s[xid]
    yfact = (yMax - yMin) / s[yid]

    unicode_slice(getfield(m, symbol), n, units; xfact, yfact, xoffset = xMin, yoffset = yMin)    
end

"""
$(TYPEDSIGNATURES)
Return 1D axis points of 3D Cartesian positions.
"""
function axis_cartesian(pos::StructArray, axis::Symbol)
    if axis == :x
        return pos.x[:,1,1]
    elseif axis == :y
        return pos.y[1,:,1]
    elseif axis == :z
        return pos.z[1,1,:]
    else
        error("Only [:x, :y, :z] supported!")
    end 
end
axis_cartesian(m::MeshCartesianStatic, axis::Symbol) = axis_cartesian(m.pos, axis)

"""
$(TYPEDSIGNATURES)
Plot 2D slice of 3D data.

## Keywords
$_common_keyword_axis_label
"""
function plot_slice!(f::Figure, ax::Makie.Axis, pos::AbstractArray{T,3}, data::AbstractArray{S,3}, n::Int, units = nothing;
        xaxis = :x,
        yaxis = :y,
        kw...
    ) where T where S
    xid = axisid(xaxis)
    yid = axisid(yaxis)
    d = 6 - xid - yid

    x = ustrip.(getuLength(units), axis_cartesian(pos, xaxis))
    y = ustrip.(getuLength(units), axis_cartesian(pos, yaxis))
    z = slice3d(data, d, n)
    
    if data isa StructArray # arrows plot
        ux, uy = ustrip.(pack_xy(z; xaxis, yaxis))
        if xid > yid
            Makie.arrows2d!(ax, x, y, uy, ux; kw...)
        else
            Makie.arrows2d!(ax, x, y, ux, uy; kw...)
        end
    else
        if xid > yid
            ht = Makie.heatmap!(ax, x, y, ustrip.(Array(transpose(z))); kw...)
            Makie.Colorbar(f[1,2], ht)
        else
            ht = Makie.heatmap!(ax, x, y, ustrip.(Array(z)); kw...)
            Makie.Colorbar(f[1,2], ht)
        end
    end
end

"""
$(TYPEDSIGNATURES)
Plot 2D slice of 3D data `symbol` in `m`.

## Keywords
$_common_keyword_figure
$_common_keyword_aspect
"""
function plot_slice(m::MeshCartesianStatic, symbol::Symbol, n::Int, units = nothing;
        size = (1080, 900),
        xaxis = :x, yaxis = :y,
        xlabel = "$(xaxis)$(axisunit(getuLength(units)))", ylabel = "$(yaxis)$(axisunit(getuLength(units)))",
        title = string(symbol) * " slice",
        aspect = AxisAspect(1),
        kw...
    )
    f = Figure(;size)
    ax = Makie.Axis(f[1,1]; xlabel, ylabel, title, aspect)
    plot_slice!(f, ax, m.pos, getfield(m, symbol), n, units; xaxis, yaxis, kw...)
    return f
end

"""
$(TYPEDSIGNATURES)
"""
function plot_mesh_heatmap(d, units = nothing;
    size = (1080,900),
    title = "Heatmap",
    aspect = AxisAspect(1),
    kw...
)
    f = Figure(; size)
    a = Makie.Axis(f[1, 1]; title, aspect)
    ht = Makie.heatmap!(a, ustrip.(d); kw...)
    Makie.Colorbar(f[1, 2], ht)
    return f
end

"""
$(TYPEDSIGNATURES)
"""
function plot_mesh_heatmap(m::MeshCartesianStatic, symbol::Symbol, units = nothing;
    size = (1080,900),
    title = "Heatmap",
    aspect = AxisAspect(1),
    kw...
)
    x = ustrip.(getuLength(units), axis_cartesian(m.pos, :x))
    y = ustrip.(getuLength(units), axis_cartesian(m.pos, :y))

    f = Figure(; size)
    a = Makie.Axis(f[1,1]; title, aspect)
    ht = Makie.heatmap!(a, x, y, ustrip.(getfield(m, symbol)); kw...)
    Makie.Colorbar(f[1,2], ht)
    return f
end