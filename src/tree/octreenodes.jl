"""
    Rect(node::PhysicalTrees.OctreeNode, u = u"kpc")

Convert an `PhysicalTrees.OctreeNode` to `Rect3D`
"""
function Rect(node::PhysicalTrees.OctreeNode, u = u"kpc")
    p = one(node.Center) * 0.5 * node.SideLength
    return Makie.Rect3D(
        point3(ustrip(u, node.Center - p)),
        point3(ustrip(u, p * 2.0))
    )
end

"""
    plot!(scene::Scene, nodes::Array{T,N}; kw...) where T<:PhysicalTrees.OctreeNode where N

Plot tree nodes in `wireframe` mode
"""
function plot!(scene::Scene, nodes::Array{T,N}; kw...) where T<:PhysicalTrees.OctreeNode where N
    for n in nodes
        wireframe!(scene, Rect(n))
    end
end

"""
    plot(nodes::Array{T,N}; kw...) where T<:PhysicalTrees.OctreeNode where N

Plot tree nodes in `wireframe` mode
"""
function plot(nodes::Array{T,N}; kw...) where T<:PhysicalTrees.OctreeNode where N
    scene = wireframe(Rect(first(nodes)))
    for n in nodes[2:end]
        wireframe!(scene, Rect(n))
    end
    return scene
end