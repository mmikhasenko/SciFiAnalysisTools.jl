using SciFiAnalysisTools
using Documenter

DocMeta.setdocmeta!(
    SciFiAnalysisTools,
    :DocTestSetup,
    :(using SciFiAnalysisTools);
    recursive = true,
)

const page_rename = Dict("developer.md" => "Developer docs") # Without the numbers

makedocs(;
    modules = [SciFiAnalysisTools],
    authors = "Mikhail Mikhasenko <mikhail.mikhasenko@cern.ch> and contributors",
    repo = "https://github.com/mmikhasenko/SciFiAnalysisTools.jl/blob/{commit}{path}#{line}",
    sitename = "SciFiAnalysisTools.jl",
    format = Documenter.HTML(;
        canonical = "https://mmikhasenko.github.io/SciFiAnalysisTools.jl",
    ),
    pages = [
        "index.md"
        [
            file for file in readdir(joinpath(@__DIR__, "src")) if
            file != "index.md" && splitext(file)[2] == ".md"
        ]
    ],
)

deploydocs(; repo = "github.com/mmikhasenko/SciFiAnalysisTools.jl")
