function plot_makie(tree::PhysicalTrees.Octree{T,S};
        interactive = true,
    kw...) where T where S
    uLength = getuLength(tree.units)

    # The gathered data is Array of Array
    nodes = gather(tree, :treenodes)
    data = gather(tree, :data)

    figure, axis, plot = plot_makie(nodes[1], uLength; interactive, kw...)
    
    for n in nodes[2:end]
        plot_makie!(axis, n, uLength)
    end
    for d in data
        plot_makie!(axis, d, uLength)
    end

    return figure, axis, plot
end
