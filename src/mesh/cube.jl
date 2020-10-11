function Rect(c::Cube{T}, u::Units = u"kpc") where T<:Quantity
    return Makie.Rect3D(
        point3(ustrip(u, c.below)),
        point3(ustrip(u, c.top - c.below))
    )
end

function plot!(scene::Scene, c::Cube{T}, u::Units = u"kpc"; kw...) where T<:Quantity
    wireframe!(scene, Rect(c, u); kw...)
end

function plot(c::Cube{T}, u::Units = u"kpc"; kw...) where T<:Quantity
    wireframe(Rect(c, u); kw...)
end