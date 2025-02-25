@with_kw struct Integrator
    window::Tuple{Float64,Float64}
    sampling_Δt::Float64
    factor_to_DAC::Float64
end

function sample_integrate(i::Integrator, s::Signal)
    t_sample = range(i.window..., step = i.sampling_Δt)
    return mean(t_sample) do t
        signal(s, t)
    end .* i.factor_to_DAC
end
