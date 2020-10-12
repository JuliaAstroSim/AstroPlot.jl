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
function plot_energy(datafile::String,
                     uTime = u"Gyr",
                     uEnergy = u"Msun * kpc^2 / Gyr^2";
                     title = "Energy",
                     xlabel = "t [$uTime]",
                     ylabel = "E [$uEnergy]",
                     )
    df = DataFrame(CSV.File(datafile))
    scene, layout = layoutscene()
    
    ax = layout[1,1] = LAxis(
        scene,
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
    )
    Makie.lines!(scene, df.time, df.energy)
    return scene, layout
end