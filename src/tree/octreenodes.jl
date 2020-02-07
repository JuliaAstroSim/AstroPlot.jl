function plotly_treenode(node::OctreeNode; kw...)
    p = one(node.Center) * 0.5 * node.SideLength
    return plotly_mesh(Cube(node.Center + p, node.Center - p), unit(node.SideLength); kw...)
end

plotly_treenode(nodes::Array; kw...) = plotly_treenode.(nodes; kw...)