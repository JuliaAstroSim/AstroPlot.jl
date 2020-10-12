function plot_makie(tree::PhysicalTrees.Octree{T,S}; kw...) where T where S
    uLength = getuLength(tree.units)

    # The gathered data is Array of Array
    nodes = gather(tree, :treenodes)
    data = gather(tree, :data)

    scene = plot_makie(nodes[1], uLength; kw...)
    
    for n in nodes[2:end]
        plot_makie!(scene, n, uLength)
    end
    for d in data
        plot_makie!(scene, d, uLength)
    end
    return scene
end
