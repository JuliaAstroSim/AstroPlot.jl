"""
$(TYPEDSIGNATURES)
Sort two arrays at the same time. `kw` is passed to `Base.sort!`.

## Examples
```jl
julia> a = [1,3,2]
julia> b = ["a", "b", "c"]
julia> sortarrays!(a,b)
julia> a
3-element Vector{Int64}:
 1
 2
 3

julia> b
3-element Vector{String}:
 "a"
 "c"
 "b"
```
"""
function sortarrays(by::Array, another::Array; kw...)
    out_by = deepcopy(by)
    out_another = deepcopy(another)
    sortarrays!(out_by, out_another)
    return out_by, out_another
end

function sortarrays!(by::Array, another::Array; kw...)
    data = Pair.(by, another; kw...)
    sort!(data, by = x->x.first)
    for i in eachindex(data)
        @inbounds by[i] = data[i].first
        @inbounds another[i] = data[i].second
    end
end

"""
$(TYPEDSIGNATURES)
Compute radial mass density. Assuming that the system is spherically symmetric.
Return a `Tuple` of mean radius and mass density in each bin

## Arguments
- `r`: array of radii of particles relative to center
- `m`: array of masses of particles

## Keywords
$_common_keyword_section
"""
function density(r::Array, m::Array;
                 section::Int64 = floor(Int64, length(r)^SectionIndex),)
    data = Pair.(r,m)
    sort!(data, by = x->x.first)

    column = div(length(r), section)
    d = reshape(data[1 : section * column], section, column)
    
    rsmall = Array{eltype(r),1}()
    rmean = Array{eltype(r),1}()
    rlarge = Array{eltype(r),1}()
    rho = Array{eltype(m),1}()

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

struct DataWeighted
    x
    y
    weight
end

"""
$(TYPEDSIGNATURES)
Compute how quantity `y` is distributed along `x`. For example, rotation velocity along radius.
Return `Tuple(xmean, ymean, xstd, ystd)`, where `mean` is mean value, `std` means standard deviation.

## Keywords
$_common_keyword_section
$_common_keyword_head_tail
"""
function distribution(x::Array, y::Array, weight=nothing;
                      section::Int64 = 10,
                      rmhead::Int64 = 0,
                      rmtail::Int64 = 0,
                      uniform_interval::Bool = true,
                      counts = false,
                      )
    # Check if section is valid
    section <= 0 && throw(ArgumentError("section must be a positive integer"))
    length(x) == length(y) || throw(DimensionMismatch("x and y must have the same length"))

    if isnothing(weight)
        weights = ones(size(x))
    else
        weights = weight
    end

    data = StructArray(DataWeighted.(x[1+rmhead:end-rmtail],y[1+rmhead:end-rmtail],weights[1+rmhead:end-rmtail]))
    N = length(data)
    if N == 0
        if counts
            return Float64[], Float64[], Float64[], Float64[], Int[]
        else
            return Float64[], Float64[], Float64[], Float64[]
        end
    end
    
    sort!(data, by = p->p.x)
    # x_sorted =

    xmean = Array{eltype(x),1}()
    xstd = Array{eltype(x),1}()
    ymean = Array{eltype(y),1}()
    ystd = Array{eltype(y),1}()
    bin_N = Array{Int, 1}()

    if uniform_interval
        # Uniform interval binning
        xmin = data.x[1]
        xmax = data.x[end]
        dx = (xmax - xmin) / section
        bin_edges = xmin .+ (0:section) .* dx
        
        start = 1
        for i in 1:section
            # Set right edge: left-closed, right-open for all but last bin
            right_edge = i < section ? bin_edges[i+1] : Inf * x[end]
            end_idx = searchsortedfirst(data.x, right_edge)
            bin = @view data[start:end_idx-1]
            start = end_idx

            if isempty(bin)
                push!(xmean, NaN)
                push!(xstd, NaN)
                push!(ymean, NaN)
                push!(ystd, NaN)
            else
                xslice = identity.(collect(bin.x))
                weight_slice = aweights(identity.(collect(bin.weight)))
                push!(xmean, mean(xslice, weight_slice))
                push!(xstd, std(xslice, weight_slice))

                yslice = identity.(collect(bin.y))
                push!(ymean, mean(yslice, weight_slice))
                push!(ystd, std(yslice, weight_slice))
            end

            push!(bin_N, length(bin))
        end
    else
        N >= section || throw(ArgumentError("Number of data points ($N) must be ≥ number of bins ($section)"))

        bin_counts = div(N, section)
        remainder = N % section
        
        # Calculate bin lengths (x 'remainder' bins have bin_counts+1 points)
        lengths = vcat(fill(bin_counts + 1, remainder), fill(bin_counts, section - remainder))
        
        start = 1
        for l in lengths
            end_idx = start + l - 1
            end_idx > N && break  # Handle case when total points don't match (shouldn't happen with valid inputs)
            bin = @view data[start:end_idx]
            start = end_idx + 1

            xslice = identity.(collect(bin.x))
            weight_slice = aweights(identity.(collect(bin.weight)))
            push!(xmean, mean(xslice, weight_slice))
            push!(xstd, std(xslice, weight_slice))

            yslice = identity.(collect(bin.y))
            push!(ymean, mean(yslice, weight_slice))
            push!(ystd, std(yslice, weight_slice))

            push!(bin_N, length(bin))
        end
    end

    if counts
        return xmean, ymean, xstd, ystd, bin_N
    else
        return xmean, ymean, xstd, ystd
    end
