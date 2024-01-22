"""
$(TYPEDSIGNATURES)
Compute radial acceleration magnitude relative to center `p0`
"""
function radialforce(a0, acc, p0, pos)
    a = acc - a0
    pn = normalize(ustrip(pos - p0))
    return abs(a * pn)
end

"""
$(TYPEDSIGNATURES)
Compute radial acceleration magnitude relative to center

## Keywords
$_common_keyword_log
"""
function radialforce(data, units = uAstro;
        savelog::Bool = true,
        savefolder = pwd(),
    )
    p0 = median(data, :Pos)
    a0 = averagebymass(data, :Acc)
    
    uLength = getuLength(units)
    uAcc = getuAcc(units)

    R = [ustrip(uLength, norm(p.Pos - p0)) for p in data]
    acc = [ustrip(uAcc, radialforce(a0, p.Acc, p0, p.Pos)) for p in data]

    if savelog
        df = DataFrame(R = R, acc = acc)
        outputfile = joinpath(savefolder, "radialforce.csv")
        CSV.write(outputfile, df)
        println("Radial force data saved to ", outputfile)
    end

    return R, acc
end

"""
$(TYPEDSIGNATURES)
Plot radial acceleration magnitude relative to center in `REPL`

## Keywords
$_common_keyword_label_title
$_common_keyword_timestamp
"""
function unicode_radialforce(data, units = uAstro;
        timestamp = nothing,
        savelog::Bool = false,
        savefolder = pwd(),
        xlabel = "log(R$(axisunit(getuLength(units))))",
        ylabel = "log(Acc$(axisunit(getuAcc(units))))",
        ts = isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp)),
        title = "Radial Force" * ts,
        kw...
    )
    R, acc = radialforce(data, units; savelog, savefolder)
    UnicodePlots.scatterplot(log10.(R), log10.(acc); xlabel, ylabe, title, kw...)
end

"""
$(TYPEDSIGNATURES)
Plot radial acceleration magnitude relative to center

## Keywords
$_common_keyword_log
$_common_keyword_timestamp
"""
function plot_radialforce!(ax, data, units = uAstro;
        savelog = true,
        savefolder = pwd(),
        kw...
    )
    R, acc = radialforce(data, units; savelog, savefolder)
    Makie.scatter!(ax, log10.(R), log10.(acc); kw...)
end

"""
$(TYPEDSIGNATURES)
Plot radial acceleration magnitude relative to center

## Keywords
$_common_keyword_figure
$_common_keyword_log
$_common_keyword_timestamp
"""
function plot_radialforce(data, units = uAstro;
        timestamp = nothing,
        savelog = true,
        savefolder = pwd(),
        markersize = 0.1,
        size = (1600, 900),
        ts = isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp)),
        xlabel = "log(R$(axisunit(getuLength(units))))",
        ylabel = "log(Acc$(axisunit(getuAcc(units))))",
        title = "Radial Force" * ts,
        kw...
    )
    fig = Figure(; size)
    ax  = GLMakie.Axis(fig[1,1]; xlabel, ylabel, title)
    plot_radialforce!(ax, data, units; savelog, savefolder, markersize, kw...)
    return fig
end