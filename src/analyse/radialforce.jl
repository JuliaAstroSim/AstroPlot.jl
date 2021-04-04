function radialforce(a0, acc, p0, pos)
    a = acc - a0
    pn = normalize(ustrip(pos - p0))
    return abs(a * pn)
end

function radialforce(data, units = uAstro;
        savelog::Bool = true,
        savefolder = pwd(),
    )
    p0 = median(data, :Pos)
    a0 = averagebymass(data, :Acc)
    
    uLength = getuLength(units)
    uAcc = getuAcc(units)

    R = [ustrip(uLength, norm(p.Pos - p0)) for p in Iterators.flatten(values(data))]
    acc = [ustrip(uAcc, radialforce(a0, p.Acc, p0, p.Pos)) for p in Iterators.flatten(values(data))]

    if savelog
        df = DataFrame(R = R, acc = acc)
        outputfile = joinpath(savefolder, "radialforce.csv")
        CSV.write(outputfile, df)
        println("Radial force data saved to ", outputfile)
    end

    return R, acc
end

function unicode_radialforce(data, units = uAstro;
        timestamp = nothing,
        savelog::Bool = false,
        savefolder = pwd(),
        kw...
    )
    R, acc = radialforce(data, units; savelog, savefolder)
    
    ts = isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp))
    UnicodePlots.scatterplot(
        log10.(R), log10.(acc);
        xlabel = "log(R$(axisunit(getuLength(units))))",
        ylabel = "log(Acc$(axisunit(getuAcc(units))))",
        title = "Radial Force" * ts,
        kw...
    )
end

function plot_radialforce!(ax, data, units = uAstro;
        savelog = true,
        savefolder = pwd(),
        kw...
    )
    R, acc = radialforce(data, units; savelog, savefolder)
    
    Makie.scatter!(ax, log10.(R), log10.(acc); kw...)
end

function plot_radialforce(data, units = uAstro;
        timestamp = nothing,
        savelog = true,
        savefolder = pwd(),
        markersize = 0.1,
        resolution = (1600, 900),
        kw...
    )
    scene, layout = layoutscene(; resolution)
    
    ts = isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp))
    ax = layout[1,1] = Axis(
        scene,
        xlabel = "log(R$(axisunit(getuLength(units))))",
        ylabel = "log(Acc$(axisunit(getuAcc(units))))",
        title = "Radial Force" * ts
    )

    plot_radialforce!(ax, data, units; savelog, savefolder, markersize, kw...)

    return scene, layout
end