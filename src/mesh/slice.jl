function slice3d(a::AbstractArray{T,3}, d::Int, n::Int) where T
    if d == 1
        return view(a, n, :, :)
    elseif d == 2
        return view(a, :, n, :)
    elseif d == 3
        return view(a, :, :, n)
    end
end

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