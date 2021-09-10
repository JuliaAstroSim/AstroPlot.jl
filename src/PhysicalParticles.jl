function point3(p::PVector)
    return Makie.Point3(p.x, p.y, p.z)
end

"""
    plot_makie(data::Array{T,1}, u = u"kpc"; kw...) where T<:PVector
    plot_makie(data::Array{T,1}, u = u"kpc"; kw...) where T<:AbstractParticle3D
    plot_makie(data::StructArray, u = u"kpc"; kw...)

Plot `scatter` data points (in interactive mode)

## Examples

d = randn_pvector(50)
plot_makie(d, nothing)

d = randn_pvector(50, u"km")
plot_makie(d, u"m")
"""
function plot_makie(data::Array{T,1}, u = u"kpc"; kw...) where T<:PVector
    d = [point3(ustrip(u, p)) for p in data]
    return Makie.scatter(d; kw...)
end

function plot_makie(data::Array{T,1}, u = u"kpc"; kw...) where T<:AbstractParticle3D
    d = [point3(ustrip(u, p.Pos)) for p in data]
    return Makie.scatter(d; kw...)
end

function plot_makie(data::StructArray, u = u"kpc"; kw...)
    return plot_makie(data.Pos, u; kw...)
end

"""
    plot_makie!(scene::Scene, data::Array{T,1}, u = u"kpc"; kw...) where T<:PVector
    plot_makie!(scene::Scene, data::Array{T,1}, u = u"kpc"; kw...) where T<:AbstractParticle3D
    plot_makie!(scene::Scene, data::StructArray, u = u"kpc"; kw...)

Plot `scatter` data points (in interactive mode)

## Examples

d = randn_pvector(50)
plot_makie!(scene, d, nothing)

d = randn_pvector(50, u"km")
plot_makie!(scene, d, u"m")
"""
function plot_makie!(scene::Scene, data::Array{T,1}, u = u"kpc"; kw...) where T<:PVector
    d = [point3(ustrip(u, p)) for p in data]
    Makie.scatter!(scene, d; kw...)
end

function plot_makie!(scene::Scene, data::Array{T,1}, u = u"kpc"; kw...) where T<:AbstractParticle3D
    d = [point3(ustrip(u, p.Pos)) for p in data]
    Makie.scatter!(scene, d; kw...)
end

function plot_makie!(scene::Scene, data::StructArray, u = u"kpc"; kw...)
    plot_makie!(scene, data.Pos, u; kw...)
end

"""
    function unicode_scatter(data::Array{PVector{T}, 1}; kw...) where T<:Number
    function unicode_scatter(data::Array{PVector{T}, 1}, u = u"kpc"; kw...) where T<:Quantity
    function unicode_scatter(data, u = u"kpc"; kw...)

Scatter plot of points or particles in REPL

# Keywords
$_common_keyword_axis_label

# Examples
julia> unicode_scatter(randn_pvector(100))
"""
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

function unicode_scatter(data, u = u"kpc";
                         xaxis = :x, yaxis = :y,
                         xlabel = "$xaxis [$u]", ylabel = "$yaxis [$u]",
                         kw...)
    d = [ustrip(u, p.Pos) for p in data]

    return unicode_scatter(d, xaxis = xaxis, yaxis = yaxis, xlabel = xlabel, ylabel = ylabel; kw...)
end

"""
    function pack_xy(data, u = nothing; kw...)

Return Tuple (x,y) substracted from points or positions of particles in data.
Useful to prepare a plot.

# Keywords
$_common_keyword_axis
"""
function pack_xy(data::Array{T,N}, u = nothing;
                 xaxis = :x,
                 yaxis = :y) where T <: AbstractPoint where N
    len = length(data)
    x = zeros(len)
    y = zeros(len)

    for i in 1:len
        x[i] = ustrip(u, getproperty(data[i], xaxis))
        y[i] = ustrip(u, getproperty(data[i], yaxis))
    end
    return x, y
end

function pack_xy(data::Array{T,N}, u = nothing;
                 xaxis = :x,
                 yaxis = :y) where T <: AbstractParticle where N
    len = length(data)
    x = zeros(len)
    y = zeros(len)

    for i in 1:len
        x[i] = ustrip(u, getproperty(data.Pos[i], xaxis))
        y[i] = ustrip(u, getproperty(data.Pos[i], yaxis))
    end
    return x, y
end

function pack_xy(data::StructArray{T,N,NT,Tu}, u = nothing;
    xaxis = :x,
    yaxis = :y) where T<:AbstractPoint where N where NT where Tu
    return ustrip.(u, getproperty(data, xaxis)), ustrip.(u, getproperty(data, yaxis))
end

function pack_xy(data::StructArray{T,N,NT,Tu}, u = nothing;
    xaxis = :x,
    yaxis = :y) where T<:AbstractParticle where N where NT where Tu
    pack_xy(data.Pos, u; xaxis, yaxis)
end