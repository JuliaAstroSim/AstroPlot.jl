"""
    plot_profiling(datafile::String; kw...)

Plot profiling curves

Supported keywords:
- title
- xlabel
- ylabel
"""
function plot_profiling(datafile::String;
                        title = "Profiling",
                        xlabel = "step",
                        ylabel = "t [ns]",
                        kw...)
    df = DataFrame(CSV.File(datafile))
    scene, layout = layoutscene()

    ax = layout[1,1] = LAxis(
        scene,
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
    )

    columns = names(df)
    scenes = [Makie.lines!(ax, df[columns[1]], df[columns[k]],  color = RGB(rand(3)...)) for k in 2:length(columns)]

    leg = layout[1,2] = LLegend(scene, scenes, columns[2:end])

    return scene, layout
end

function pie()
    
end