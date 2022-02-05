import ChainRulesCore.rrule
import Yota.YotaRuleConfig


@testset "rulesets" begin

    f = reshape
    args = [(rand(3, 4),), (12,)]
    test_rrule(YotaRuleConfig(), Core._apply_iterate, iterate, f, args...; check_inferred=false)

end


@testset "generic broadcasted" begin
    # see the discussion here:
    # https://github.com/JuliaDiff/ChainRules.jl/issues/531
    f = sin
    xs = rand(2)

    # manually get pullbacks for each element and apply them to seed 1.0
    pbs = [rrule(f, x)[2] for x in xs]
    dxs = [pbs[1](1.0)[2], pbs[2](1.0)[2]]

    # use rrule for broadcasted
    _, bcast_pb = rrule(YotaRuleConfig(), Broadcast.broadcasted, f, xs)
    dxs_bcast = bcast_pb(ones(2))[end]

    @test all(dxs .== dxs_bcast)
end