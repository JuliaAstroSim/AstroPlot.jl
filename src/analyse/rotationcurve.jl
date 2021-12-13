"""
$(TYPEDSIGNATURES)
Return `Tuple(Rmean, Vmean, Rstd, Vstd)`, where `mean` is mean value, `std` means standard deviation.

## Keywords
$_common_keyword_head_tail
$_common_keyword_log
$_common_keyword_section
"""
function rotationcurve(data, units = uAstro;
                       rmhead::Int64 = 0,
                       rmtail::Int64 = 0,
                       section::Int64 = floor(Int64, length(data)^SectionIndex),
                       savelog::Bool = true,
                       savefolder = pwd())
    p0 = median(data, :Pos)
    v0 = averagebymass(data, :Vel)

    uLength = getuLength(units)
    uVel = getuVel(units)

    pos = [ustrip(uLength, p.Pos - p0) for p in data]
    vel = [ustrip(uVel, p.Vel - v0) for p in data]

    R = norm.(pos)
    Vrot = rotvel.(vel, pos)

    Rmean, Vmean, Rstd, Vstd = distribution(R, Vrot;  rmhead, rmtail, section)

    if savelog
        df = DataFrame(Rmean = Rmean, Vmean = Vmean, Rstd = Rstd, Vstd = Vstd)
        outputfile = joinpath(savefolder, "rotationcurve.csv")
        CSV.write(outputfile, df)
        println("Rotation curve data saved to ", outputfile)
    end
    
    return Rmean, Vmean, Rstd, Vstd
end

"""
$(TYPEDSIGNATURES)
Plot rotation curve in `REPL`

## Keywords
$_common_keyword_head_tail
$_common_keyword_log
$_common_keyword_section
"""
function unicode_rotationcurve(data, units = uAstro;
                               timestamp = nothing,
                               section::Int64 = floor(Int64, length(data)^SectionIndex),
                               rmhead::Int64 = 0,
                               rmtail::Int64 = 0,
                               savelog::Bool = true,
                               savefolder = pwd(),
                               xlabel = "R" * axisunit(getuLength(units)),
                               ylabel = "RotV" * axisunit(getuVel(units)),
                               ts = isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp)),
                               title = "Rotation Curve" * ts,
                               kw...)
    Rmean, Vmean, Rstd, Vstd = rotationcurve(data, units;  rmhead, rmtail, section, savelog, savefolder)
    UnicodePlots.lineplot(Rmean, Vmean; xlabel, ylabel, title, kw...)
end

"""
$(TYPEDSIGNATURES)
Plot rotation curve in `ax`

## Keywords
$_common_keyword_head_tail
$_common_keyword_log
$_common_keyword_section
"""
function plot_rotationcurve!(ax, data, units = uAstro;
                             rmhead::Int64 = 0,
                             rmtail::Int64 = 0,
                             section::Int64 = floor(Int64, length(data)^SectionIndex),
                             savelog = true,
                             savefolder = pwd(),
                             kw...)
    Rmean, Vmean, Rstd, Vstd = rotationcurve(data, units;  rmhead, rmtail, savelog, savefolder, section)

    Makie.lines!(ax, Rmean, Vmean; kw...)

    y_low = Vmean - Vstd
    y_high = Vmean + Vstd
    Makie.band!(ax, Rmean, y_low, y_high; kw...)
end

"""
$(TYPEDSIGNATURES)
Plot rotation curve

## Keywords
$_common_keyword_figure
$_common_keyword_head_tail
$_common_keyword_log
$_common_keyword_section
"""
function plot_rotationcurve(data, units = uAstro;
                              timestamp = nothing,
                              rmhead::Int64 = 0,
                              rmtail::Int64 = 0,
                              xlabel = "R" * axisunit(getuLength(units)),
                              ylabel = "RotV" * axisunit(getuVel(units)),
                              title = "Rotation Curve" * (isnothing(timestamp) ? "" : @sprintf(" at %.6f ", ustrip(timestamp)) * string(unit(timestamp))),
                              savelog = true,
                              savefolder = pwd(),
                              resolution = (1600, 900),
                              kw...) where T<:AbstractParticle3D
    scene, layout = layoutscene(; resolution)
    ax = layout[1,1] = GLMakie.Axis(scene; xlabel, ylabel, title)
    plot_rotationcurve!(ax, data, units;  rmhead, rmtail, savelog, savefolder, kw...)
    return scene, layout
end
