function plotly_tree(tree::Octree; kw...)
    uLength = getuLength(tree.units)
    pnodes = plotly_treenode(tree.treenodes[1:tree.NTreenodes]; kw...)
    pdata = plotly_scatter(tree.data; kw...)
    return [pnodes, pdata]
end