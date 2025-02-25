struct SiPM
    m::Float64
    τ::Float64
    fluc::Float64
    norm::Float64
end
signal(s::SiPM, t) = t < 0 ? zero(t) : (t / s.τ)^s.m * exp(-t / s.τ) * s.norm
function SiPM(m, τ, fluc)
    _s = SiPM(m, τ, fluc, 1.0)
    n = maximum(map(t -> signal(_s, t), 0:200))[1]
    SiPM(m, τ, fluc, 1 / n)
end

@with_kw struct Signal
    shape::SiPM
    amplitude::Float64 # in p.e.
    position::Float64
    background::Float64
end
signal(s::Signal, t) = s.amplitude * signal(s.shape, t - s.position) + s.background
