function plotly_treenode(node::PhysicalTrees.OctreeNode; kw...)
    p = one(node.Center) * 0.5 * node.SideLength
    return plotly_mesh(Cube(node.Center + p, node.Center - p), unit(node.SideLength); kw...)
end

function plot_coords_order(node::PhysicalTrees.OctreeNode)
    p = one(node.Center) * 0.5 * node.SideLength
    u = unit(node.SideLength)
    return plot_coords_order(ustrip(u, node.Center - p), ustrip(u, node.Center + p))
end

function plotly_treenode(nodes::Array; kw...)
    x = Array{Float64,1}()
    y = Array{Float64,1}()
    z = Array{Float64,1}()
    for n in nodes
        dx, dy, dz = plot_coords_order(n)
        append!(x, dx)
        append!(y, dy)
        append!(z, dz)
    end

    return Plotly.scatter3d(
        x=x, y=y, z=z;
        kw...
    )
end