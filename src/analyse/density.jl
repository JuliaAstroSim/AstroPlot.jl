function densitycurve(data, units = uAstro;
                      savelog = true,
                      savefolder = pwd())
    uLength = getuLength(units)
    uMass = getuMass(units)
    p0 = median(data, :Pos)
    pos = [ustrip(uLength, p.Pos - p0) for p in Iterators.flatten(values(data))]
    mass = [ustrip(uMass, p.Mass) for p in Iterators.flatten(values(data))]

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

function unicode_density(data, units = uAstro;
                         timestamp = nothing,
                         kw...)
    xlb = "R" * axisunit(getuLength(units))
    ylb = "Mass" * axisunit(getuMass(units))
    ts = isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp))

    Rmean, Mmean = densitycurve(data, units)
    
    UnicodePlots.lineplot(Rmean, Mmean;
                          xlabel = xlb,
                          ylabel = ylb,
                          title = "Rotation Curve" * ts,
                          kw...)
end

function plot_densitycurve!(ax, data, units = uAstro;
                            savelog = true,
                            savefolder = pwd(),
                            kw...)
    Rmean, Mmean = densitycurve(data, units;  savelog, savefolder)

    Makie.lines!(ax, Rmean, Mmean; kw...)
end

function plot_densitycurve(data,
                           units = uAstro;
                           timestamp = nothing,
                           savelog = true,
                           savefolder = pwd(),
                           resolution = (1600, 900),
                           kw...)
    scene, layout = layoutscene(; resolution)

    xlb = "R" * axisunit(getuLength(units))
    ylb = "Rho" * axisunit(getuDensity(units))
    ts = isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp))

    ax = layout[1,1] = Axis(
        scene,
        xlabel = xlb,
        ylabel = ylb,
        title = "Rotation Curve" * ts
    )

    plot_densitycurve!(ax, data, units;  savelog, savefolder, kw...)

    return scene, layout
end
