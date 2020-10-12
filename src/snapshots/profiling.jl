function plot_profiling(datafile::String;
                        title = "Profiling",
                        xlabel = "step",
                        ylabel = "t [ns]",
                        kw...)
    df = DataFrame(CSV.File(datafile))
    return @df df Plots.plot(
        cols(2:ncol(df));
        title = title,
        xlabel = xlabel,
        ylabel = ylabel,
        kw...
    )
end

function pie()
    
end