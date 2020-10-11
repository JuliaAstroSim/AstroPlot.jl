function plot(tree::PhysicalTrees.Octree{T,S}; kw...) where T where S
    uLength = getuLength(tree.units)
    nodes = gather(tree, :treenodes)
    data = gather(tree, :data)

    scene = plot(nodes; kw...)
    plot!(scene, data)
    return scene
end
