function plot_makie(tree::PhysicalTrees.Octree{T,S};
        interactive = true,
        colors = ColorSchemes.tab10.colors,
    kw...) where T where S
    uLength = getuLength(tree.units)

    # The gathered data is Array of Array
    nodes = gather(tree, :treenodes)
    data = gather(tree, :data)

    if isnothing(colors)
        colors = [RGB(rand(3)...) for i in 1:length(nodes)]
    else
        append!(colors, [RGB(rand(3)...) for i in 1:length(nodes)-length(colors)])
    end

    figure, axis, plot = plot_makie(nodes[1], uLength; interactive, color = colors[1], kw...)
    plot_makie!(axis, data[1], uLength; color = colors[1], kw...)

    for i in 2:length(nodes)
        plot_makie!(axis, nodes[i], uLength; color = colors[i], kw...)
    end
    for i in 2:length(data)
        plot_makie!(axis, data[i], uLength; color = colors[i], kw...)
    end

    return figure, axis, plot
end
