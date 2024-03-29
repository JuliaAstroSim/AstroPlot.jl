function point3(p::PVector)
    return Makie.Point3(p.x, p.y, p.z)
end

function estimate_markersize(S::Real)
    return 0.1 / sqrt(S)
end

function estimate_markersize(data, u; xaxis = :x, yaxis = :y)
    e = extent(data)
    xMax = getfield(e, Symbol(string(xaxis) * "Max"))
    xMin = getfield(e, Symbol(string(xaxis) * "Min"))
    yMax = getfield(e, Symbol(string(yaxis) * "Max"))
    yMin = getfield(e, Symbol(string(yaxis) * "Min"))
    u2 = isnothing(u) ? nothing : u*u
    return estimate_markersize(ustrip(u2, (xMax - xMin) * (yMax - yMin)))
end

"""
$(TYPEDSIGNATURES)
Plot `scatter` data points (in interactive mode)

`collection`: filter the type of particles

## Examples

```julia
d = randn_pvector(50)
plot_makie(d, nothing)

d = randn_pvector(50, u"km")
plot_makie(d, u"m")
```
"""
function plot_makie(data::Array{T,1}, u::Union{Nothing, Unitful.FreeUnits} = u"kpc";
    markersize = estimate_markersize(data, u),
    markerspace=:data,
    size = (1000, 1000),
    kw...
) where T<:PVector
    d = [point3(ustrip(u, p)) for p in data]
    return Makie.scatter(d; markersize, markerspace, figure = (size = size,), kw...)
end

function plot_makie(data::Array{T,1}, u::Union{Nothing, Unitful.FreeUnits} = u"kpc";
    markersize = estimate_markersize(data, u),
    markerspace=:data,
    size = (1000, 1000),
    kw...
) where T<:AbstractParticle3D
    d = [point3(ustrip(u, p.Pos)) for p in data]
    return Makie.scatter(d; markersize, markerspace, figure = (size = size,), kw...)
end

function plot_makie(data::StructArray, u::Union{Nothing, Unitful.FreeUnits} = u"kpc"; kw...)
    return plot_makie(data.Pos, u; kw...)
end

function plot_makie(data::Union{Array{T,N}, StructArray{T,N,NT,Tu}}, collection::Collection, u::Union{Nothing, Unitful.FreeUnits} = u"kpc"; kw...) where T<:AbstractParticle3D where N where NT where Tu
    d = filter(p->p.Collection == collection, data)
    if isempty(d)
        @warn "No $collection particle found."
        return nothing
    else
        return plot_makie(d, u; kw...)
    end
end

"""
$(TYPEDSIGNATURES)
Plot `scatter` data points (in interactive mode)

`collection`: filter the type of particles

## Examples

```julia
d = randn_pvector(50)
plot_makie!(fig, d, nothing)

d = randn_pvector(50, u"km")
plot_makie!(fig, d, u"m")
```
"""
function plot_makie!(fig, data::Array{T,1}, u::Union{Nothing, Unitful.FreeUnits} = u"kpc";
    markersize = estimate_markersize(data, u),
    markerspace=:data,
    size = (1000, 1000),
    kw...
) where T<:PVector
    d = [point3(ustrip(u, p)) for p in data]
    Makie.scatter!(fig, d; markersize, markerspace, figure = (size = size,), kw...)
end

function plot_makie!(fig, data::Array{T,1}, u::Union{Nothing, Unitful.FreeUnits} = u"kpc";
    markersize = estimate_markersize(data, u),
    markerspace=:data,
    size = (1000, 1000),
    kw...
) where T<:AbstractParticle3D
    d = [point3(ustrip(u, p.Pos)) for p in data]
    Makie.scatter!(fig, d; markersize, markerspace, figure = (size = size,), kw...)
end

function plot_makie!(fig, data::StructArray{T,N,NT,Tu}, u::Union{Nothing, Unitful.FreeUnits} = u"kpc"; kw...) where T<:AbstractParticle3D where N where NT where Tu
    plot_makie!(fig, data.Pos, u; kw...)
end

function plot_makie!(fig, data::Union{Array{T,N}, StructArray{T,N,NT,Tu}}, collection::Collection, u::Union{Nothing, Unitful.FreeUnits} = u"kpc"; kw...) where T<:AbstractParticle3D where N where NT where Tu
    d = filter(p->p.Collection == collection, data)
    if isempty(d)
        @warn "No $collection particle found."
        return nothing
    else
        plot_makie!(fig, d, u; kw...)
    end
end

function plot_makie!(fig, data::StructArray{T,N,NT,Tu}, u::Union{Nothing, Unitful.FreeUnits} = u"kpc"; kw...) where T<:AbstractPoint3D where N where NT where Tu
    plot_makie!(fig, Array(data), u; kw...)
end

"""
$(TYPEDSIGNATURES)
Scatter plot of points or particles in REPL

`collection`: filter the type of particles

## Keywords
$_common_keyword_axis_label

## Examples
julia> `unicode_scatter(randn_pvector(100))`
"""
function unicode_scatter(data::Array{T, N}, u::Union{Nothing, Unitful.FreeUnits} = u"kpc";
                         xaxis = :x, yaxis = :y,
                         xlabel = "$(xaxis)$(axisunit(u))", ylabel = "$(yaxis)$(axisunit(u))",
                         kw...) where T<:AbstractPoint where N
    len = length(data)
    x = zeros(len)
    y = zeros(len)
    
    d = ustrip.(u, data)

    for i in 1:len
        x[i] = getproperty(d[i], xaxis)
        y[i] = getproperty(d[i], yaxis)
    end

    return UnicodePlots.scatterplot(x, y; xlabel, ylabel, kw...)
end

function unicode_scatter(data::Array{T, N}, u::Union{Nothing, Unitful.FreeUnits} = u"kpc";
                         kw...) where T<:AbstractParticle where N
    d = [p.Pos for p in data]
    return unicode_scatter(d, u; kw...)
end

function unicode_scatter(data::StructArray{T,N,NT,Tu}, u::Union{Nothing, Unitful.FreeUnits} = u"kpc";
                         kw...) where T<:AbstractParticle where N where NT where Tu
    return unicode_scatter(data.Pos, u; kw...)
end

function unicode_scatter(data::Union{Array{T,N}, StructArray{T,N,NT,Tu}}, collection::Collection, u::Union{Nothing, Unitful.FreeUnits} = u"kpc";
    kw...) where T<:AbstractParticle where N where NT where Tu
    d = filter(p->p.Collection == collection, data)
    if isempty(d)
        @warn "No $collection particle found."
        return nothing
    else
        return unicode_scatter(d, u; kw...)
    end
end
