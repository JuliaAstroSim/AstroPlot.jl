function radialpotential(data, units = uAstro;
        savelog::Bool = true,
        savefolder = pwd(),
    )
    p0 = median(data, :Pos)
    
    uLength = getuLength(units)
    uEnergy = getuEnergy(units)

    R = [ustrip(uLength, norm(p.Pos - p0)) for p in Iterators.flatten(values(data))]
    pot = [ustrip(uEnergy, p.Potential) for p in Iterators.flatten(values(data))]

    if savelog
        df = DataFrame(R = R, pot = pot)
        outputfile = joinpath(savefolder, "radialpotential.csv")
        CSV.write(outputfile, df)
        println("Radial potential data saved to ", outputfile)
    end

    return R, pot
end

function unicode_radialpotential(data, units = uAstro;
        timestamp = nothing,
        savelog::Bool = false,
        savefolder = pwd(),
        ts = isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp)),
        xlabel = "log(R$(axisunit(getuLength(units))))",
        ylabel = "log(Acc$(axisunit(getuEnergy(units))))",
        title = "Radial Potential" * ts,
        kw...
    )
    R, pot = radialpotential(data, units; savelog, savefolder)
    UnicodePlots.scatterplot(log10.(R), log10.(abs.(pot)); xlabel, ylabel, title, kw...)
end

function plot_radialpotential!(ax, data, units = uAstro;
        savelog = true,
        savefolder = pwd(),
        kw...
    )
    R, pot = radialpotential(data, units)
    
    Makie.scatter!(ax, log10.(R), log10.(abs.(pot)); kw...)
end

function plot_radialpotential(data, units = uAstro;
        timestamp = nothing,
        savelog = true,
        savefolder = pwd(),
        markersize = 0.1,
        resolution = (1600, 900),
        xlabel = "log(R$(axisunit(getuLength(units))))",
        ylabel = "log(Potential$(axisunit(getuEnergy(units))))",
        ts = isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp)),
        title = "Radial Potential" * ts,
        kw...
    )
    scene, layout = layoutscene(; resolution)
    ax = layout[1,1] = GLMakie.Axis(scene; xlabel, ylabel, title)
    plot_radialpotential!(ax, data, units; savelog, savefolder, markersize, kw...)
    return scene, layout
end