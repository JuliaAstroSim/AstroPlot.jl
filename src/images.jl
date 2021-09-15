import Images.mosaicview

"""
    function mosaicview(folder::String, filenamebase::String, Counts::Array, suffix::String; kw...)

# Arguments
- `folder`: directory holding snapshots
- `filenamebase`, `Counts`, `suffix`:
    snapshots are commonly named as `snapshot_0000.gadget2`, in this way `filenamebase = "snapshot_"`, `suffix = ".gadget2`.
    `Counts` is an array to choose snapshots, and it is printed to formatted string (controled by keyword `formatstring`) in `for` loops.

# Examples
```jl
julia> mosaicview("output", "pos_", collect(0:10:490), ".png"; fillvalue=0.5, npad=5, ncol=10, rowmajor=true)
```
"""
function mosaicview(folder::String, filenamebase::String, Counts::Array, suffix::String;
        formatstring = "%04d",
        kw...
    )
    imgnames = [joinpath(folder, string(filenamebase, Printf.format(Printf.Format(formatstring), i), suffix)) for i in Counts]
    imgs = load.(imgnames)
    mosaicview(imgs; kw...)
end

"""
    function mosaicview(folder::String, filenamebase::String, suffix::String; kw...)

Plot all files matching `filenamebase` and `suffix` in `folder` to mosaic view.
"""
function mosaicview(folder::String, filenamebase::String, suffix::String; kw...)
    imgnames = filter(x->(occursin(suffix,x) && occursin(filenamebase,x)), readdir(folder)) # Populate list of all .pngs
    intstrings =  map(x->split(split(x, filenamebase)[2], suffix)[1], imgnames)        # Extract index from filenames
    p = sortperm(parse.(Int, intstrings))                  # sort files numerically
    imgnames = imgnames[p]
    imgs = load.(imgnames)

    mosaicview(imgs; kw...)
end