"""
    function densitycurve(data, units = uAstro; kw...)

Compute radial mass density curve of spherically symmetric system

# Keywords
$_common_keyword_log
"""
function densitycurve(data, units = uAstro;
                      savelog = true,
                      savefolder = pwd())
    uLength = getuLength(units)
    uMass = getuMass(units)
    p0 = median(data, :Pos)
    pos = [ustrip(uLength, p.Pos - p0) for p in data]
    mass = [ustrip(uMass, p.Mass) for p in data]

    R = norm.(pos)
    Rmean, Mmean = density(R, mass)

    if savelog
      df = DataFrame(Rmean = Rmean, Mmean = Mmean)
      outputfile = joinpath(savefolder, "density.csv")
      CSV.write(outputfile, df)
      println("Density data saved to ", outputfile)
    end

    return Rmean, Mmean
end

"""
    function unicode_density(data, units = uAstro; kw...)

Plot radial mass density curve of spherically symmetric system in `REPL`

# Keywords
$_common_keyword_label_title
$_common_keyword_timestamp
"""
function unicode_density(data, units = uAstro;
                         timestamp = nothing,
                         xlabel = "R" * axisunit(getuLength(units)),
                         ylabel = "Mass" * axisunit(getuMass(units)),
                         ts = isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp)),
                         title = "Rotation Curve" * ts,
                         kw...)
    Rmean, Mmean = densitycurve(data, units)
    UnicodePlots.lineplot(Rmean, Mmean; xlabel, ylabel, title, kw...)
end

"""
    function plot_densitycurve!(ax, data, units = uAstro; kw...)

Plot radial mass density curve of spherically symmetric system

# Keywords
$_common_keyword_log
$_common_keyword_timestamp
"""
function plot_densitycurve!(ax, data, units = uAstro;
                            savelog = true,
                            savefolder = pwd(),
                            kw...)
    Rmean, Mmean = densitycurve(data, units;  savelog, savefolder)
    Makie.lines!(ax, Rmean, Mmean; kw...)
end

"""
    function plot_densitycurve(data, units = uAstro; kw...)

Plot radial mass density curve of spherically symmetric system

# Keywords
$_common_keyword_figure
$_common_keyword_log
$_common_keyword_timestamp
"""
function plot_densitycurve(data, units = uAstro;
                           timestamp = nothing,
                           xlabel = "R" * axisunit(getuLength(units)),
                           ylabel = "Rho" * axisunit(getuDensity(units)),
                           ts = isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp)),
                           title = "Rotation Curve" * ts,
                           savelog = true,
                           savefolder = pwd(),
                           resolution = (1600, 900),
                           kw...)
    scene, layout = layoutscene(; resolution)
    ax = layout[1,1] = GLMakie.Axis(scene; xlabel, ylabel, title)
    plot_densitycurve!(ax, data, units;  savelog, savefolder, kw...)
    return scene, layout
end