end

struct DataCovWeighted
    x
    y1
    y2
    weight
end

"""
$(TYPEDSIGNATURES)
Compute distribution of covariance between `y1` and `y2` along `x`. For example, rotation velocity along radius.
Return `Tuple(xmean, ymean, xstd, ystd)`, where `mean` is mean value, `std` means standard deviation.

## Keywords
$_common_keyword_section
$_common_keyword_head_tail
"""
function distribution_cov(x::Array, y1::Array, y2::Array, weight=nothing;
        section::Int64 = 10,
        rmhead::Int64 = 0,
        rmtail::Int64 = 0,
        uniform_interval::Bool = true,
        counts = false,
    )
    # Check if section is valid
    section <= 0 && throw(ArgumentError("section must be a positive integer"))
    length(x) == length(y1) || throw(DimensionMismatch("x and y1 must have the same length"))
    length(x) == length(y2) || throw(DimensionMismatch("x and y2 must have the same length"))

    if isnothing(weight)
        weights = ones(size(x))
    else
        weights = weight
    end

    data = StructArray(DataCovWeighted.(
        x[1+rmhead:end-rmtail],
        y1[1+rmhead:end-rmtail],
        y2[1+rmhead:end-rmtail],
        weights[1+rmhead:end-rmtail]
    ))
    N = length(data)
    if N == 0
        # return Float64[], Float64[], Float64[], Float64[]
        if counts
            return Float64[], Float64[], Int[]
        else
            return Float64[], Float64[]
        end
    end
    
    sort!(data, by = p->p.x)
    # x_sorted =

    xmean = Array{eltype(x),1}()
    # xstd = Array{eltype(x),1}()
    # ymean = Array{eltype(y),1}()
    # ystd = Array{eltype(y),1}()
    ycov = Array{eltype(y1),1}()
    bin_N = Array{Int, 1}()

    if uniform_interval
        # Uniform interval binning
        xmin = data.x[1]
        xmax = data.x[end]
        dx = (xmax - xmin) / section
        bin_edges = xmin .+ (0:section) .* dx
        
        start = 1
        for i in 1:section
            # Set right edge: left-closed, right-open for all but last bin
            right_edge = i < section ? bin_edges[i+1] : Inf * x[end]
            end_idx = searchsortedfirst(data.x, right_edge)
            bin = @view data[start:end_idx-1]
            start = end_idx

            if isempty(bin)
                push!(xmean, NaN)
                # push!(xstd, NaN)
                # push!(ymean, NaN)
                # push!(ystd, NaN)
                push!(ycov, NaN)
            else
                xslice = identity.(collect(bin.x))
                weight_slice = aweights(identity.(collect(bin.weight)))
                push!(xmean, mean(xslice, weight_slice))
                # push!(xstd, std(xslice, weight_slice))

                y1slice = identity.(collect(bin.y1))
                y1mean = mean(y1slice, weight_slice)

                y2slice = identity.(collect(bin.y2))
                y2mean = mean(y2slice, weight_slice)

                push!(ycov, cov(y1slice .- y1mean, y2slice .- y2mean))
                # push!(ymean, mean(yslice, weight_slice))
                # push!(ystd, std(yslice, weight_slice))
            end

            push!(bin_N, length(bin))
        end
    else
        N >= section || throw(ArgumentError("Number of data points ($N) must be ≥ number of bins ($section)"))

        bin_counts = div(N, section)
        remainder = N % section
        
        # Calculate bin lengths (x 'remainder' bins have bin_counts+1 points)
        lengths = vcat(fill(bin_counts + 1, remainder), fill(bin_counts, section - remainder))
        
        start = 1
        for l in lengths
            end_idx = start + l - 1
            end_idx > N && break  # Handle case when total points don't match (shouldn't happen with valid inputs)
            bin = @view data[start:end_idx]
            start = end_idx + 1

            xslice = identity.(collect(bin.x))
            weight_slice = aweights(identity.(collect(bin.weight)))
            push!(xmean, mean(xslice, weight_slice))
            # push!(xstd, std(xslice, weight_slice))

            # yslice = identity.(collect(bin.y))
            # push!(ymean, mean(yslice, weight_slice))
            # push!(ystd, std(yslice, weight_slice))

            y1slice = identity.(collect(bin.y1))
            y1mean = mean(y1slice, weight_slice)

            y2slice = identity.(collect(bin.y2))
            y2mean = mean(y2slice, weight_slice)

            push!(ycov, cov(y1slice .- y1mean, y2slice .- y2mean))

            push!(bin_N, length(bin))
        end
    end

    if counts
        return xmean, ycov, bin_N
    else
        return xmean, ycov
    end
end


"""
$(TYPEDSIGNATURES)
Rotational velocity magnitude at `pos` relative to origin.
"""
rotvel(vel::PVector, pos::PVector) = vel * normalize(cross(cross(pos, vel), pos))

"""
$(TYPEDSIGNATURES)
Radial velocity magnitude at `pos` relative to origin.
"""
radialvel(vel::PVector, pos::PVector) = vel * normalize(pos)