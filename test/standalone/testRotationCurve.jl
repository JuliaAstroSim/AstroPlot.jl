#include("AstroPlot.jl\\src\\AstroPlot.jl")
@info "loading"
include("../../src/AstroPlot.jl")

using Main.AstroPlot
using PhysicalParticles
using Unitful, UnitfulAstro

@info "generating data"
data = [Star(uAstro) for i in 1:500]
p = randn_pvector(500, u"kpc")
v = randn_pvector(500, u"kpc/Gyr")
m = rand(500) * u"Msun"

assign_particles(data, :Pos, p)
assign_particles(data, :Vel, v)
assign_particles(data, :Mass, m)

@info "Plotting"
unicode_rotationcurve(data)

plotrotationcurve(data)