function rotationcurve(data, units = uAstro;
                       rmhead::Int64 = 0,
                       rmtail::Int64 = 0,
                       savelog = true,
                       savefolder = pwd())
    p0 = median(data, :Pos)
    v0 = averagebymass(data, :Vel)

    uLength = getuLength(units)
    uVel = getuVel(units)

    pos = [ustrip(uLength, p.Pos - p0) for p in Iterators.flatten(values(data))]
    vel = [ustrip(uVel, p.Vel - v0) for p in Iterators.flatten(values(data))]

    R = norm.(pos)
    Vrot = rotvel.(vel, pos)

    Rmean, Vmean, Rstd, Vstd = distribution(R, Vrot;  rmhead, rmtail)

    if savelog
        df = DataFrame(Rmean = Rmean, Vmean = Vmean, Rstd = Rstd, Vstd = Vstd)
        outputfile = joinpath(savefolder, "rotationcurve.csv")
        CSV.write(outputfile, df)
        println("Rotation curve data saved to ", outputfile)
    end
    
    return Rmean, Vmean, Rstd, Vstd
end

function unicode_rotationcurve(data, units = uAstro;
                               timestamp = nothing,
                               rmhead::Int64 = 0,
                               rmtail::Int64 = 0,
                               kw...)
    uLength = getuLength(units)
    uVel = getuVel(units)

    xlb = "R" * axisunit(uLength)
    ylb = "RotV" * axisunit(uVel)

    if isnothing(timestamp)
        ts = ""
    else
        ts = "at $timestamp"
    end

    Rmean, Vmean, Rstd, Vstd = rotationcurve(data, units;  rmhead, rmtail)
    
    UnicodePlots.lineplot(Rmean, Vmean;
                          xlabel = xlb,
                          ylabel = ylb,
                          title = "Rotation Curve" * ts,
                          kw...)
end

function plot_rotationcurve!(ax, data, units = uAstro;
                             rmhead::Int64 = 0,
                             rmtail::Int64 = 0,
                             savelog = true,
                             savefolder = pwd(),
                             kw...)
    Rmean, Vmean, Rstd, Vstd = rotationcurve(data, units;  rmhead, rmtail, savelog, savefolder)

    Makie.lines!(ax, Rmean, Vmean; kw...)

    y_low = Vmean - Vstd
    y_high = Vmean + Vstd
    Makie.band!(ax, Rmean, y_low, y_high; kw...)
end

function plot_rotationcurve(data,
                              units = uAstro;
                              timestamp = nothing,
                              rmhead::Int64 = 0,
                              rmtail::Int64 = 0,
                              savelog = true,
                              savefolder = pwd(),
                              kw...) where T<:AbstractParticle3D
    scene, layout = layoutscene()

    uLength = getuLength(units)
    uVel = getuVel(units)

    xlb = "R" * axisunit(uLength)
    ylb = "RotV" * axisunit(uVel)

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

    plot_rotationcurve!(ax, data, units;  rmhead, rmtail, savelog, savefolder, kw...)

    return scene, layout
end
