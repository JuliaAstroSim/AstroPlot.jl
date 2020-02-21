function sortarrays!(by::Array, another::Array)
    data = Pair.(by, another)
    sort!(data, by = x->x.first)
    for i in 1:length(data)
        @inbounds by[i] = data[i].first
        @inbounds another[i] = data[i].second
    end
end

function distribution(x::Array, y::Array,
                      section::Int64 = floor(Int64, length(x)^(2/3));
                      rmhead::Int64 = 0,
                      rmtail::Int64 = 0,
                      )
    data = Pair.(x,y)
    sort!(data, by = x->x.first)

    colume = div(length(x), section)
    d = reshape(data[1 : section * colume], section, colume)

    xmean = empty(x)
    xstd = empty(x)
    ymean = empty(y)
    ystd = empty(y)

    for col in 1:colume
        xslice = [p.first for p in d[:,col]]
        push!(xmean, mean(xslice))
        push!(xstd, std(xslice))

        yslice = [p.second for p in d[:,col]]
        push!(ymean, mean(yslice))
        push!(ystd, std(yslice))
    end

    margin = length(x) - section * colume
    if margin == 0
        return xmean[1+rmhead : end-rmtail],
               ymean[1+rmhead : end-rmtail],
               xstd[1+rmhead : end-rmtail],
               ystd[1+rmhead : end-rmtail]
    else
        xslice = [p.first for p in d[end-margin : end]]
        push!(xmean, mean(xslice))
        push!(xstd, std(xslice))

        yslice = [p.second for p in d[end-margin : end]]
        push!(ymean, mean(yslice))
        push!(ystd, std(yslice))

        return xmean[1+rmhead : end-rmtail],
               ymean[1+rmhead : end-rmtail],
               xstd[1+rmhead : end-rmtail],
               ystd[1+rmhead : end-rmtail]
    end
end

rotvel(vel::PVector, pos::PVector) = vel * normalize(cross(cross(pos, vel), pos))

radialvel(vel::PVector, pos::PVector) = vel * normalize(pos)