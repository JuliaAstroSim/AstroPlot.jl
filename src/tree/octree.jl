function rectangle_from_coords(xb,yb,xt,yt)
    return [xb,xt,xt,xb,xb,NaN],
           [yb,yb,yt,yt,yb,NaN]
end

function rectangle_from_coords(xb,yb,zb,xt,yt,zt)
    return [xb, xb, xt, xt, xt, NaN, xt, xt, xb, xb, xb, NaN, xt, xt, xb, NaN, xb, xb, xt, NaN],
           [yb, yb, yb, yb, yt, NaN, yt, yt, yt, yt, yb, NaN, yb, yt, yt, NaN, yt, yb, yb, NaN],
           [zb, zt, zt, zb, zb, NaN, zt, zb, zb, zt, zt, NaN, zt, zt, zt, NaN, zb, zb, zb, NaN]
end

#=
x,y,z = rectangle_from_coords(-1.0, -1.0, -1.0, 1.0, 1.0, 1.0)
plot(scatter3d(x=x, y=y, z=z))
=#