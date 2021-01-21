"""
    plot_energy(datafile::String; kw...)

Read energy data, plot in `lines`, return `scene` and `layout`
Data columns: time, energy

Supported keywords:
- uTime
- uEnergy
- title
- xlabel
- ylabel
"""
function plot_energy!(ax, df::DataFrame;
                      kw...)
    Makie.lines!(ax, df.time, df.energy; kw...)
end

function plot_energy!(ax, datafile::String;
                      kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy!(ax, df; kw...)
end

function plot_energy(datafile::String,
                     uTime = u"Gyr",
                     uEnergy = u"Msun * kpc^2 / Gyr^2";
                     title = "Energy",
                     xlabel = "t [$uTime]",
                     ylabel = "E [$uEnergy]",
                     kw...)
    df = DataFrame(CSV.File(datafile))
    scene, layout = layoutscene()
    
    ax = layout[1,1] = LAxis(
        scene,
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
    )

    plot_energy!(ax, df; kw...)
    return scene, layout
end

function energydelta(df::DataFrame)
    time = @view df.time[2:end]
    E0 = @view df.energy[1:end-1]
    E1 = @view df.energy[2:end]
    dE = E1 .- E0
    return time, dE
end

function plot_energy_delta!(ax, df::DataFrame;
                            kw...)
    time, dE = energydelta(df)
    Makie.lines!(ax, time, dE; kw...)
end

function plot_energy_delta!(ax, datafile::String;
                            kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy_delta!(ax, df; kw...)
end

function plot_energy_delta(datafile::String,
                           uTime = u"Gyr",
                           uEnergy = u"Msun * kpc^2 / Gyr^2";
                           title = "Delta Energy",
                           xlabel = "t [$uTime]",
                           ylabel = "dE [$uEnergy]",
                           kw...)
    df = DataFrame(CSV.File(datafile))
    scene, layout = layoutscene()
    
    ax = layout[1,1] = LAxis(
        scene,
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
    )

    plot_energy_delta!(ax, df; kw...)
    return scene, layout
end