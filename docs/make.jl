using SciFiAnalysisTools
using Documenter
using Literate

DocMeta.setdocmeta!(
    SciFiAnalysisTools,
    :DocTestSetup,
    :(using SciFiAnalysisTools);
    recursive = true,
)

# Generate tutorial page from Literate source.
const literate_input = joinpath(@__DIR__, "literate", "simulation_tutorial.jl")
const literate_output = joinpath(@__DIR__, "src", "generated")
mkpath(literate_output)
Literate.markdown(
    literate_input,
    literate_output;
    name = "simulation-tutorial",
    documenter = true,
    execute = true,
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
        "generated/simulation-tutorial.md"
        [
            file for file in readdir(joinpath(@__DIR__, "src")) if
            file != "index.md" && splitext(file)[2] == ".md"
        ]
    ],
)

deploydocs(; repo = "github.com/mmikhasenko/SciFiAnalysisTools.jl")
# Don't forget to run
#
#     pkg> dev ..
#
