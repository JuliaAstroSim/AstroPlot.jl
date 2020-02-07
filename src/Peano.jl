function plotly_peano(bits = 1;
                      marker_size = 3,
                      kw...)
    if bits > 8
        @warn "bits (=$bits) is too large. May have display lagging"
    end
    n = 1<<bits
    len = (n)^3

    x = zeros(Int64, n, n, n)
    y = zeros(Int64, n, n, n)
    z = zeros(Int64, n, n, n)

    p = zeros(Int128, n, n, n)
    for i in 0:n-1, j in 0:n-1, k in 0:n-1
        x[i+1,j+1,k+1] = i
        y[i+1,j+1,k+1] = j
        z[i+1,j+1,k+1] = k
        p[i+1,j+1,k+1] = peanokey(i, j, k, bits = bits)
    end

    data = [reshape(p, 1, len); reshape(x, 1, len); reshape(y, 1, len); reshape(z, 1, len)]
    data = sortslices(data, dims = 2)

    return Plotly.plot(scatter3d(
        x = data[2,:],
        y = data[3,:],
        z = data[4,:],
        text = string.(data[1,:]),
        marker_size = marker_size;
        kw...
    ))
end