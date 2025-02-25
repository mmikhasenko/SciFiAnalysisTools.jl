using SciFiAnalysisTools
using Test

@testset "Channel ID" begin
    #
    @test SciFiAnalysisTools.take_bits(0x000446a7, SciFiAnalysisTools.masks._channel) ==
          2 * 16 + 7
    #
    test_id = 0x00044010
    ch_id = ChannelID(test_id)
    @test id2hex(ch_id) == test_id
    #
    @test TLQMD(ch_id) == "T1L0Q1M0_mat0_sipm0"
end

@testset "Location" begin
    @test location_bin_center(TLQMMSTuple((1, 0, 1, 0, 0, 0))) == (x = 1, y = 0)
    @test location_bin_center(TLQMMSTuple((2, 1, 1, 0, 0, 0))) == (x = 1, y = 10)
    #
    @test location_bin_center(TLQMMSTuple((1, 1, 2, 0, 0, 0))) == (x = -1, y = 3)
    @test location_bin_center(TLQMMSTuple((1, 1, 3, 0, 0, 0))) == (x = 31, y = 3)
    #
    @test location_bin_center(TLQMMSTuple((3, 3, 3, 5, 0, 0))) ==
          (x = 32 * 6 - 1, y = 8 * 3 - 1)
end


@testset "Simulations" begin
    include("test-plot-sim.jl")
end
