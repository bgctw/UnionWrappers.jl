using UnionWrappers
using Documenter

DocMeta.setdocmeta!(UnionWrappers, :DocTestSetup, :(using UnionWrappers); recursive = true)

makedocs(;
    modules = [UnionWrappers],
    authors = "Thomas Wutzler <twutz@bgc-jena.mpg.de> and contributors",
    repo = "https://github.com/bgctw/UnionWrappers.jl/blob/{commit}{path}#{line}",
    sitename = "UnionWrappers.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://bgctw.github.io/UnionWrappers.jl",
        edit_link = "main",
        assets = String[],
    ),
    pages = ["Home" => "index.md"],
)

deploydocs(; repo = "github.com/bgctw/UnionWrappers.jl", devbranch = "main")
