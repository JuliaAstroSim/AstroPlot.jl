function point3(p::PVector)
    return Makie.Point3(p.x, p.y, p.z)
end

function plot(data::Array{T,1}, u::Units = u"kpc"; kw...) where T<:AbstractParticle3D
    d = [point3(ustrip(u, p)) for p in data]
    return Makie.scatter(d)
end

function plot(data::Dict{T,A}, u::Units = u"kpc"; kw...) where A<:Array where T
    return plot(collect(Iterators.flatten(values(data))), u; kw...)
end

function unicode_scatter(data::Array{PVector{T}, 1};
                         xaxis = :x, yaxis = :y,
                         xlabel = "$xaxis", ylabel = "$yaxis",
                         kw...) where T<:Number
    len = length(data)
    x = zeros(len)
    y = zeros(len)

    for i in 1:len
        x[i] = getproperty(data[i], xaxis)
        y[i] = getproperty(data[i], yaxis)
    end

    return UnicodePlots.scatterplot(x, y, xlabel = xlabel, ylabel = ylabel; kw...)
end

function unicode_scatter(data::Array{PVector{T}, 1}, u = u"kpc";
                         xaxis = :x, yaxis = :y,
                         xlabel = "$xaxis [$u]", ylabel = "$yaxis [$u]",
                         kw...) where T<:Quantity
    d = ustrip.(u, data)

    return unicode_scatter(d, xaxis = xaxis, yaxis = yaxis, xlabel = xlabel, ylabel = ylabel; kw...)
end

function unicode_scatter(data::Array{T, 1}, u = u"kpc";
                         xaxis = :x, yaxis = :y,
                         xlabel = "$xaxis [$u]", ylabel = "$yaxis [$u]",
                         kw...) where T<:AbstractParticle
    d = [ustrip(u, p.Pos) for p in data]

    return unicode_scatter(d, xaxis = xaxis, yaxis = yaxis, xlabel = xlabel, ylabel = ylabel; kw...)
end