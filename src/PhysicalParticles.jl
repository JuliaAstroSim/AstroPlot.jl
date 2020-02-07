function plotly_scatter(data::Array{PVector{T},1};
                        mode = "markers",
                        marker_size = 3,
                        marker_line_width = 0,
                        kw...) where T<:Number
    len = length(data)
    if len >= 100000
        @warn "Interactive plotting of more than 100000 points may have lagging problem"
    end

    x = zeros(len)
    y = zeros(len)
    z = zeros(len)

    for i in 1:len
        x[i] = data[i].x
        y[i] = data[i].y
        z[i] = data[i].z
    end

    return Plotly.scatter3d(
        x=x, y=y, z=z;
        mode = mode,
        marker_size = marker_size,
        kw...
    )
end

function plotly_scatter(data::Array{PVector{T},1}, u::Units = u"kpc"; options = Dict(), kw...) where T<:Quantity
    d = ustrip.(u, data)

    return plotly_scatter(d, options = options; kw...)
end

function plotly_scatter(data::Array{AbstractParticle3D,1}, u::Units = u"kpc"; options = Dict(), kw...)
    d = map(p -> ustrip(u, p.Pos), data)

    return plotly_scatter(d, options = options; kw...)
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

function unicode_scatter(data::Array{PVector{T}, 1}, u::Units;
                         xaxis = :x, yaxis = :y,
                         xlabel = "$xaxis [$u]", ylabel = "$yaxis [$u]",
                         kw...) where T<:Quantity
    d = ustrip.(u, data)

    return unicode_scatter(d, xaxis = xaxis, yaxis = yaxis, xlabel = xlabel, ylabel = ylabel; kw...)
end