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

    s = collect(size(data))
    popat!(s, d)

    z = slice3d(data, d, n)

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
    xid = axisid(xaxis)
    yid = axisid(yaxis)
    d = 6 - xid - yid
    
    s = collect(size(ρ))
    popat!(s, d)

    data = getfield(mesh, symbol)
    if data isa StructArray
        error("Vector plot is not supported!")
    end
end

function plot_slice(mesh::MeshCartesianStatic, symbol::Symbol, n::Int;
        xaxis = :x,
        yaxis = :y,
    )
    xid = axisid(xaxis)
    yid = axisid(yaxis)
    d = 6 - xid - yid

    pos_xy = slice3d(mesh.pos, d, n)
    x, y = pack_xy(pos_xy)

    data = getfield(mesh, symbol)

end