
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

"""
$(TYPEDSIGNATURES)
Plot kinetic energy in `df` which contains columns named `time` and `kinetic`

## Keywords
$_common_keyword_figure
"""
function plot_energy_kinetic(df::DataFrame;
                     uTime = u"Gyr",
                     uEnergy = u"Msun * kpc^2 / Gyr^2",
                     title = "Kinetic Energy",
                     xlabel = "t [$uTime]",
                     ylabel = "E [$uEnergy]",
                     resolution = (1600, 900),
                     kw...)
    scene, layout = layoutscene(; resolution)
    ax = layout[1,1] = GLMakie.Axis(scene; xlabel, ylabel, title)
    plot_energy_kinetic!(ax, df; kw...)
    return scene, layout, df
end

"""
$(TYPEDSIGNATURES)
Plot kinetic energy in `datafile` which contains columns named `time` and `kinetic`

## Keywords
$_common_keyword_figure
"""
function plot_energy_kinetic(datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy_kinetic(df; kw...)
end

"""
$(TYPEDSIGNATURES)
Plot potential energy in `df` which contains columns named `time` and `potential`

## Keywords
$_common_keyword_figure
"""
function plot_energy_potential(df::DataFrame;
                     uTime = u"Gyr",
                     uEnergy = u"Msun * kpc^2 / Gyr^2",
                     title = "Potential Energy",
                     xlabel = "t [$uTime]",
                     ylabel = "E [$uEnergy]",
                     resolution = (1600, 900),
                     kw...)
    scene, layout = layoutscene(; resolution)
    ax = layout[1,1] = GLMakie.Axis(scene; xlabel, ylabel, title)
    plot_energy_potential!(ax, df; kw...)
    return scene, layout, df
end

"""
$(TYPEDSIGNATURES)
Plot potential energy in `datafile` which contains columns named `time` and `potential`

## Keywords
$_common_keyword_figure
"""
function plot_energy_potential(datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy_potential(df; kw...)
end

"""
$(TYPEDSIGNATURES)
Plot energy data in `df` which contains columns named `time` and `energy`.
`kinetic` and `potential` columns are optional.

## Keywords
$_common_keyword_figure
$_common_keyword_log
$_common_keyword_energy
"""
function plot_energy(df::DataFrame;
                     uTime = u"Gyr",
                     uEnergy = u"Msun * kpc^2 / Gyr^2",
                     title = "Energy",
                     xlabel = "t$(axisunit(uTime))",
                     ylabel = "E$(axisunit(uEnergy))",
                     resolution = (1600, 900),
                     potential = true,
                     kinetic = true,
                     colorpotential = :red,
                     colorkinetic = :blue,
                     colortotal = :black,
                     kw...)
    scene, layout = layoutscene(; resolution)
    ax = layout[1,1] = GLMakie.Axis(scene; xlabel, ylabel, title)

    if !hasproperty(df, :energy) && hasproperty(df, :potential) && hasproperty(df, :kinetic)
        df.energy = df.potential + df.kinetic
    elseif hasproperty(df, :energy) && !hasproperty(df, :potential) && !hasproperty(df, :kinetic)
    elseif hasproperty(df, :energy) && hasproperty(df, :potential) && hasproperty(df, :kinetic)
    else
        error("Please output energy (or potential and kinetic energy) in datafile")
    end

    p1 = plot_energy!(ax, df; color = colortotal, kw...)
    p = [p1]
    names = ["total energy"]
    
    if potential
        if !(hasproperty(df, :potential))
            @warn "There is no potential energy data in datafile"
        else
            p2 = plot_energy_potential!(ax, df; color = colorpotential, kw...)
            push!(p, p2)
            push!(names, "potential energy")
        end
    end

    if kinetic
        if !(hasproperty(df, :kinetic))
            @warn "There is no kinetic energy data in datafile"
        else
            p3 = plot_energy_kinetic!(ax, df; color = colorkinetic, kw...)
            push!(p, p3)
            push!(names, "kinetic energy")
        end
    end

    if length(p) > 1
        leg = layout[1,2] = Legend(scene, p, names)
    end

    return scene, layout, df
end

"""
$(TYPEDSIGNATURES)
Plot energy (last one minus previous one) in `datafile` which is a
`CSV` file containing columns named `time` and `energy`. `kinetic` and `potential` columns are optional.

## Arguments
$_common_argument_snapshot

# Keywords
$_common_keyword_snapshot
$_common_keyword_figure
$_common_keyword_log
$_common_keyword_energy
"""
function plot_energy(datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy(df; kw...)
end

function energy_delta(df::DataFrame)
    time = @view df.time[2:end]
    E0 = @view df.energy[1:end-1]
    E1 = @view df.energy[2:end]
    #TODO: divide by E0?
    dE = E1 .- E0
    return time, dE
end

"""
$(TYPEDSIGNATURES)
Compute and plot delta energy in `df` which contains columns named `time` and `energy`

## Keywords
$_common_keyword_figure
"""
function plot_energy_delta!(ax, df::DataFrame;
                            kw...)
    if !hasproperty(df, :energy) && hasproperty(df, :potential) && hasproperty(df, :kinetic)
        df.energy = df.potential + df.kinetic
    elseif hasproperty(df, :energy) && !hasproperty(df, :potential) && !hasproperty(df, :kinetic)
    elseif hasproperty(df, :energy) && hasproperty(df, :potential) && hasproperty(df, :kinetic)
    else
        error("Please output energy (or potential and kinetic energy) in file $datafile")
    end
    time, dE = energy_delta(df)
    Makie.lines!(ax, time, dE; kw...)
end

"""
$(TYPEDSIGNATURES)
Plot delta energy (last one minus previous one) in `datafile` which is a
`CSV` file containing columns named `time` and `energy`
"""
function plot_energy_delta!(ax, datafile::String;
                            kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy_delta!(ax, df; kw...)
end

"""
$(TYPEDSIGNATURES)
Compute and plot delta energy in `df` which contains columns named `time` and `energy`

## Keywords
$_common_keyword_figure
"""
function plot_energy_delta(df::DataFrame;
                           uTime = u"Gyr",
                           uEnergy = u"Msun * kpc^2 / Gyr^2",
                           title = "Delta Energy",
                           xlabel = "t$(axisunit(uTime))",
                           ylabel = "dE$(axisunit(uEnergy))",
                           resolution = (1600, 900),
                           kw...)
    scene, layout = layoutscene(; resolution)
    ax = layout[1,1] = GLMakie.Axis(scene; xlabel, ylabel, title)
    plot_energy_delta!(ax, df; kw...)
    return scene, layout, df
end

"""
$(TYPEDSIGNATURES)
Plot delta energy (last one minus previous one) in `datafile` which is a
`CSV` file containing columns named `time` and `energy`

## Keywords
$_common_keyword_figure
"""
function plot_energy_delta(datafile::String; kw...)
    df = DataFrame(CSV.File(datafile))
    plot_energy_delta(df; kw...)
end

"""
$(TYPEDSIGNATURES)
Compute kinetic energy of a particle using the equation:
    0.5 * Mass * Vel^2
"""
function kinetic_energy(p::AbstractParticle)
    return 0.5 * p.Mass * p.Vel * p.Vel
end

"""
$(TYPEDSIGNATURES)
Sum kinetic energy (0.5 * Mass * Vel^2) of particles in `data`.
"""
function sum_kinetic(data::Array)
    k = map(d -> kinetic_energy(d), data)
    return sum(k)
end

function sum_kinetic(data::StructArray)
    s = similar(data.Potential) .* zero(data.Mass[1])
    block = ceil(Int64, length(data) / Threads.nthreads())
    Threads.@threads for k in 1:Threads.nthreads()
        if k > length(s)
            continue
        end

        Head = block * (k-1) + 1
        Tail = block * k
        if k == Threads.nthreads()
            Tail = length(data)
        end

        for i in Head:Tail
            @inbounds s[i] = 0.5 * data.Mass[i] * data.Vel[i] * data.Vel[i]
        end
    end
    return sum(s)
end

"""
$(TYPEDSIGNATURES)
Sum potential energy of particles in `data`. Potentials need to be computed in advance.
"""
function sum_potential(data::Array)
    return sum([p.Potential * p.Mass for p in data])
end

"$(TYPEDSIGNATURES)"
function sum_potential(data::StructArray)
    return sum(data.Potential .* data.Mass)
end

"""
$(TYPEDSIGNATURES)
Compute kinetic energy and sum potential energy of particles in each snapshot.
Return a Tuple of `scene` and `layout`

## Arguments
$_common_argument_snapshot

## Keywords
$_common_keyword_snapshot
$_common_keyword_figure
$_common_keyword_log
$_common_keyword_energy
"""
function plot_energy(
    folder::String, filenamebase::String,
    Counts::Vector{Int64}, suffix::String,
    FileType::AbstractOutputType, units = uAstro, fileunits = uGadget2;
    times = Counts,
    savelog = true,
    savefolder = pwd(),
    formatstring = "%04d",
    potential = true,
    kinetic = true,
    kw...
)
    uTime = getuTime(units)
    uEnergy = getuEnergy(units)
    df = DataFrame(
        time = Float64[],
        kinetic = Float64[],
        potential = Float64[],
        total = Float64[],
    )
    
    progress = Progress(length(Counts), "Loading data and precessing: "; #=showspeed=true=#)
    for i in eachindex(Counts)
        snapshot_index = Printf.format(Printf.Format(formatstring), Counts[i])
        filename = joinpath(folder, string(filenamebase, snapshot_index, suffix))

        if FileType == gadget2()
            header, data = read_gadget2(filename, units, fileunits, pot = true)
        elseif FileType == jld2()
            data = read_jld(filename)
        end

        KE = sum_kinetic(data)
        PE = sum_potential(data)
        push!(df, [
            ustrip(uTime, times[i]),
            ustrip.(uEnergy, [KE, PE, KE + PE])...
        ])

        next!(progress, showvalues = [
            ("iter", i),
            ("time", times[i]),
            ("file", filename),
            ("kinetic energy", KE),
            ("potential energy", PE),
            ("total energy", KE + PE),
        ])
    end

    if savelog
        outputfile = joinpath(savefolder, "energy.csv")
        CSV.write(outputfile, df)
        println("Energy data saved to ", outputfile)
    end

    if iszero(sum(df.potential))
        @warn "Total potential is zero! Check your output settings."
    end

    println("Plotting energy")
    return plot_energy(df; uTime, uEnergy, potential, kinetic, kw...)
end