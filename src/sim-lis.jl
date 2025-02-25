@with_kw struct LISFixedDelay
    sipm::SiPM
    delay::Float64
    μ::Float16
    background::Float64
end

function shot(lis::LISFixedDelay, n::Int)
    @unpack sipm, delay = lis
    return map(1:n) do _
        amplitude = rand(Poisson(lis.μ)) + sipm.fluc * randn()
        amplitude *= amplitude > 0.5
        Signal(; shape = sipm, amplitude, position = delay, lis.background)
    end
end

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


@with_kw struct LISRandomDelay{T}
    sipm::SiPM
    delay_density::T
    μ::Float16
    background::Float64
end

function shot(lis::LISRandomDelay, n::Int)
    @unpack sipm = lis
    return map(1:n) do _
        amplitude = rand(Poisson(lis.μ)) + sipm.fluc * randn()
        amplitude *= amplitude > 0.5
        position = rand(lis.delay_density)
        Signal(; shape = sipm, amplitude, position, lis.background)
    end
end

