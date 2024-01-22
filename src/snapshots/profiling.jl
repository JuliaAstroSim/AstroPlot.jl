"""
$(TYPEDSIGNATURES)
Plot profiling curves

## Keywords:
- `title`: title line of the figure
- `size`: figure size
$_common_keyword_label
- `colors`

## Examples
```jl
julia> fig = plot_profiling("profiling.csv")
```
"""
function plot_profiling(datafile::String;
                        title = "Profiling",
                        xlabel = "step",
                        ylabel = "t [ns]",
                        size = (1600, 900),
                        kw...)
    df = DataFrame(CSV.File(datafile))
    fig = Figure(; size)

    ax = GLMakie.Axis(
        fig[1,1]; xlabel, ylabel, title,
    )

    columns = names(df)
    scenes = [Makie.lines!(ax, df[!,columns[1]], log10.(df[!,columns[k]]),  color = RGB(rand(3)...); kw...) for k in 2:length(columns)]

    leg = GLMakie.Legend(
        fig[1,1], scenes,
        columns[2:end],
        tellheight = false,
        tellwidth = false,
        halign = :right,
        valign = :top,
        margin = (10, 10, 10, 10),
    )

    return fig
end

function plot_profiling!(ax, index, datafile::String;
                        colors = nothing,
                        kw...)
    df = DataFrame(CSV.File(datafile))

    columns = names(df)

    if isnothing(colors)
        scenes = [Makie.lines!(ax, df[!,columns[1]], log10.(df[!,columns[k]]), color = RGB(rand(3)...); kw...) for k in 2:length(columns)]
    else
        if length(colors) < length(columns) - 1
            colors = [colors...; [RGB(rand(3)...) for i in 1:length(columns)-length(colors)-1]]
        end
        scenes = [Makie.lines!(ax, df[!,columns[1]], log10.(df[!,columns[k]]), color = colors[k-1]; kw...) for k in 2:length(columns)]
    end

    return scenes, columns[2:end]
end