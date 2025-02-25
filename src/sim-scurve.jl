@with_kw struct SimpleSCurve
    μ::Float64
    σ::Float64
    gain::Float64
    pedestal::Float64
end

function SCurve(lis::LISFixedDelay, i::Integrator)
    zero_pe = Signal(lis.sipm, 0.0, lis.delay, lis.background)
    one_pe = Signal(lis.sipm, 1.0, lis.delay, lis.background)
    pedestal = sample_integrate(i, zero_pe)
    gain = sample_integrate(i, one_pe) - pedestal
    #
    σ = lis.sipm.fluc * gain
    SimpleSCurve(; lis.μ, σ, gain, pedestal)
end


function spectrum(sc::SimpleSCurve, th)
    @unpack μ, σ, gain, pedestal = sc
    a_dist = Poisson(μ)
    pedestal_pdf = Normal(pedestal, σ / 3)
    _value = pdf(a_dist, 0) * pdf(pedestal_pdf, th)
    k_max = max(10μ, 3)
    _value += sum(1:round(Int, k_max)) do k
        a = pdf(a_dist, k)
        a * pdf(Normal(pedestal + k * gain, σ), th)
    end
    _value
end

function opposite_cdf(sc::SimpleSCurve, th)
    @unpack μ, σ, gain, pedestal = sc
    a_dist = Poisson(μ)
    pedestal_pdf = Normal(pedestal, σ / 3)
    _value = pdf(a_dist, 0) * (1 - cdf(pedestal_pdf, th))
    k_max = max(10μ, 3)
    _value += sum(1:round(Int, k_max)) do k
        a = pdf(a_dist, k)
        a * (1 - cdf(Normal(pedestal + k * gain, σ), th))
    end
    _value
end


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


struct ConvSCurve{LIS}
    lis::LIS
    i::Integrator
end

SCurve(lis::T, i::Integrator) where T <: LISRandomDelay =
    ConvSCurve(lis, i)

function spectrum(sc::ConvSCurve{<:LISRandomDelay}, th)
    @unpack i, lis = sc
    @unpack μ, delay_density = lis
    _sc(delay) = SCurve(
        LISFixedDelay(; lis.sipm, delay, lis.μ, lis.background),
        i)
    #
    lims = (-Inf, Inf)
    _value = quadgk(lims...) do delay
        pdf(delay_density, delay) * spectrum(_sc(delay), th)
    end[1]
    _value
end

function opposite_cdf(sc::ConvSCurve{<:LISRandomDelay}, th)
    @unpack i, lis = sc
    @unpack μ, delay_density = lis
    _sc(delay) = SCurve(
        LISFixedDelay(; lis.sipm, delay, lis.μ, lis.background),
        i)
    #
    lims = (-Inf, Inf)
    _value = quadgk(lims...) do delay
        pdf(delay_density, delay) * opposite_cdf(_sc(delay), th)
    end[1]
    _value
end
