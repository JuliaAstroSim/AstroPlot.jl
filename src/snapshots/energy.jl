function plot_energy(datafile::AbstractString,
                     uTime = u"Gyr",
                     uEnergy = u"Msun * kpc^2 / Gyr^2";
                     title = "Energy",
                     label = nothing,
                     xlabel = "t [$uTime]",
                     ylabel = "E [$uEnergy]",
                     kw...)
    df = DataFrame(CSV.File(datafile))
    return Plots.plot(
        df.time,
        df.energy;
        title = title,
        label = label,
        xlabel = xlabel,
        ylabel = ylabel,
        kw...
    )
end