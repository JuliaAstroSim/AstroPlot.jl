function plot_coords_order(xb,yb,xt,yt)
    return [xb,xt,xt,xb,xb,NaN],
           [yb,yb,yt,yt,yb,NaN]
end

function plot_coords_order(xb,yb,zb,xt,yt,zt)
    return [xb, xb, xt, xt, xt, NaN, xt, xt, xb, xb, xb, NaN, xt, xt, xb, NaN, xb, xb, xt, NaN],
           [yb, yb, yb, yb, yt, NaN, yt, yt, yt, yt, yb, NaN, yb, yt, yt, NaN, yt, yb, yb, NaN],
           [zb, zt, zt, zb, zb, NaN, zt, zb, zb, zt, zt, NaN, zt, zt, zt, NaN, zb, zb, zb, NaN]
end

plot_coords_order(p1::PVector2D{T}, p2::PVector2D) where T<:Real = plot_coords_order(p1.x, p1.y, p2.x, p2.y)
plot_coords_order(p1::PVector{T}, p2::PVector{T}) where T<:Real = plot_coords_order(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z)

plot_coords_order(c::Cube2D{T}) where T<:Real = plot_coords_order(c.below, c.top)
plot_coords_order(c::Cube{T}) where T<:Real = plot_coords_order(c.below, c.top)

function plotly_mesh(c::Cube{T}, u::Unitful.FreeUnits{(),NoDims,nothing} = Unitful.FreeUnits{(),NoDims,nothing}();
                     marker_size = 3,
                     kw...) where T<:Real
    x, y, z = plot_coords_order(c)
    return Plotly.scatter3d(
        x=x, y=y, z=z;
        marker_size = marker_size,
        kw...
    )
end

function plotly_mesh(c::Cube{T}, u::Units;
                     marker_size = 3,
                     kw...) where T<:Quantity
    d = Cube(ustrip(u, c.top), ustrip(u, c.below))
    x, y, z = plot_coords_order(d)
    return Plotly.scatter3d(
        x=x, y=y, z=z;
        marker_size = marker_size,
        kw...
    )
end


#=
x,y,z = plot_coords_order(-1.0, -1.0, -1.0, 1.0, 1.0, 1.0)
plot(scatter3d(x=x, y=y, z=z))
=#