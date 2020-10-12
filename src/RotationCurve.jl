function rotationcurve(particles::Array{T}, units = uAstro;
                       rmhead::Int64 = 0,
                       rmtail::Int64 = 0
                       ) where T<:AbstractParticle3D
    p0 = median(particles, :Pos)
    v0 = averagebymass(particles, :Vel)

    uLength = getuLength(units)
    uVel = getuVel(units)

    pos = [ustrip(uLength, p.Pos - p0) for p in particles]
    vel = [ustrip(uVel, p.Vel - v0) for p in particles]

    R = norm.(pos)
    Vrot = rotvel.(vel, pos)

    Rmean, Vmean, Rstd, Vstd = distribution(R, Vrot, rmhead = rmhead, rmtail = rmtail)
    
    return Rmean, Vmean, Rstd, Vstd
end

function unicode_rotationcurve(particles::Array{T}, units = uAstro;
                               rmhead::Int64 = 0,
                               rmtail::Int64 = 0,
                               ) where T<:AbstractParticle3D
    Rmean, Vmean, Rstd, Vstd = rotationcurve(particles, units, rmhead = rmhead, rmtail = rmtail)
    
    UnicodePlots.lineplot(Rmean, Vmean)
end

function plot_rotationcurve(particles::Array{T},
                              units = uAstro;
                              filename = nothing,
                              timestamp = nothing,
                              rmhead::Int64 = 0,
                              rmtail::Int64 = 0,
                              kw...) where T<:AbstractParticle3D

    Rmean, Vmean, Rstd, Vstd = rotationcurve(particles, units, rmhead = rmhead, rmtail = rmtail)

    uLength = getuLength(units)
    uVel = getuVel(units)

    xlb = "R" * axisunit(uLength)
    ylb = "RotV" * axisunit(uVel)

    if isnothing(timestamp)
        ts = ""
    else
        ts = "at $timestamp"
    end

    scene, layout = layoutscene()

    ax = layout[1,1] = LAxis(
        scene,
        xlabel = xlb,
        ylabel = ylb,
        title = "Rotation Curve" * ts
    )

    Makie.lines!(scene, Rmean, Vmean)

    y_low = Rmean - Vstd
    y_high = Rmean + Vstd
    Makie.band!(scene, Rmean, y_low, y_high)

    return scene, layout
end