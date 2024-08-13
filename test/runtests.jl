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
