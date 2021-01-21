function sortarrays!(by::Array, another::Array)
    data = Pair.(by, another)
    sort!(data, by = x->x.first)
    for i in 1:length(data)
        @inbounds by[i] = data[i].first
        @inbounds another[i] = data[i].second
    end
end

function density(r::Array, m::Array;
                 section::Int64 = floor(Int64, length(r)^SectionIndex),)
    data = Pair.(r,m)
    sort!(data, by = x->x.first)

    column = div(length(r), section)
    d = reshape(data[1 : section * column], section, column)
    
    rsmall = empty(r)
    rmean = empty(r)
    rlarge = empty(r)
    rho = empty(m)

    for col in 1:column
        push!(rsmall, d[1,col].first)
        push!(rlarge, d[end,col].first)
        
        rslice = [p.first for p in d[:,col]]
        push!(rmean, mean(rslice))
    end
    rsmall[1] *= 0.0  # R start from 0

    for col in 1:column
        mslice = [p.second for p in d[:,col]]
        mtotal = sum(mslice)

        V = 4.0*pi/3.0*(rlarge[col]*rlarge[col] - rsmall[col]*rsmall[col])
        push!(rho, mtotal / V)
    end
    return rmean, rho
end

function distribution(x::Array, y::Array;
                      section::Int64 = floor(Int64, length(x)^SectionIndex),
                      rmhead::Int64 = 0,
                      rmtail::Int64 = 0,
                      )
    data = Pair.(x,y)
    sort!(data, by = x->x.first)

    column = div(length(x), section)
    d = reshape(data[1 : section * column], section, column)

    xmean = empty(x)
    xstd = empty(x)
    ymean = empty(y)
    ystd = empty(y)

    for col in 1:column
        xslice = [p.first for p in d[:,col]]
        push!(xmean, mean(xslice))
        push!(xstd, std(xslice))

        yslice = [p.second for p in d[:,col]]
        push!(ymean, mean(yslice))
        push!(ystd, std(yslice))
    end

    margin = length(x) - section * column
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