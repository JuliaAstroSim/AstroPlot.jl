function plotly_scatter(data::Array{PVector{T},1};
                        mode = "markers",
                        marker_size = 3,
                        marker_line_width = 0,
                        options = Dict(), kwargs...) where T<:Number
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

    return Plotly.plot(scatter3d(x=x, y=y, z=z;
                                 mode = mode,
                                 marker_size = marker_size,
                                 kwargs...
                                 ),
                       options = options)
end

function plotly_scatter(data::Array{PVector{T},1}, u::Units = u"kpc"; options = Dict(), kwargs...) where T<:Quantity
    d = ustrip.(u, data)

    plotly_scatter(d, options = options; kwargs...)
end

function plotly_scatter(data::Array{AbstractParticle3D,1}, u::Units = u"kpc"; options = Dict(), kwargs...)
    d = map(p -> ustrip(u, p.Pos), data)

    plotly_scatter(d, options = options; kwargs...)
end