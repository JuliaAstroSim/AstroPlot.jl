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
    uLength = getuLength(units)
    uMass = getuMass(units)

    xlb = "R" * axisunit(uLength)
    ylb = "Mass" * axisunit(uMass)

    if isnothing(timestamp)
        ts = ""
    else
        ts = "at $timestamp"
    end

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
                           kw...)
    scene, layout = layoutscene()

    xlb = "R" * axisunit(getuLength(units))
    ylb = "Rho" * axisunit(getuDensity(units))

    if isnothing(timestamp)
        ts = ""
    else
        ts = "at $timestamp"
    end

    ax = layout[1,1] = Axis(
        scene,
        xlabel = xlb,
        ylabel = ylb,
        title = "Rotation Curve" * ts
    )

    plot_densitycurve!(ax, data, units;  savelog, savefolder, kw...)

    return scene, layout
end
