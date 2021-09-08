"""
    function plot_profiling(datafile::String; kw...)
    function plot_profiling!(ax, layout, index, datafile::String; kw...)

Plot profiling curves

# Keywords:
- `title`: title line of the figure
- `resolution`: figure size
$_common_keyword_label
- `colors`

# Examples
```jl
julia> scene, layout = plot_profiling("profiling.csv")
```
"""
function plot_profiling(datafile::String;
                        title = "Profiling",
                        xlabel = "step",
                        ylabel = "t [ns]",
                        resolution = (1600, 900),
                        kw...)
    df = DataFrame(CSV.File(datafile))
    scene, layout = layoutscene(; resolution)

    ax = layout[1,1] = GLMakie.Axis(
        scene; xlabel, ylabel, title,
    )

    columns = names(df)
    scenes = [Makie.lines!(ax, df[!,columns[1]], df[!,columns[k]],  color = RGB(rand(3)...); kw...) for k in 2:length(columns)]

    leg = layout[1,1] = Legend(
        scene, scenes,
        columns[2:end],
        tellheight = false,
        tellwidth = false,
        halign = :right,
        valign = :top,
        margin = (10, 10, 10, 10),
    )

    return scene, layout
end

function plot_profiling!(ax, layout, index, datafile::String;
                        colors = nothing,
                        kw...)
    df = DataFrame(CSV.File(datafile))

    columns = names(df)

    if isnothing(colors)
        scenes = [Makie.lines!(ax, df[!,columns[1]], df[!,columns[k]], color = RGB(rand(3)...); kw...) for k in 2:length(columns)]
    else
        if length(colors) < length(columns) - 1
            colors = [colors...; [RGB(rand(3)...) for i in 1:length(columns)-length(colors)-1]]
        end
        scenes = [Makie.lines!(ax, df[!,columns[1]], df[!,columns[k]], color = colors[k-1]; kw...) for k in 2:length(columns)]
    end

    return scenes, columns[2:end]
end