function plotly_tree(tree::PhysicalTrees.Octree{T,S}; kw...) where T where S
    uLength = getuLength(tree.units)
    nodes = gather(tree, :treenodes)
    data = gather(tree, :data)
    pnodes = plotly_treenode.(nodes; kw...)
    pdata = plotly_scatter.(data; kw...)
    return [pnodes; pdata]
end