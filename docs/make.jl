"""
Compile with:
julia --project=docs/ --color=yes docs/make.jl

Deployment is handled out-of-band by the `julia-actions/julia-docdeploy`
GitHub Action (see `.github/workflows/ManuallyBuildDoc.yml`).

GLMakie needs a virtual display when run on CI; the Action sets
`DISPLAY=:0` and uses `xvfb-run` (see workflow).
"""

using Documenter

using AstroPlot

# The DOCSARGS environment variable can be used to pass additional arguments to make.jl.
# This is useful on CI, if you need to change the behavior of the build slightly but you
# can not change the .travis.yml or make.jl scripts any more (e.g. for a tag build).
if haskey(ENV, "DOCSARGS")
    for arg in split(ENV["DOCSARGS"])
        (arg in ARGS) || push!(ARGS, arg)
    end
end

makedocs(
    modules = [AstroPlot],
    format = Documenter.HTML(
        # Use clean URLs, unless built as a "local" build
        prettyurls = !("local" in ARGS),
        canonical = "https://juliaastrosim.github.io/AstroPlot.jl/dev/",
        assets = ["assets/alpha_small.ico"],
        analytics = "UA-153693590-1",
        highlights = ["llvm", "yaml"],
    ),
    clean = false,
    sitename = "AstroPlot.jl",
    authors = "islent",
    linkcheck = !("skiplinks" in ARGS),
    pages = [
        "Home" => "index.md",
        "Manual" => Any[
            "manual/guide.md",
            "manual/analyse.md",
            "manual/snapshots.md",
            "manual/tree.md",
            "manual/mesh.md",
            "manual/video.md",
            "manual/mosaic.md",
        ],
        "Library" => Any[
            "lib/Methods.md",
        ],
        #"contributing.md",
    ],
    workdir = joinpath(@__DIR__, "../test"),
    #strict = !("strict=false" in ARGS),
    #doctest = ("doctest=only" in ARGS) ? :only : true,
)

deploydocs(
    repo = "github.com/JuliaAstroSim/AstroPlot.jl.git",
    target = "build",
)