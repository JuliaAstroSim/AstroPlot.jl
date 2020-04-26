function plot_profiling(datafile::AbstractString;
                        title = "Profiling",
                        kw...)
    df = DataFrame(CSV.File(datafile))
    return @df df plot(cols(1), cols(2:ncol(df)))
end