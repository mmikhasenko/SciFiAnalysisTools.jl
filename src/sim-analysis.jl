function threshold_scan(lis::LISFixedDelay, i::Integrator, scan, nSample = 10_000)
    ratios = map(scan) do th
        _sample = shot(lis, nSample)
        _charges = sample_integrate.(Ref(i), _sample)
        sum(_charges .> th)
    end / nSample
    (; scan = collect(scan), ratios)
end

function light_time_scan(lis::LISFixedDelay, i::Integrator, scan, threshold, nSample = 10_000)
    #
    ratios = map(scan) do Δt
        _lis = LISFixedDelay(lis; delay = Δt)
        _sample = shot(_lis, nSample)
        _charges = sample_integrate.(Ref(i), _sample)
        sum(_charges .> threshold)
    end / nSample
    (; scan = collect(scan), ratios)
end
