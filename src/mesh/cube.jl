function Rect(c::Cube{T}, u = u"kpc") where T<:Number
    return Makie.Rect3(
        point3(ustrip(u, c.below)),
        point3(ustrip(u, c.top - c.below))
    )
end

function plot_makie!(ax, c::Cube{T}, u = u"kpc"; kw...) where T<:Number
    Makie.wireframe!(ax, Rect(c, u); kw...)
end

function plot_makie(c::Cube{T}, u = u"kpc"; kw...) where T<:Number
    Makie.wireframe(Rect(c, u); kw...)
end