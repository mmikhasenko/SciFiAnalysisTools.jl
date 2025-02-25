using SciFiAnalysisTools
using SciFiAnalysisTools.Distributions
using SciFiAnalysisTools.QuadGK
using Plots
using Test

theme(:boxed, xlab = "t [ns]")

const sipm_test = SiPM(2, 20, 0.1);

plot(t -> signal(sipm_test, t), -10, 200, title = "SiPM shape")

lis_test = LISFixedDelay(; sipm = sipm_test, delay = -30, μ = 2.2, background = 0.4)
i_test = Integrator(; window = (20, 120), sampling_Δt = 5.5, factor_to_DAC = 1.0)

# analytically
sc_test = SCurve(lis_test, i_test);

# numerically
signals_test_shot = shot(lis_test, 10_000)
samples_test = sample_integrate.(Ref(i_test), signals_test_shot)

stephist(samples_test, bins = 100, xlab = "charge [DAC]")

scan_test = threshold_scan(lis_test, i_test, -1:0.05:3);
plot(scan_test..., xlab = "charge [DAC]")



lisg_test = LISRandomDelay(; delay_density = Normal(lis_test.delay, 2.0),
    lis_test.sipm, lis_test.μ, lis_test.background)

let
    _signals = shot(lisg_test, 30)
    #
    plot()
    map(_signals) do s
        plot!(t -> signal(s, t), -20, 200)
    end
    plot!(ylim = (0, :auto))
end

scg_test = SCurve(lisg_test, i_test);

let
    plot(th -> spectrum(sc_test, th), 0, 3)
    plot!(th -> spectrum(scg_test, th), 0, 3)
end

let
    plot(th -> opposite_cdf(sc_test, th), 0, 3)
    plot!(th -> opposite_cdf(scg_test, th), 0, 3)
end

@test isapprox(quadgk(th -> spectrum(sc_test, th), -1, 10)[1], 1, atol = 0.1)

let
    plot(xlab = "charge [DAC]")
    plot!(scan_test..., m = (4, :+), lab = "scan")
    _sc = SCurve(lis_test, i_test)
    plot!(th -> opposite_cdf(_sc, th), -1, 3, lw = 1, lab = "exact")
    plot!()
end

light_time_scan_test = light_time_scan(lis_test, i_test, -150:1.1:200, 1.5);

let
    plot(light_time_scan_test..., lab = "numerically")
    plot!(light_time_scan_test.scan, lab = "analytically") do delay
        opposite_cdf(SCurve(LISFixedDelay(lis_test; delay), i_test), 1.5)
    end
    plot!(title = "Lite time scan")
end
