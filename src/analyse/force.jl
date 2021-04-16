function force(data, units = uAstro;
        savelog::Bool = true,
        savefolder = pwd(),
    )
    p0 = median(data, :Pos)
    a0 = averagebymass(data, :Acc)
    
    uLength = getuLength(units)
    uAcc = getuAcc(units)

    R = [ustrip(uLength, norm(p.Pos - p0)) for p in Iterators.flatten(values(data))]
    acc = [ustrip(uAcc, norm(p.Acc - a0)) for p in Iterators.flatten(values(data))]
    
    if savelog
        df = DataFrame(R = R, acc = acc)
        outputfile = joinpath(savefolder, "force.csv")
        CSV.write(outputfile, df)
        println("Force data saved to ", outputfile)
    end

    return R, acc
end

function unicode_force(data, units = uAstro;
        timestamp = nothing,
        savelog::Bool = false,
        savefolder = pwd(),
        xlabel = "log(R$(axisunit(getuLength(units))))",
        ylabel = "log(Acc$(axisunit(getuAcc(units))))",
        ts = isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp)),
        title = "Force" * ts,
        kw...
    )
    R, acc = force(data, units; savelog, savefolder)
    UnicodePlots.scatterplot(log10.(R), log10.(acc); xlabel, ylabel, title, kw...)
end

function plot_force!(ax, data, units = uAstro;
        savelog = true,
        savefolder = pwd(),
        kw...
    )
    R, acc = force(data, units; savelog, savefolder)
    Makie.scatter!(ax, log10.(R), log10.(acc); kw...)
end

function plot_force(data, units = uAstro;
        timestamp = nothing,
        savelog = true,
        savefolder = pwd(),
        markersize = 0.1,
        resolution = (1600, 900),
        ts = isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp)),
        xlabel = "log(R$(axisunit(getuLength(units))))",
        ylabel = "log(Acc$(axisunit(getuAcc(units))))",
        title = "Force" * ts,
        kw...
    )
    scene, layout = layoutscene(; resolution)
    ax = layout[1,1] = Axis(scene; xlabel, ylabel, title)
    plot_force!(ax, data, units; savelog, savefolder, markersize, kw...)
    return scene, layout
end