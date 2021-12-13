"""
$(TYPEDSIGNATURES)
Interactively plot Hilber-Peano curve with `Makie`.
It is recommanded that `bits <= 6` to avoid lagging problems.
"""
function plot_peano(bits::Int = 1)
    if bits > 6
        @warn "bits (=$bits) is too large. May have display lagging"
        println("Are you sure to plot? [yes]/no")
        reply = readline()
        if reply == "" || reply == "yes" || reply == "y"
            
        else
            println("Plotting canceled!")
            return nothing
        end
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

    scene = lines(data[2,:], data[3,:], data[4,:])

    return scene
end