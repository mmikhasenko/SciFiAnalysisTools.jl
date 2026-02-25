# # SciFi Simulation Tutorial
#
# This tutorial demonstrates how to generate and compare stacked spectra and stacked
# S-curves for a group of channels using `SciFiAnalysisTools.jl`.
#
# The setup reproduces the scenario explored interactively:
#
# - 10 channels
# - mean light yield `mu` decreasing linearly from `1.5` to `1.0`
# - broadened peaks (`fluc = 0.18`)
# - boxed plotting theme

using SciFiAnalysisTools
using Plots

# Use a non-interactive GR backend in CI/headless environments.
ENV["GKSwstype"] = "100"
theme(:boxed)

outdir = joinpath(@__DIR__, "..", "assets", "tutorial")
mkpath(outdir)

sipm = SiPM(2, 20, 0.18)
integrator = Integrator(; window = (20.0, 120.0), sampling_Δt = 5.5, factor_to_DAC = 1.0)
mus = collect(range(1.5, stop = 1.0, length = 10));

const DENSITY_PLOT_SIZE = (1100, 650)
const DENSITY_XLIMS = (-0.1, 3.6)
const DENSITY_OFFSET_MULTIPLIER = 0.18
const DENSITY_LINE_WIDTH = 2.1
const DENSITY_ANNOTATE_X_POS = 3.55
const DENSITY_ANNOTATE_Y_OFFSET_MULTIPLIER = 0.03
const DENSITY_ANNOTATE_FONT_SIZE = 8

const SCURVE_PLOT_SIZE = (1400, 640)
const SCURVE_XLIMS = (-0.05, 3.4)
const SCURVE_OFFSET = 0.12
const SCURVE_LINE_WIDTH = 2.2
const SCURVE_ANNOTATE_X_POS = 3.35
const SCURVE_ANNOTATE_Y_OFFSET = 0.06
const SCURVE_ANNOTATE_FONT_SIZE = 8;

# ## Stacked Light-Yield Spectra

x_density = collect(range(-0.2, stop = 3.8, length = 2600))
density_curves = map(mus) do mu
    lis = LISFixedDelay(; sipm = sipm, delay = -30.0, μ = mu, background = 0.4)
    sc = SCurve(lis, integrator)
    [spectrum(sc, x) for x in x_density]
end

max_density = maximum(vcat(density_curves...))
density_offset = DENSITY_OFFSET_MULTIPLIER * max_density

p_density = plot(
    size = DENSITY_PLOT_SIZE,
    xlab = "charge [DAC]",
    ylab = "density + offset",
    title = "Stacked light-yield spectra (10 channels, mu: 1.5 -> 1.0)",
    legend = false,
    xlims = DENSITY_XLIMS,
)

colors = palette(:batlow, length(mus))
for (idx, (mu, curve)) in enumerate(zip(mus, density_curves))
    y = curve .+ (idx - 1) * density_offset
    plot!(p_density, x_density, y, lw = DENSITY_LINE_WIDTH, c = colors[idx])
    annotate!(
        p_density,
        DENSITY_ANNOTATE_X_POS,
        (idx - 1) * density_offset + DENSITY_ANNOTATE_Y_OFFSET_MULTIPLIER * max_density,
        text(
            "ch$(idx)  mu=$(round(mu, digits = 2))",
            DENSITY_ANNOTATE_FONT_SIZE,
            colors[idx],
            :right,
        ),
    )
end
plot!(p_density, yticks = false)

density_path = joinpath(outdir, "stacked_density_mu15_to_10.png");
savefig(p_density, density_path);

# ![Stacked spectra](../assets/tutorial/stacked_density_mu15_to_10.png)

# ## Stacked S-Curves

x_scurve = collect(range(-0.2, stop = 3.8, length = 2600))
scurve_curves = map(mus) do mu
    lis = LISFixedDelay(; sipm = sipm, delay = -30.0, μ = mu, background = 0.4)
    sc = SCurve(lis, integrator)
    [opposite_cdf(sc, x) for x in x_scurve]
end

scurve_offset = SCURVE_OFFSET

p_scurve = plot(
    size = SCURVE_PLOT_SIZE,
    xlab = "threshold [DAC]",
    ylab = "ratio(>thr) + offset",
    title = "Stacked S-curves (10 channels, mu: 1.5 -> 1.0)",
    legend = false,
    xlims = SCURVE_XLIMS,
)

for (idx, (mu, curve)) in enumerate(zip(mus, scurve_curves))
    y = curve .+ (idx - 1) * scurve_offset
    plot!(p_scurve, x_scurve, y, lw = SCURVE_LINE_WIDTH, c = colors[idx])
    annotate!(
        p_scurve,
        SCURVE_ANNOTATE_X_POS,
        (idx - 1) * scurve_offset + SCURVE_ANNOTATE_Y_OFFSET,
        text(
            "ch$(idx)  mu=$(round(mu, digits = 2))",
            SCURVE_ANNOTATE_FONT_SIZE,
            colors[idx],
            :right,
        ),
    )
end
plot!(p_scurve, yticks = false)

scurve_path = joinpath(outdir, "stacked_scurves_mu15_to_10.png");
savefig(p_scurve, scurve_path);

# ![Stacked S-curves](../assets/tutorial/stacked_scurves_mu15_to_10.png)

# ## Notes
#
# - The broadening of peak widths is controlled by `SiPM(..., fluc)`.
# - `SCurve(lis, integrator)` provides an analytic model used for both:
#   - `spectrum(sc, x)` for density curves
#   - `opposite_cdf(sc, threshold)` for S-curves
# - To tune realism, adjust `fluc`, integration window, and baseline/background.
