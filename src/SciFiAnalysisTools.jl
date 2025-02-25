module SciFiAnalysisTools

using Parameters

export TLQMD
export id2hex
export ChannelID
export TLQMMSTuple
include("channelid.jl")

export location_bin_center
export standard_map
include("location.jl")


## Simulations
using Distributions
using QuadGK

export SiPM, signal
include("sim-sipm.jl")

export LISFixedDelay, LISRandomDelay
export shot
include("sim-lis.jl")

export Integrator
export sample_integrate
include("sim-readout.jl")

export SCurve
export spectrum, opposite_cdf
include("sim-scurve.jl")

export threshold_scan
export light_time_scan
include("sim-analysis.jl")

end
