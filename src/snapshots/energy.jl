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
                      kw...
                     )
    Makie.lines!(ax, df.time, df.energy; color, kw...)
end

function plot_energy!(ax, datafile::String;
                      kw...
                     )
    df = DataFrame(CSV.File(datafile))
    Makie.lines!(ax, df.time, df.energy; color, kw...)
end

function plot_energy(datafile::String,
                     uTime = u"Gyr",
                     uEnergy = u"Msun * kpc^2 / Gyr^2";
                     title = "Energy",
                     xlabel = "t [$uTime]",
                     ylabel = "E [$uEnergy]",
                     kw...
                     )
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