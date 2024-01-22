_common_keyword_axis = """
- `xaxis`: `Symbol` to plot on x-axis. Default is `:x`
- `yaxis`: `Symbol` to plot on y-axis. Defualt is `:y`
"""

_common_keyword_label = """
- `xlabel`: label of x-axis
- `ylabel`: label of y-axis
"""

_common_keyword_axis_label = _common_keyword_axis * _common_keyword_label

_common_keyword_lims = """
- `xlims`: set x-limit of the plot. Default is `nothing`
- `ylims`: set y-limit of the plot. Default is `nothing`
"""

_common_keyword_title = "- `title`: title line of the figure\n"
_common_keyword_label_title = _common_keyword_label * _common_keyword_title
_common_keyword_axis_label_title = _common_keyword_axis * _common_keyword_label_title

_common_keyword_aspect = "- `aspect_ratio`: aspect ratio of axes. Default is `1.0` to avoid stretching. Pass to `Makie` as `AxisAspect(aspect_ratio)`\n"

_common_keyword_figure = """
- `size`: figure size
""" * _common_keyword_axis_label_title * _common_keyword_lims

_common_keyword_adapt_len = """
- `xlen::Float64`: box length at x-axis
- `ylne::Float64`: box length at y-axis
"""

_common_argument_snapshot = """
- `folder`: directory holding snapshots
- `filenamebase`, `Counts`, `suffix`:
    snapshots are commonly named as `snapshot_0000.gadget2`, in this way `filenamebase = "snapshot_"`, `suffix = ".gadget2`.
    `Counts` is an array to choose snapshots, and it is printed to formatted string (controled by keyword `formatstring`) in `for` loops.
- `times`: set time label of each snapshot
- `FileType`: Trait argument to dispatch on different snapshot format. It is to be set manually because some output types cannot be deduced automatically
- `u = u"kpc"`: length unit. Set `u` as `nothing` in unitless cases.
"""

_common_keyword_snapshot = """
- `formatstring`: formatted string to control snapshot index. Default is `"%04d"`
"""

_common_keyword_log = """
- `savelog::Bool`: if true, save processed data in `csv`. The name of log file depends on analysis function
- `savefolder`: set the directory to save log file
"""

_common_keyword_head_tail = """
- `rmhead`: remove the first `rmhead` elements of result array. Useful to avoid improper data points
- `rmtail`: remove the last `rmtail` elements of result array. Useful to avoid improper data points
"""

_common_keyword_section = """
- `section::Int64`: number of bins. Default is floor(Int64, length(data)^$(SectionIndex))
"""

_common_keyword_timestamp = """
- `timestamp`: print time on figure title
"""

_common_keyword_energy = """
- `uTime::Unitful.Units`: unit of time
- `uEnergy::Unitful.Units`: unit of energy
- `potential::Bool`: if true, read and plot potential energy
- `kinetic::Bool`: if true, read and plot kinetic energy
- `colorpotential`: color of potential energy curve. Default is `:red`
- `colorkinetic`: color of kinetic energy curve. Default is `:blue`
- `colortotal`: color of total energy curve. Default is `:black`
"""

_common_keyword_unicode_colormap = """
- `colormap = :inferno`: color map of `heatmap` plot
"""