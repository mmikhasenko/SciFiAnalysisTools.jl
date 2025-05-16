# SciFiAnalysisTools

[![Stable Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://mmikhasenko.github.io/SciFiAnalysisTools.jl/stable)
[![In development documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://mmikhasenko.github.io/SciFiAnalysisTools.jl/dev)
[![Build Status](https://github.com/mmikhasenko/SciFiAnalysisTools.jl/workflows/Test/badge.svg)](https://github.com/mmikhasenko/SciFiAnalysisTools.jl/actions)
[![Test workflow status](https://github.com/mmikhasenko/SciFiAnalysisTools.jl/actions/workflows/Test.yml/badge.svg?branch=main)](https://github.com/mmikhasenko/SciFiAnalysisTools.jl/actions/workflows/Test.yml?query=branch%3Amain)
[![Lint workflow Status](https://github.com/mmikhasenko/SciFiAnalysisTools.jl/actions/workflows/Lint.yml/badge.svg?branch=main)](https://github.com/mmikhasenko/SciFiAnalysisTools.jl/actions/workflows/Lint.yml?query=branch%3Amain)
[![Docs workflow Status](https://github.com/mmikhasenko/SciFiAnalysisTools.jl/actions/workflows/Docs.yml/badge.svg?branch=main)](https://github.com/mmikhasenko/SciFiAnalysisTools.jl/actions/workflows/Docs.yml?query=branch%3Amain)

[![Coverage](https://codecov.io/gh/mmikhasenko/SciFiAnalysisTools.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/mmikhasenko/SciFiAnalysisTools.jl)

This package provides tools for analyzing data from the LHCb SciFi detector.

## Installation

To install the package, use the following command:

```julia
using Pkg
Pkg.add(Pkg.PackageSpec(; url="https://github.com/mmikhasenko/SciFiAnalysisTools.jl.git"))
```

## Usage

To get started, you can explore the provided functionalities,

```julia
using SciFiAnalysisTools

test_id = 0x00044010
ch_id = ChannelID(test_id) # split the channel ID into physical parts

# code back to hex
id2hex(ch_id) == test_id # true

# print the full name
TLQMD(ch_id) == "T1L0Q1M0_mat0_sipm0" # true
```

## Plotting on the standard map

The method `standard_map` can be used to map a list of hex channel IDs and values to two dimensional array.
The following example shows how to plot detector subparts on the standard map.

```julia
using Plots
theme(:wong2, axis=false, grid=false, colorbar=false)

all_hex = [
    id2hex(TLQMMSTuple((T, L, Q, M, mat, sipm))) for
    T ∈ 1:3, L ∈ 0:3, Q ∈ 1:4, M ∈ 0:5, mat ∈ 0:3, sipm ∈ 0:3 if !(M == 5 && T in [1, 2])
];

plot(layout=grid(3,2),
    heatmap(standard_map(all_hex .=> getproperty.(ChannelID.(all_hex), :_station))),
    heatmap(standard_map(all_hex .=> getproperty.(ChannelID.(all_hex), :_module))),
    heatmap(standard_map(all_hex .=> getproperty.(ChannelID.(all_hex), :_quarter))),
    heatmap(standard_map(all_hex .=> getproperty.(ChannelID.(all_hex), :_layer))),
    heatmap(standard_map(all_hex .=> getproperty.(ChannelID.(all_hex), :_mat))),
    heatmap(standard_map(all_hex .=> getproperty.(ChannelID.(all_hex), :_sipm)))
)
```

## How to Cite

If you use `SciFiAnalysisTools.jl` in your work,
please cite using the reference given in [CITATION.cff](https://github.com/mmikhasenko/SciFiAnalysisTools.jl/blob/main/CITATION.cff).

## Contributing

If you want to make contributions of any kind, please first that a look into our [contributing guide directly on GitHub](docs/src/90-contributing.md) or the [contributing page on the website](https://mmikhasenko.github.io/SciFiAnalysisTools.jl/dev/90-contributing/).

---

### Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
