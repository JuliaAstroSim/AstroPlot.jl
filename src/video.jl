"""
$(TYPEDSIGNATURES)
Convert all figure end with `suffix` to video. Filenames are organized as `filenamebase0000suffix`.
For `png` files like `pos_0000.png`, set `filenamebase = "pos_"` and `suffix = ".png"`

It basically calls `VideoIO.open_video_out`

## Keywords
- `encoder_options`: keywords supported by `FFMPEG`. Default value `(crf=23, preset="medium")` is suitable for most cases
- `framerate`: fps (frame per second). Default `24`
- `codec_name`: name of video encoder. Default `nothing`. Try `libx264`, `libx265`, `libx264rgb` and more options in `FFMPEG`

## Examples
```jl
julia> png2video("output", "pos_", ".png", "test.mp4")
```
"""
function png2video(dir::String, filenamebase::String, suffix::String, outfile::String;
        encoder_options = (crf=23, preset="medium"),
        framerate = 24,
        codec_name = nothing,
    )
    imgnames = filter(x->occursin(suffix,x), readdir(dir)) # Populate list of all .pngs
    intstrings =  map(x->split(split(x, filenamebase)[2], suffix)[1], imgnames)        # Extract index from filenames
    p = sortperm(parse.(Int, intstrings))                  # sort files numerically
    imgnames = imgnames[p]

    firstimg = load(joinpath(dir, imgnames[1]))
    open_video_out(outfile, firstimg; framerate, encoder_options, codec_name) do writer
        @showprogress "Encoding video frames.." for i in eachindex(imgnames)
            img = load(joinpath(dir, imgnames[i]))
            write(writer, img)
        end
    end
    return true
end