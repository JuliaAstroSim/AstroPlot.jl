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

"""
$(TYPEDSIGNATURES)
Compute how quantity `y` is distributed along `x`. For example, rotation velocity along radius.
Return `Tuple(xmean, ymean, xstd, ystd)`, where `mean` is mean value, `std` means standard deviation.

## Keywords
$_common_keyword_section
$_common_keyword_head_tail
"""
function distribution(x::Array, y::Array;
                      section::Int64 = 10,
                      rmhead::Int64 = 0,
                      rmtail::Int64 = 0,
                      uniform_interval::Bool = true,
                      counts = false,
                      )
    # Check if section is valid
    section <= 0 && throw(ArgumentError("section must be a positive integer"))
    length(x) == length(y) || throw(DimensionMismatch("x and y must have the same length"))

    data = StructArray(Pair.(x[1+rmhead:end-rmtail],y[1+rmhead:end-rmtail]))
    N = length(data)
    if N == 0
        return Float64[], Float64[], Float64[], Float64[]
    end
    
    sort!(data, by = x->x.first)
    # x_sorted =

    xmean = Array{eltype(x),1}()
    xstd = Array{eltype(x),1}()
    ymean = Array{eltype(y),1}()
    ystd = Array{eltype(y),1}()
    bin_N = Array{Int, 1}()

    if uniform_interval
        # Uniform interval binning
        xmin = data.first[1]
        xmax = data.first[end]
        dx = (xmax - xmin) / section
        bin_edges = xmin .+ (0:section) .* dx
        
        start = 1
        for i in 1:section
            # Set right edge: left-closed, right-open for all but last bin
            right_edge = i < section ? bin_edges[i+1] : Inf * x[end]
            end_idx = searchsortedfirst(data.first, right_edge)
            bin = @view data[start:end_idx-1]
            start = end_idx

            if isempty(bin)
                push!(xmean, NaN)
                push!(xstd, NaN)
                push!(ymean, NaN)
                push!(ystd, NaN)
            else
                xslice = bin.first
                push!(xmean, mean(xslice))
                push!(xstd, std(xslice))

                yslice = bin.second
                push!(ymean, mean(yslice))
                push!(ystd, std(yslice))
            end

            push!(bin_N, length(bin))
        end
    else
        N >= section || throw(ArgumentError("Number of data points ($N) must be ≥ number of bins ($section)"))

        bin_counts = div(N, section)
        remainder = N % section
        
        # Calculate bin lengths (first 'remainder' bins have bin_counts+1 points)
        lengths = vcat(fill(bin_counts + 1, remainder), fill(bin_counts, section - remainder))
        
        start = 1
        for l in lengths
            end_idx = start + l - 1
            end_idx > N && break  # Handle case when total points don't match (shouldn't happen with valid inputs)
            bin = @view data[start:end_idx]
            start = end_idx + 1

            xslice = bin.first
            push!(xmean, mean(xslice))
            push!(xstd, std(xslice))

            yslice = bin.second
            push!(ymean, mean(yslice))
            push!(ystd, std(yslice))

            push!(bin_N, length(bin))
        end
    end

    if counts
        return xmean, ymean, xstd, ystd, bin_N
    else
        return xmean, ymean, xstd, ystd
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