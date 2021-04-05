"""
    plot_energy(datafile::String; kw...)

Read energy data, plot in `lines`, return `scene` and `layout`
Data columns: time, energy

Supported keywords:
- uTime
- uEnergy
- title
- xlabel
- ylabel
"""
function plot_energy!(ax, df::DataFrame;
                      kw...)
    Makie.lines!(ax, df.time, df.energy; kw...)
end

function plot_energy!(ax, datafile::String;
                      kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy!(ax, df; kw...)
end

function plot_energy_potential!(ax, df::DataFrame; kw...)
    Makie.lines!(ax, df.time, df.potential; kw...)
end

function plot_energy_potential!(ax, datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy_potential!(ax, df; kw...)
end

function plot_energy_kinetic!(ax, df::DataFrame; kw...)
    Makie.lines!(ax, df.time, df.kinetic; kw...)
end

function plot_energy_kinetic!(ax, datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy_kinetic!(ax, df; kw...)
end

function plot_energy_kinetic(df::DataFrame;
                     uTime = u"Gyr",
                     uEnergy = u"Msun * kpc^2 / Gyr^2",
                     title = "Kinetic Energy",
                     xlabel = "t [$uTime]",
                     ylabel = "E [$uEnergy]",
                     resolution = (1600, 900),
                     kw...)
    scene, layout = layoutscene(; resolution)
    
    ax = layout[1,1] = Axis(
        scene,
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
    )

    plot_energy_kinetic!(ax, df; kw...)
    return scene, layout
end

function plot_energy_kinetic(datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy_kinetic(df; kw...)
end

function plot_energy_potential(df::DataFrame;
                     uTime = u"Gyr",
                     uEnergy = u"Msun * kpc^2 / Gyr^2",
                     title = "Potential Energy",
                     xlabel = "t [$uTime]",
                     ylabel = "E [$uEnergy]",
                     resolution = (1600, 900),
                     kw...)
    scene, layout = layoutscene(; resolution)
    
    ax = layout[1,1] = Axis(
        scene,
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
    )

    plot_energy_potential!(ax, df; kw...)
    return scene, layout
end

function plot_energy_potential(datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy_potential(df; kw...)
end

function plot_energy(df::DataFrame;
                     uTime = u"Gyr",
                     uEnergy = u"Msun * kpc^2 / Gyr^2",
                     title = "Energy",
                     xlabel = "t [$uTime]",
                     ylabel = "E [$uEnergy]",
                     resolution = (1600, 900),
                     potential = true,
                     kinetic = true,
                     colorpotential = :red,
                     colorkinetic = :blue,
                     colortotal = :black,
                     kw...)
    scene, layout = layoutscene(; resolution)
    
    ax = layout[1,1] = Axis(
        scene,
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
    )

    if !hasproperty(df, :energy) && hasproperty(df, :potential) && hasproperty(df, :kinetic)
        df.energy = df.potential + df.kinetic
    else
        error("Please output energy (or potential and kinetic energy) in file $datafile")
    end

    p1 = plot_energy!(ax, df; color = colortotal, kw...)
    p = [p1]
    names = ["total energy"]
    
    if potential
        if !(hasproperty(df, :potential))
            @warn "There is no potential energy data in file $datafile"
        else
            p2 = plot_energy_potential!(ax, df; color = colorpotential, kw...)
            push!(p, p2)
            push!(names, "potential energy")
        end
    end

    if kinetic
        if !(hasproperty(df, :kinetic))
            @warn "There is no kinetic energy data in file $datafile"
        else
            p3 = plot_energy_kinetic!(ax, df; color = colorkinetic, kw...)
            push!(p, p3)
            push!(names, "kinetic energy")
        end
    end

    if length(p) > 1
        leg = layout[1,2] = Legend(scene, p, names)
    end

    return scene, layout
end

function plot_energy(datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy(df; kw...)
end

function energy_delta(df::DataFrame)
    time = @view df.time[2:end]
    E0 = @view df.energy[1:end-1]
    E1 = @view df.energy[2:end]
    dE = E1 .- E0
    return time, dE
end

function plot_energy_delta!(ax, df::DataFrame;
                            kw...)
    if !hasproperty(df, :energy) && hasproperty(df, :potential) && hasproperty(df, :kinetic)
        df.energy = df.potential + df.kinetic
    else
        error("Please output energy (or potential and kinetic energy) in file $datafile")
    end
    time, dE = energy_delta(df)
    Makie.lines!(ax, time, dE; kw...)
end

function plot_energy_delta!(ax, datafile::String;
                            kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy_delta!(ax, df; kw...)
end

function plot_energy_delta(df::DataFrame;
                           uTime = u"Gyr",
                           uEnergy = u"Msun * kpc^2 / Gyr^2",
                           title = "Delta Energy",
                           xlabel = "t [$uTime]",
                           ylabel = "dE [$uEnergy]",
                           resolution = (1600, 900),
                           kw...)
    df = DataFrame(CSV.File(datafile))
    scene, layout = layoutscene(; resolution)
    
    ax = layout[1,1] = Axis(
        scene,
        xlabel = xlabel,
        ylabel = ylabel,
        title = title,
    )

    plot_energy_delta!(ax, df; kw...)
    return scene, layout
end

function plot_energy_delta(datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy_delta(df; kw...)
end