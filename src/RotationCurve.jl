function rotationcurve(data, units = uAstro;
                       rmhead::Int64 = 0,
                       rmtail::Int64 = 0,
                       savelog = true,
                       savefolder = pwd(),
                       ) where T<:AbstractParticle3D
    p0 = median(data, :Pos)
    v0 = averagebymass(data, :Vel)

    uLength = getuLength(units)
    uVel = getuVel(units)

    pos = [ustrip(uLength, p.Pos - p0) for p in Iterators.flatten(values(data))]
    vel = [ustrip(uVel, p.Vel - v0) for p in Iterators.flatten(values(data))]

    R = norm.(pos)
    Vrot = rotvel.(vel, pos)

    Rmean, Vmean, Rstd, Vstd = distribution(R, Vrot, rmhead = rmhead, rmtail = rmtail)

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
                               ) where T<:AbstractParticle3D
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
                          title = "Rotation Curve" * ts)
end

function plot_rotationcurve!(ax, data, units = uAstro;
                             rmhead::Int64 = 0,
                             rmtail::Int64 = 0,
                             savelog = true,
                             savefolder = pwd(),
                             kw...)
    Rmean, Vmean, Rstd, Vstd = rotationcurve(data, units;  rmhead, rmtail, savelog, savefolder)

    Makie.lines!(ax, Rmean, Vmean)

    y_low = Vmean - Vstd
    y_high = Vmean + Vstd
    Makie.band!(ax, Rmean, y_low, y_high)
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

    ax = layout[1,1] = LAxis(
        scene,
        xlabel = xlb,
        ylabel = ylb,
        title = "Rotation Curve" * ts
    )

    plot_rotationcurve!(ax, data, units;  timestamp, rmhead, rmtail, savelog, savefolder, kw...)

    return scene, layout
end
