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
function unicode_slice(data::AbstractArray{T,3}, n::Int;
        xaxis = :x,
        yaxis = :y,
        xlabel = "$(xaxis)", ylabel = "$(yaxis)",
        colormap = :inferno,
        kw...
    ) where T
    xid = axisid(xaxis)
    yid = axisid(yaxis)
    d = 6 - xid - yid

    z = slice3d(data, d, n)

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
Plot 2D slice of 3D data `symbol` in `mesh`.

## Keywords
$_common_keyword_axis_label
$_common_keyword_unicode_colormap
"""
function unicode_slice(mesh::MeshCartesianStatic, symbol::Symbol, n::Int;
        xaxis = :x,
        yaxis = :y,
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

    unicode_slice(getfield(mesh, symbol), n; xfact, yfact, xoffset = xMin, yoffset = yMin)    
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
axis_cartesian(mesh::MeshCartesianStatic, axis::Symbol) = axis_cartesian(mesh.pos, axis)

"""
$(TYPEDSIGNATURES)
Plot 2D slice of 3D data.

## Keywords
$_common_keyword_axis_label
"""
function plot_slice!(ax::CairoMakie.Axis, pos::AbstractArray{T,3}, data::AbstractArray{S,3}, n::Int;
        xaxis = :x,
        yaxis = :y,
        xlabel = "$(xaxis)", ylabel = "$(yaxis)",
        kw...
    ) where T where S
    xid = axisid(xaxis)
    yid = axisid(yaxis)
    d = 6 - xid - yid

    x = axis_cartesian(pos, xaxis)
    y = axis_cartesian(pos, yaxis)
    z = slice3d(data, d, n)
    
    if data isa StructArray # arrows plot
        ux, uy = pack_xy(z; xaxis, yaxis)
        if xid > yid
            CairoMakie.arrows!(ax, x, y, uy, ux; xlabel, ylabel, kw...)
        else
            CairoMakie.arrows!(ax, x, y, ux, uy; xlabel, ylabel, kw...)
        end
    else
        if xid > yid
            CairoMakie.heatmap!(ax, x, y, Array(transpose(z)); xlabel, ylabel, kw...)
        else
            CairoMakie.heatmap!(ax, x, y, Array(z); xlabel, ylabel, kw...)
        end
    end
end

"""
$(TYPEDSIGNATURES)
Plot 2D slice of 3D data `symbol` in `mesh`.

## Keywords
$_common_keyword_figure
$_common_keyword_aspect
"""
function plot_slice(mesh::MeshCartesianStatic, symbol::Symbol, n::Int;
        resolution = (900, 900),
        xaxis = :x, yaxis = :y,
        xlabel = "$(xaxis)", ylabel = "$(yaxis)",
        title = "Density slice",
        aspect = AxisAspect(1),
        kw...
    )
    f = Figure(;resolution)
    ax = CairoMakie.Axis(f[1,1]; xlabel, ylabel, title, aspect)
    plot_slice!(ax, mesh.pos, getfield(mesh, symbol), n; xaxis, yaxis, kw...)
    return f
end

"""
$(TYPEDSIGNATURES)
"""
function plot_mesh_heatmap(d;
    resolution = (1080,900),
    title = "Heatmap",
    aspect = AxisAspect(1),
    kw...
)
    f = Figure(; resolution)
    a = CairoMakie.Axis(f[1, 1]; title, aspect)
    ht = CairoMakie.heatmap!(a, d; kw...)
    CairoMakie.Colorbar(f[1, 2], ht)
    return f
end

"""
$(TYPEDSIGNATURES)
"""
function plot_mesh_heatmap(m::MeshCartesianStatic, symbol::Symbol;
    resolution = (1080,900),
    title = "Heatmap",
    aspect = AxisAspect(1),
    kw...
)
    x = axis_cartesian(m.pos, :x)
    y = axis_cartesian(m.pos, :y)

    f = Figure(; resolution)
    a = CairoMakie.Axis(f[1,1]; title, aspect)
    ht = CairoMakie.heatmap!(a, x, y, getfield(m, symbol); kw...)
    CairoMakie.Colorbar(f[1,2], ht)
    return f
end