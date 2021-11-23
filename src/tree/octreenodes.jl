"""
    Rect(node::PhysicalTrees.OctreeNode, u = u"kpc")

Convert an `PhysicalTrees.OctreeNode` to `Rect3`
"""
function RectNode(node::PhysicalTrees.OctreeNode, u = u"kpc")
    p = one(node.Center) * 0.5 * node.SideLength
    return Rect3(
        point3(ustrip(u, node.Center - p)),
        point3(ustrip(u, p * 2.0))
    )
end

"""
    plot_makie!(axis, nodes::Array{T,N}; kw...) where T<:PhysicalTrees.OctreeNode where N

Plot tree nodes in `wireframe` mode
"""
function plot_makie!(axis, nodes::Array{T,N}, u = u"kpc"; kw...) where T<:PhysicalTrees.OctreeNode where N
    for n in nodes
        wireframe!(axis, RectNode(n, u); kw...)
    end
end

"""
    plot_makie(nodes::Array{T,N}; kw...) where T<:PhysicalTrees.OctreeNode where N

Plot tree nodes in `wireframe` mode
"""
function plot_makie(nodes::Array{T,N}, u = u"kpc";
    interactive = true,
    kw...
) where T<:PhysicalTrees.OctreeNode where N
    figure, axis, plot = wireframe(RectNode(first(nodes), u))
    for n in nodes[2:end]
        wireframe!(axis, RectNode(n, u); kw...)
    end

    if interactive
        display(figure)
    end

    return figure, axis, plot
end