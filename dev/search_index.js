var documenterSearchIndex = {"docs":
[{"location":"manual/tree/#Plot-trees","page":"Plot trees","title":"Plot trees","text":"","category":"section"},{"location":"manual/tree/","page":"Plot trees","title":"Plot trees","text":"using AstroPlot, PhysicalTrees, PhysicalParticles\nplot_peano()","category":"page"},{"location":"manual/tree/","page":"Plot trees","title":"Plot trees","text":"plot_peano(2)","category":"page"},{"location":"manual/tree/","page":"Plot trees","title":"Plot trees","text":"plot_peano(3)","category":"page"},{"location":"manual/tree/","page":"Plot trees","title":"Plot trees","text":"d = randn_pvector(15)\nt = octree(d)\nfigure, axis, plot = plot_makie(t)\nfigure","category":"page"},{"location":"manual/snapshots/#Plot-snapshots","page":"Plot snapshots","title":"Plot snapshots","text":"","category":"section"},{"location":"manual/snapshots/","page":"Plot snapshots","title":"Plot snapshots","text":"using AstroPlot\nplot_positionslice(\"mosaic/\", \"snapshot_\", collect(0:100), \".gadget2\", gadget2(),\n    dpi = 300, resolution = (800,800),\n    xlims = (-0.06, +0.06), ylims = (-0.06, +0.06),\n    times = collect(0.0:0.00005:0.005) * u\"Gyr\",\n    markersize = 5.0,\n)","category":"page"},{"location":"manual/snapshots/","page":"Plot snapshots","title":"Plot snapshots","text":"scene, layout = plot_trajectory(\n    \"plummer/\", \"snapshot_\", collect(0:20:200), [1,2,3], \".gadget2\", gadget2(),\n)\nscene","category":"page"},{"location":"manual/snapshots/","page":"Plot snapshots","title":"Plot snapshots","text":"ScaleScene, ScaleLayout, LagrangeScene, LagrangeLayout, df = plot_radii(\n    \"plummer/\", \"snapshot_\", collect(0:20:200), \".gadget2\", gadget2(),\n    times = collect(0.0:0.01:0.1) * u\"Gyr\", title = \"Direct Sum const\",\n)\nScaleScene","category":"page"},{"location":"manual/snapshots/","page":"Plot snapshots","title":"Plot snapshots","text":"LagrangeScene","category":"page"},{"location":"lib/Methods/#Methods","page":"Methods","title":"Methods","text":"","category":"section"},{"location":"lib/Methods/#Index","page":"Methods","title":"Index","text":"","category":"section"},{"location":"lib/Methods/","page":"Methods","title":"Methods","text":"Pages = [\"Methods.md\"]","category":"page"},{"location":"lib/Methods/#UnicodePlots","page":"Methods","title":"UnicodePlots","text":"","category":"section"},{"location":"lib/Methods/","page":"Methods","title":"Methods","text":"unicode_scatter\nunicode_density\nunicode_force\nunicode_radialforce\nunicode_radialpotential\nunicode_rotationcurve\nunicode_projection\nunicode_projection_density\nunicode_slice","category":"page"},{"location":"lib/Methods/#AstroPlot.unicode_scatter","page":"Methods","title":"AstroPlot.unicode_scatter","text":"function unicode_scatter(data::Array{T, N}, u::Union{Nothing, Unitful.FreeUnits} = u\"kpc\"; kw...) where T<:AbstractPoint where N\nfunction unicode_scatter(data::Array{T, N}, u::Union{Nothing, Unitful.FreeUnits} = u\"kpc\"; kw...) where T<:AbstractParticle where N\nfunction unicode_scatter(data::StructArray{T,N,NT,Tu}, u::Union{Nothing, Unitful.FreeUnits} = u\"kpc\"; kw...) where T<:AbstractParticle where N where NT where Tu\nfunction unicode_scatter(data::Union{Array{T,N}, StructArray{T,N,NT,Tu}}, collection::Collection, u::Union{Nothing, Unitful.FreeUnits} = u\"kpc\"; kw...) where T<:AbstractParticle where N where NT where Tu\n\nScatter plot of points or particles in REPL\n\ncollection: filter the type of particles\n\nKeywords\n\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\n\nExamples\n\njulia> unicode_scatter(randn_pvector(100))\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.unicode_density","page":"Methods","title":"AstroPlot.unicode_density","text":"function unicode_density(data, units = uAstro; kw...)\n\nPlot radial mass density curve of spherically symmetric system in REPL\n\nKeywords\n\nxlabel: label of x-axis\nylabel: label of y-axis\ntitle: title line of the figure\ntimestamp: print time on figure title\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.unicode_force","page":"Methods","title":"AstroPlot.unicode_force","text":"unicode_force(data, units = uAstro; kw...)\n\nPlot acceleration magnitude distribution of spherically symmetric system in REPL\n\nKeywords\n\nxlabel: label of x-axis\nylabel: label of y-axis\ntitle: title line of the figure\ntimestamp: print time on figure title\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.unicode_radialforce","page":"Methods","title":"AstroPlot.unicode_radialforce","text":"unicode_radialforce(data, units = uAstro; kw...)\n\nPlot radial acceleration magnitude relative to center in REPL\n\nKeywords\n\nxlabel: label of x-axis\nylabel: label of y-axis\ntitle: title line of the figure\ntimestamp: print time on figure title\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.unicode_rotationcurve","page":"Methods","title":"AstroPlot.unicode_rotationcurve","text":"function unicode_rotationcurve(data, units = uAstro; kw...)\n\nPlot rotation curve in REPL\n\nKeywords\n\nrmhead: remove the first rmhead elements of result array. Useful to avoid improper data points\nrmtail: remove the last rmtail elements of result array. Useful to avoid improper data points\nsavelog::Bool: if true, save processed data in csv. The name of log file depends on analysis function\nsavefolder: set the directory to save log file\nsection::Int64: number of bins. Default is floor(Int64, length(data)^0.5833333333333334)\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.unicode_projection","page":"Methods","title":"AstroPlot.unicode_projection","text":"function unicode_projection(ρ; kw...)\n\nPlot 2D projection sum over one dimension.\n\nKeywords\n\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\ntitle: title line of the figure\ncolormap = :inferno: color map of heatmap plot\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.unicode_projection_density","page":"Methods","title":"AstroPlot.unicode_projection_density","text":"function unicode_projection_density(mesh::MeshCartesianStatic; kw...)\n\nPlot 2D projection sum of mesh density over one dimension.\n\nKeywords\n\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\ntitle: title line of the figure\ncolormap = :inferno: color map of heatmap plot\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.unicode_slice","page":"Methods","title":"AstroPlot.unicode_slice","text":"function unicode_slice(data::AbstractArray{T,3}, n::Int; kw...)\n\nPlot 2D slice of a 3D array. Vector plot is not supported in unicode mode.\n\nKeywords\n\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\ncolormap = :inferno: color map of heatmap plot\n\n\n\n\n\nfunction unicode_slice(mesh::MeshCartesianStatic, symbol::Symbol, n::Int;\n\nPlot 2D slice of 3D data symbol in mesh.\n\nKeywords\n\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\ncolormap = :inferno: color map of heatmap plot\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#GLMakie","page":"Methods","title":"GLMakie","text":"","category":"section"},{"location":"lib/Methods/","page":"Methods","title":"Methods","text":"plot_makie\nplot_makie!\nplot_peano","category":"page"},{"location":"lib/Methods/#AstroPlot.plot_makie","page":"Methods","title":"AstroPlot.plot_makie","text":"plot_makie(data::Array{T,1}, u::Union{Nothing, Unitful.FreeUnits} = u\"kpc\"; kw...) where T<:PVector\nplot_makie(data::Array{T,1}, u::Union{Nothing, Unitful.FreeUnits} = u\"kpc\"; kw...) where T<:AbstractParticle3D\nplot_makie(data::StructArray, u::Union{Nothing, Unitful.FreeUnits} = u\"kpc\"; kw...)\nplot_makie(data::Union{Array{T,N}, StructArray{T,N,NT,Tu}}, collection::Collection, u::Union{Nothing, Unitful.FreeUnits} = u\"kpc\"; kw...) where T<:AbstractParticle3D where N where NT where Tu\n\nPlot scatter data points (in interactive mode)\n\ncollection: filter the type of particles\n\nExamples\n\nd = randn_pvector(50)\nplot_makie(d, nothing)\n\nd = randn_pvector(50, u\"km\")\nplot_makie(d, u\"m\")\n\n\n\n\n\nplot_makie(nodes::Array{T,N}; kw...) where T<:PhysicalTrees.OctreeNode where N\n\nPlot tree nodes in wireframe mode\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.plot_makie!","page":"Methods","title":"AstroPlot.plot_makie!","text":"plot_makie!(scene, data::Array{T,1}, where T<:AbstractParticle3D where N where NT where Tu u\"kpc\"; kw...) where T<:PVector\nplot_makie!(scene, data::Array{T,1}, where T<:AbstractParticle3D where N where NT where Tu u\"kpc\"; kw...) where T<:AbstractParticle3D\nplot_makie!(scene, data::StructArray, where T<:AbstractParticle3D where N where NT where Tu u\"kpc\"; kw...)\nplot_makie!(scene, data::Union{Array{T,N}, StructArray{T,N,NT,Tu}}, collection::Collection, u::Union{Nothing, Unitful.FreeUnits} = u\"kpc\"; kw...) where T<:AbstractParticle3D where N where NT where Tu\n\nPlot scatter data points (in interactive mode)\n\ncollection: filter the type of particles\n\nExamples\n\nd = randn_pvector(50)\nplot_makie!(scene, d, nothing)\n\nd = randn_pvector(50, u\"km\")\nplot_makie!(scene, d, u\"m\")\n\n\n\n\n\nplot_makie!(axis, nodes::Array{T,N}; kw...) where T<:PhysicalTrees.OctreeNode where N\n\nPlot tree nodes in wireframe mode\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.plot_peano","page":"Methods","title":"AstroPlot.plot_peano","text":"plot_peano(bits::Int = 1)\n\nInteractively plot Hilber-Peano curve with Makie. It is recommanded that bits <= 6 to avoid lagging problems.\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#CairoMakie","page":"Methods","title":"CairoMakie","text":"","category":"section"},{"location":"lib/Methods/","page":"Methods","title":"Methods","text":"projection\nprojection_density\nplot_slice","category":"page"},{"location":"lib/Methods/#AstroPlot.projection_density","page":"Methods","title":"AstroPlot.projection_density","text":"function projection_density(mesh::MeshCartesianStatic; kw...)\n\nPlot 2D projection sum of mesh density over one dimension.\n\nKeywords\n\naspect_ratio: aspect ratio of axes. Default is 1.0 to avoid stretching. Pass to Makie as AxisAspect(aspect_ratio)\nresolution: figure size\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\ntitle: title line of the figure\nxlims: set x-limit of the plot. Default is nothing\nylims: set y-limit of the plot. Default is nothing\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.plot_slice","page":"Methods","title":"AstroPlot.plot_slice","text":"function plot_slice(mesh::MeshCartesianStatic, symbol::Symbol, n::Int;\n\nPlot 2D slice of 3D data symbol in mesh.\n\nKeywords\n\nresolution: figure size\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\ntitle: title line of the figure\nxlims: set x-limit of the plot. Default is nothing\nylims: set y-limit of the plot. Default is nothing\naspect_ratio: aspect ratio of axes. Default is 1.0 to avoid stretching. Pass to Makie as AxisAspect(aspect_ratio)\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#Video","page":"Methods","title":"Video","text":"","category":"section"},{"location":"lib/Methods/","page":"Methods","title":"Methods","text":"png2video\nmosaicview","category":"page"},{"location":"lib/Methods/#AstroPlot.png2video","page":"Methods","title":"AstroPlot.png2video","text":"function png2video(dir::String, filenamebase::String, suffix::String, outfile::String; kw...)\n\nConvert all figure end with suffix to video. Filenames are organized as filenamebase0000suffix. For png files like pos_0000.png, set filenamebase = \"pos_\" and suffix = \".png\"\n\nIt basically calls VideoIO.open_video_out\n\nKeywords\n\nencoder_options: keywords supported by FFMPEG. Default value (crf=23, preset=\"medium\") is suitable for most cases\nframerate: fps (frame per second). Default 24\ncodec_name: name of video encoder. Default nothing. Try libx264, libx265, libx264rgb and more options in FFMPEG\n\nExamples\n\njulia> png2video(\"output\", \"pos_\", \".png\", \"test.mp4\")\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#MosaicViews.mosaicview","page":"Methods","title":"MosaicViews.mosaicview","text":"function mosaicview(folder::String, filenamebase::String, Counts::Array, suffix::String; kw...)\n\nArguments\n\nfolder: directory holding snapshots\nfilenamebase, Counts, suffix:   snapshots are commonly named as snapshot_0000.gadget2, in this way filenamebase = \"snapshot_\", suffix = \".gadget2.   Counts is an array to choose snapshots, and it is printed to formatted string (controled by keyword formatstring) in for loops.\n\nExamples\n\njulia> mosaicview(\"output\", \"pos_\", collect(0:10:490), \".png\"; fillvalue=0.5, npad=5, ncol=10, rowmajor=true)\n\n\n\n\n\nfunction mosaicview(folder::String, filenamebase::String, suffix::String; kw...)\n\nPlot all files matching filenamebase and suffix in folder to mosaic view.\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#Tools","page":"Methods","title":"Tools","text":"","category":"section"},{"location":"lib/Methods/#Analysis","page":"Methods","title":"Analysis","text":"","category":"section"},{"location":"lib/Methods/","page":"Methods","title":"Methods","text":"rotationcurve\ndensitycurve\nrotvel\nradialvel\nforce\nradialforce\nradialpotential\ndistribution\npos_from_center\nlagrange_radii","category":"page"},{"location":"lib/Methods/#AstroPlot.rotationcurve","page":"Methods","title":"AstroPlot.rotationcurve","text":"function rotationcurve(data, units = uAstro; kw...)\n\nReturn Tuple(Rmean, Vmean, Rstd, Vstd), where mean is mean value, std means standard deviation.\n\nKeywords\n\nrmhead: remove the first rmhead elements of result array. Useful to avoid improper data points\nrmtail: remove the last rmtail elements of result array. Useful to avoid improper data points\nsavelog::Bool: if true, save processed data in csv. The name of log file depends on analysis function\nsavefolder: set the directory to save log file\nsection::Int64: number of bins. Default is floor(Int64, length(data)^0.5833333333333334)\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.densitycurve","page":"Methods","title":"AstroPlot.densitycurve","text":"function densitycurve(data, units = uAstro; kw...)\n\nCompute radial mass density curve of spherically symmetric system\n\nKeywords\n\nsavelog::Bool: if true, save processed data in csv. The name of log file depends on analysis function\nsavefolder: set the directory to save log file\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.rotvel","page":"Methods","title":"AstroPlot.rotvel","text":"rotvel(vel::PVector, pos::PVector)\n\nRotational velocity magnitude at pos relative to origin.\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.radialvel","page":"Methods","title":"AstroPlot.radialvel","text":"radialvel(vel::PVector, pos::PVector)\n\nRadial velocity magnitude at pos relative to origin.\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.force","page":"Methods","title":"AstroPlot.force","text":"force(data, units = uAstro; kw...)\n\nCompute acceleration magnitude distribution of spherically symmetric system\n\nKeywords\n\nsavelog::Bool: if true, save processed data in csv. The name of log file depends on analysis function\nsavefolder: set the directory to save log file\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.radialforce","page":"Methods","title":"AstroPlot.radialforce","text":"radialforce(a0, acc, p0, pos)\n\nCompute radial acceleration magnitude relative to center p0\n\n\n\n\n\nradialforce(data, units = uAstro; kw...)\n\nCompute radial acceleration magnitude relative to center\n\nKeywords\n\nsavelog::Bool: if true, save processed data in csv. The name of log file depends on analysis function\nsavefolder: set the directory to save log file\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.distribution","page":"Methods","title":"AstroPlot.distribution","text":"function distribution(x::Array, y::Array; kw...)\n\nCompute how quantity y is distributed along x. For example, rotation velocity along radius. Return Tuple(xmean, ymean, xstd, ystd), where mean is mean value, std means standard deviation.\n\nKeywords\n\nsection::Int64: number of bins. Default is floor(Int64, length(data)^0.5833333333333334)\nrmhead: remove the first rmhead elements of result array. Useful to avoid improper data points\nrmtail: remove the last rmtail elements of result array. Useful to avoid improper data points\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.pos_from_center","page":"Methods","title":"AstroPlot.pos_from_center","text":"function pos_from_center(particles, u = u\"kpc\")\nfunction pos_from_center(pos::Array{T,1}, u = u\"kpc\") where T <: AbstractPoint\n\nReturn a unitless array of positions relative to the center.\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.lagrange_radii","page":"Methods","title":"AstroPlot.lagrange_radii","text":"function lagrange_radii(data, u = u\"kpc\")\n\nReturn a Tuple of scale radius and Lagrange radii. Designed for spherically symmetric systems.\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#Data-processing","page":"Methods","title":"Data processing","text":"","category":"section"},{"location":"lib/Methods/","page":"Methods","title":"Methods","text":"pack_xy\nsortarrays!\npos_from_center","category":"page"},{"location":"lib/Methods/#AstroPlot.pack_xy","page":"Methods","title":"AstroPlot.pack_xy","text":"function pack_xy(data, u = nothing; kw...)\n\nReturn Tuple (x,y) substracted from points or positions of particles in data. Useful to prepare a plot.\n\nKeywords\n\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.sortarrays!","page":"Methods","title":"AstroPlot.sortarrays!","text":"function sortarrays!(by::Array, another::Array; kw...)\n\nSort two arrays at the same time. kw is passed to Base.sort!.\n\nExamples\n\njulia> a = [1,3,2]\njulia> b = [\"a\", \"b\", \"c\"]\njulia> sortarrays!(a,b)\njulia> a\n3-element Vector{Int64}:\n 1\n 2\n 3\n\njulia> b\n3-element Vector{String}:\n \"a\"\n \"c\"\n \"b\"\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#Meshes","page":"Methods","title":"Meshes","text":"","category":"section"},{"location":"lib/Methods/","page":"Methods","title":"Methods","text":"axisid\naxis_cartesian\nslice3d","category":"page"},{"location":"lib/Methods/#AstroPlot.axisid","page":"Methods","title":"AstroPlot.axisid","text":"function axisid(axis::Symbol)\n\nConvert axis to Int\n\nreturn 1 if axis == :x\nreturn 2 if axis == :y\nreturn 3 if axis == :z\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.axis_cartesian","page":"Methods","title":"AstroPlot.axis_cartesian","text":"function axis_cartesian(pos::StructArray, axis::Symbol)\nfunction axis_cartesian(mesh::MeshCartesianStatic, axis::Symbol)\n\nReturn 1D axis points of 3D Cartesian positions.\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#energy-evolution","page":"Methods","title":"energy evolution","text":"","category":"section"},{"location":"lib/Methods/","page":"Methods","title":"Methods","text":"plot_energy\nplot_energy_kinetic\nplot_energy_potential\nplot_energy_delta\nplot_energy_delta!\nkinetic_energy\nsum_kinetic\nsum_potential","category":"page"},{"location":"lib/Methods/#momentum-evolution","page":"Methods","title":"momentum evolution","text":"","category":"section"},{"location":"lib/Methods/","page":"Methods","title":"Methods","text":"plot_momentum\nplot_momentum_angular","category":"page"},{"location":"lib/Methods/#AstroPlot.plot_momentum","page":"Methods","title":"AstroPlot.plot_momentum","text":"plot_momentum(df::DataFrame; kw...)\n\nPlot total momentum in df which contains columns named time and momentum\n\nKeywords\n\nresolution: figure size\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\ntitle: title line of the figure\nxlims: set x-limit of the plot. Default is nothing\nylims: set y-limit of the plot. Default is nothing\n\n\n\n\n\nplot_momentum(datafile::String; kw...)\n\nPlot total momentum in datafile which is a CSV file containing columns named time and momentum\n\nKeywords\n\nresolution: figure size\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\ntitle: title line of the figure\nxlims: set x-limit of the plot. Default is nothing\nylims: set y-limit of the plot. Default is nothing\n\n\n\n\n\nplot_momentum(folder::String, filenamebase::String, Counts::Vector{Int64}, suffix::String, FileType::AbstractOutputType, units = uAstro, fileunits = uGadget2; kw...)\n\nPlot total momentum and total angular momentum of particles in each snapshot.\n\nArguments\n\nfolder: directory holding snapshots\nfilenamebase, Counts, suffix:   snapshots are commonly named as snapshot_0000.gadget2, in this way filenamebase = \"snapshot_\", suffix = \".gadget2.   Counts is an array to choose snapshots, and it is printed to formatted string (controled by keyword formatstring) in for loops.\ntimes: set time label of each snapshot\nFileType: Trait argument to dispatch on different snapshot format. It is to be set manually because some output types cannot be deduced automatically\nu = u\"kpc\": length unit. Set u as nothing in unitless cases.\n\nKeywords\n\nformatstring: formatted string to control snapshot index. Default is \"%04d\"\nresolution: figure size\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\ntitle: title line of the figure\nxlims: set x-limit of the plot. Default is nothing\nylims: set y-limit of the plot. Default is nothing\nsavelog::Bool: if true, save processed data in csv. The name of log file depends on analysis function\nsavefolder: set the directory to save log file\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.plot_momentum_angular","page":"Methods","title":"AstroPlot.plot_momentum_angular","text":"plotmomentumangular(df::DataFrame; kw...)\n\nPlot total angular momentum in df which contains columns named time and angularmomentum\n\nKeywords\n\nresolution: figure size\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\ntitle: title line of the figure\nxlims: set x-limit of the plot. Default is nothing\nylims: set y-limit of the plot. Default is nothing\n\n\n\n\n\nplot_momentum_angular(datafile::String; kw...)\n\nPlot total angular momentum in datafile which is a CSV file containing columns named time and angularmomentum\n\nKeywords\n\nresolution: figure size\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\ntitle: title line of the figure\nxlims: set x-limit of the plot. Default is nothing\nylims: set y-limit of the plot. Default is nothing\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#radii-evolution","page":"Methods","title":"radii evolution","text":"","category":"section"},{"location":"lib/Methods/","page":"Methods","title":"Methods","text":"plot_scaleradius\nplot_lagrangeradii\nplot_lagrangeradii!\nplot_lagrangeradii90\nplot_lagrangeradii90!\nplot_radii\nplot_radii!","category":"page"},{"location":"lib/Methods/#AstroPlot.plot_scaleradius","page":"Methods","title":"AstroPlot.plot_scaleradius","text":"function plot_scaleradius(df::DataFrame, uTime::Units, uLength::Units; kw...)\n\nPlot evolution of scale radius by time. df contains columns named Time and ScaleRadius\n\nReturn a Tuple of scene and layout\n\nKeywords\n\nxlabel: label of x-axis\nylabel: label of y-axis\ntitle: title line of the figure\nresolution: figure size\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.plot_lagrangeradii","page":"Methods","title":"AstroPlot.plot_lagrangeradii","text":"function plot_lagrangeradii(df::DataFrame, uTime::Units, uLength::Units; kw...)\n\nPlot evolution of Lagrange radii by time. df contains columns named Time and L10, L20, ..., L100\n\nReturn a Tuple of scene and layout\n\nKeywords\n\ntitle: title line of the figure\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.plot_lagrangeradii!","page":"Methods","title":"AstroPlot.plot_lagrangeradii!","text":"function plot_lagrangeradii!(scene, ax, layout, df::DataFrame; kw...)\n\nPlot evolution of Lagrange radii by time. df contains columns named Time and L10, L20, ..., L100\n\nReturn a Tuple of scenes and layouts of different line plots\n\nKeywords\n\ntitle: title line of the figure\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.plot_lagrangeradii90","page":"Methods","title":"AstroPlot.plot_lagrangeradii90","text":"function plot_lagrangeradii90(df::DataFrame, uTime::Units, uLength::Units; kw...)\n\nPlot evolution of Lagrange radii by time. df contains columns named Time and L10, L20, ..., L90 L100 is omitted, because in most cases, those escaping particles may over distort the figure.\n\nReturn a Tuple of scene and layout\n\nKeywords\n\ntitle: title line of the figure\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.plot_lagrangeradii90!","page":"Methods","title":"AstroPlot.plot_lagrangeradii90!","text":"function plot_lagrangeradii90!(scene, ax, layout, df::DataFrame; kw...)\n\nPlot evolution of Lagrange radii by time. df contains columns named Time and L10, L20, ..., L90 L100 is omitted, because in most cases, those escaping particles may over distort the figure.\n\nReturn a Tuple of scenes and layouts of different line plots\n\nKeywords\n\ntitle: title line of the figure\nxaxis: Symbol to plot on x-axis. Default is :x\nyaxis: Symbol to plot on y-axis. Defualt is :y\nxlabel: label of x-axis\nylabel: label of y-axis\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.plot_radii","page":"Methods","title":"AstroPlot.plot_radii","text":"function plot_radii(folder::String, filenamebase::String, Counts::Array{Int64,1}, suffix::String, FileType::AbstractOutputType, units = uAstro; kw...)\n\nPlot scale radius and Lagrange radii (up to 90% by default)\n\nReturn Tuple(ScaleScene, ScaleLayout, LagrangeScene, LagrangeLayout, df). df contains radii data\n\nArguments\n\nfolder: directory holding snapshots\nfilenamebase, Counts, suffix:   snapshots are commonly named as snapshot_0000.gadget2, in this way filenamebase = \"snapshot_\", suffix = \".gadget2.   Counts is an array to choose snapshots, and it is printed to formatted string (controled by keyword formatstring) in for loops.\ntimes: set time label of each snapshot\nFileType: Trait argument to dispatch on different snapshot format. It is to be set manually because some output types cannot be deduced automatically\nu = u\"kpc\": length unit. Set u as nothing in unitless cases.\n\nKeywords\n\nformatstring: formatted string to control snapshot index. Default is \"%04d\"\n\nExamples\n\njulia> ScaleScene, ScaleLayout, LagrangeScene, LagrangeLayout, df = plotradii(     joinpath(pathof(AstroPlot), \"../../test/snapshots\"), \"snapshot\", collect(0:20:200), \".gadget2\", gadget2(),     times = collect(0.0:0.01:0.1) * u\"Gyr\", title = \"Radii plot\")\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#AstroPlot.plot_radii!","page":"Methods","title":"AstroPlot.plot_radii!","text":"function plot_radii(AS, SL, AL, LL, folder::String, filenamebase::String, Counts::Array{Int64,1}, suffix::String, FileType::AbstractOutputType, units = uAstro; kw...)\n\nPlot scale radius and Lagrange radii (up to 90% by default) Return radii data in Dict\n\nArguments\n\nAS: Axis of scale radius scene\nSL: Lagrange radii scene\nAL: Axis of Lagrange radii scene\nLL: layout of Lagrange radii scene\nfolder: directory holding snapshots\nfilenamebase, Counts, suffix:   snapshots are commonly named as snapshot_0000.gadget2, in this way filenamebase = \"snapshot_\", suffix = \".gadget2.   Counts is an array to choose snapshots, and it is printed to formatted string (controled by keyword formatstring) in for loops.\ntimes: set time label of each snapshot\nFileType: Trait argument to dispatch on different snapshot format. It is to be set manually because some output types cannot be deduced automatically\nu = u\"kpc\": length unit. Set u as nothing in unitless cases.\n\nKeywords\n\nformatstring: formatted string to control snapshot index. Default is \"%04d\"\n\nExamples\n\njulia> ScaleScene, ScaleLayout, LagrangeScene, LagrangeLayout, df = plotradii(     joinpath(pathof(AstroPlot), \"../../test/snapshots\"), \"snapshot\", collect(0:20:200), \".gadget2\", gadget2(),     times = collect(0.0:0.01:0.1) * u\"Gyr\", title = \"Radii plot\")\n\n\n\n\n\n","category":"function"},{"location":"lib/Methods/#force-distribution","page":"Methods","title":"force distribution","text":"","category":"section"},{"location":"lib/Methods/","page":"Methods","title":"Methods","text":"plot_force\nplot_force!","category":"page"},{"location":"lib/Methods/#density-distribution","page":"Methods","title":"density distribution","text":"","category":"section"},{"location":"lib/Methods/","page":"Methods","title":"Methods","text":"plot_density\nplot_density!","category":"page"},{"location":"manual/analyse/#Analysis","page":"Analysis","title":"Analysis","text":"","category":"section"},{"location":"manual/analyse/","page":"Analysis","title":"Analysis","text":"using AstroPlot\nscene, layout = plot_profiling(\"profiling.csv\")\nscene","category":"page"},{"location":"manual/analyse/","page":"Analysis","title":"Analysis","text":"scene, layout = plot_energy(\"energy.csv\")\nscene","category":"page"},{"location":"manual/analyse/","page":"Analysis","title":"Analysis","text":"scene, layout = plot_energy_delta(\"energy.csv\")\nscene","category":"page"},{"location":"manual/analyse/","page":"Analysis","title":"Analysis","text":"using AstroIO\nheader, data = read_gadget2(\"plummer/snapshot_0000.gadget2\", uAstro, uGadget2)\n\nscene, layout = plot_densitycurve(data)\nscene","category":"page"},{"location":"manual/analyse/","page":"Analysis","title":"Analysis","text":"scene, layout = plot_rotationcurve(data)\nscene","category":"page"},{"location":"manual/guide/#Package-Guide","page":"Package Guide","title":"Package Guide","text":"","category":"section"},{"location":"manual/guide/","page":"Package Guide","title":"Package Guide","text":"AstroPlot.jl is useful for particle based scientific simulations","category":"page"},{"location":"manual/guide/#Installation","page":"Package Guide","title":"Installation","text":"","category":"section"},{"location":"manual/guide/","page":"Package Guide","title":"Package Guide","text":"From the Julia REPL, type ] to enter the Pkg REPL mode and run","category":"page"},{"location":"manual/guide/","page":"Package Guide","title":"Package Guide","text":"pkg> add AstroPlot","category":"page"},{"location":"manual/guide/","page":"Package Guide","title":"Package Guide","text":"or add from git repository","category":"page"},{"location":"manual/guide/","page":"Package Guide","title":"Package Guide","text":"pkg> add https://github.com/JuliaAstroSim/AstroPlot.jl","category":"page"},{"location":"manual/guide/","page":"Package Guide","title":"Package Guide","text":"Test the package by","category":"page"},{"location":"manual/guide/","page":"Package Guide","title":"Package Guide","text":"pkg> test AstroPlot","category":"page"},{"location":"manual/guide/#Basic-Usage","page":"Package Guide","title":"Basic Usage","text":"","category":"section"},{"location":"manual/mesh/#Plot-meshes","page":"Plot meshes","title":"Plot meshes","text":"","category":"section"},{"location":"manual/mesh/#Cube","page":"Plot meshes","title":"Cube","text":"","category":"section"},{"location":"manual/mesh/","page":"Plot meshes","title":"Plot meshes","text":"using PhysicalMeshes\nusing AstroPlot\n\nc = Cube(PVector(0.0,0.0,0.0), PVector(1.0,1.0,1.0))\nscene = plot_makie(c, nothing)","category":"page"},{"location":"manual/mesh/#Static-Cartesian-Mesh","page":"Plot meshes","title":"Static Cartesian Mesh","text":"","category":"section"},{"location":"manual/mesh/","page":"Plot meshes","title":"Plot meshes","text":"using AstroIO\nh, d = read_gadget2(\"plummer_unitless.gadget2\", nothing, uGadget2)\n\nm = MeshCartesianStatic(d)\nunicode_projection_density(m)","category":"page"},{"location":"manual/mesh/","page":"Plot meshes","title":"Plot meshes","text":"projection_density(m)","category":"page"},{"location":"manual/mesh/","page":"Plot meshes","title":"Plot meshes","text":"unicode_slice(m, :rho, 5)","category":"page"},{"location":"manual/mesh/","page":"Plot meshes","title":"Plot meshes","text":"plot_slice(m, :pos, 5)","category":"page"},{"location":"#AstroPlot.jl","page":"Home","title":"AstroPlot.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Ready-to-use plotting tools for astrophysical simulation data","category":"page"},{"location":"#Package-Feature","page":"Home","title":"Package Feature","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Plot in the REPL\nInteractive & 3D visualization of data\nFast plot using OpenGL supported by Makie\nFull support of JuliaAstroSim ecosystem","category":"page"},{"location":"#Manual-Outline","page":"Home","title":"Manual Outline","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"manual/video/#Output-video","page":"Output video","title":"Output video","text":"","category":"section"},{"location":"manual/video/","page":"Output video","title":"Output video","text":"using AstroPlot\npng2video(\"mosaic\", \"pos_\", \".png\", \"TDE.mp4\")","category":"page"},{"location":"manual/mosaic/#Mosaic-view","page":"Mosaic view","title":"Mosaic view","text":"","category":"section"},{"location":"manual/mosaic/","page":"Mosaic view","title":"Mosaic view","text":"using AstroPlot\nmosaicview(\"mosaic\", \"pos_\", collect(1:9:100), \".png\"; fillvalue = 0.5, npad = 3, ncol = 4, rowmajor = true)","category":"page"}]
}