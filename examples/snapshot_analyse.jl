using AstroPlot
using Unitful, UnitfulAstro

plot_positionslice(
    pwd(), "snapshot_", collect(0:150), gadget2(), 
    times = collect(0:0.001:0.15) * u"kpc",
    xlen = 0.2u"kpc", ylen = 0.2u"kpc",
)