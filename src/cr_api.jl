import ChainRulesCore: rrule, no_rrule
import ChainRulesCore: rrule_via_ad, RuleConfig, NoForwardsMode, HasReverseMode
import Umlaut: make_name, Input, to_expr, BcastCtx


###############################################################################
#                              Primitives                                     #
###############################################################################


struct ChainRulesCtx end


function isprimitive(::ChainRulesCtx, f, args...)
    F = Core.Typeof(f)
    Args = Core.Typeof.(args)
    Core.Compiler.return_type(rrule, Tuple{YotaRuleConfig, F, Args...}) !== Nothing && return true
    if is_kwfunc(F)
        Args_kwrrule = Tuple{Any, typeof(Core.kwfunc(f)), YotaRuleConfig, Args...,}
        Core.Compiler.return_type(Core.kwfunc(rrule), Args_kwrrule) !== Nothing && return true
    end
    return false
end

###############################################################################
#                              RuleConfig                                     #
###############################################################################

"""
    YotaRuleConfig()

ChainRules.RuleConfig passed to all `rrule`s in Yota.
Extends RuleConfig{Union{NoForwardsMode,HasReverseMode}}.
"""
struct YotaRuleConfig <: RuleConfig{Union{NoForwardsMode,HasReverseMode}} end


###############################################################################
#                              rrule_via_ad                                   #
###############################################################################

"""
    bcast_rrule(::YotaRuleConfig, ::typeof(broadcasted), f, args...; kw...)

Similar to rrule(config, broadcasted, f, args...), but works on for ChainRule-primitive
functions. For a more flexible handling of broadcasting use rrule(...) directly.
"""
function bcast_rrule(::YotaRuleConfig, ::typeof(broadcasted), f::F, args...; kw...) where F
    ys, pbs = unzip(rrule.(YOTA_RULE_CONFIG, f, args...; kw...))
    function pullback(Δ)
        if Δ isa NoTangent || Δ isa ZeroTangent
            return (NoTangent(), [Δ for _=1:length(pbs) + 1]...,)
        end
        Δ = unthunk(Δ)
        dxs = map((pb, Δ) -> pb(Δ), pbs, Δ) |> unzip
        dxs = [all(dx .== NoTangent()) ? NoTangent() : dx for dx in dxs]
        return (NoTangent(), dxs...,)
    end
    return ys, pullback
end


function to_rrule_expr(tape::Tape)
    # TODO (maybe): add YotaRuleConfig() as the first argument for consistency
    fn_name = gensym("rrule_$(tape[V(1)].val)")
    header = Expr(:call, fn_name)
    push!(header.args, Expr(:(::), :config, YotaRuleConfig))
    for v in inputs(tape)
        op = tape[v]
        push!(header.args, Expr(:(::), make_name(op), op.typ))
    end
    body = Expr(:block)
    # generate transformed forward pass
    seed_id = tape.meta[:seed].id
    for op in tape.ops[1:seed_id - 1]
        op isa Input && continue
        ex = to_expr(op)
        if ex isa Vector
            push!(body.args, ex...)
        else
            push!(body.args, ex)
        end
    end
    # generate pullback
    pb_name = gensym("pullback_$(tape[V(1)].val)")
    pb_ex = :(function $pb_name(dy) end)
    pb_body = pb_ex.args[2]
    empty!(pb_body.args)  # clean from useless linenumber nodes
    push!(pb_body.args, Expr(:(=), make_name(tape.meta[:seed].id), :dy))
    for op in tape.ops[seed_id + 1:length(tape) - 2]
        op isa Input && continue
        ex = to_expr(op)
        if ex isa Vector
            push!(pb_body.args, ex...)
        else
            push!(pb_body.args, ex)
        end
    end
    push!(body.args, pb_ex)
    # generate return
    result_name = make_name(tape[tape.result].args[1].id)
    push!(body.args, Expr(:tuple, result_name, pb_name))
    fn_ex = Expr(:function, header, body)
    return fn_ex
end


"""
    make_rrule(tape::Tape)
    make_rrule(f, args...)

Generate a function equivalent to (but not extending) ChainRulesCore.rrule(),
i.e. returning the primal value and the pullback.


Examples:
=========

    foo(x) = 2x + 1
    rr = make_rrule(foo, 2.0)
    val, pb = rr(foo, 3.0)
    pb(1.0)

"""
make_rrule(tape::Tape) = Base.eval(@__MODULE__, to_rrule_expr(tape))

function make_rrule(f, args...)
    return make_rrule(gradtape(f, args...; seed=:auto, ctx=GradCtx()))
end

function make_rrule(::typeof(broadcasted), f, args...)
    if isprimitive(GradCtx(), f, map(first, args)...)
        return bcast_rrule # (YOTA_RULE_CONFIG, broadcasted, f, args...)
    end
    ctx = BcastGradCtx(GradCtx())
    _, tape = trace(f, args...; ctx=ctx, fargtypes=(f, map(eltype, args)))
    tape = Tape(tape; ctx=ctx.inner)
    gradtape!(tape, seed=:auto)
    # insert imaginary broadcasted to the list of inputs
    insert!(tape, 1, Umlaut.Input(broadcasted))
    # insert ZeroTangent to the result to account for the additional argument
    grad_tuple_op = tape[V(tape.result.id - 2)]
    @assert grad_tuple_op isa Call && grad_tuple_op.fn == tuple
    grad_tuple_op.args = [ZeroTangent(), grad_tuple_op.args...]
    for id=grad_tuple_op.id:grad_tuple_op.id + 2
        Umlaut.exec!(tape, tape[V(id)])
    end
    return make_rrule(tape)
end


const GENERATED_RRULE_CACHE = Dict()


"""
    rrule_via_ad(::YotaRuleConfig, f, args...)

Generate `rrule` using Yota.
"""
function ChainRulesCore.rrule_via_ad(::YotaRuleConfig, f, args...)
    res = rrule(f, args...)
    !isnothing(res) && return res
    sig = map(typeof, (f, args...))
    if haskey(GENERATED_RRULE_CACHE, sig)
        rr = GENERATED_RRULE_CACHE[sig]
        # return Base.invokelatest(rr, f, args...)
        val, pb = Base.invokelatest(rr, YOTA_RULE_CONFIG, f, args...)
        return val, dy -> Base.invokelatest(pb, dy)
    else
        rr = make_rrule(f, args...)
        GENERATED_RRULE_CACHE[sig] = rr
        # return Base.invokelatest(rr, f, args...)
        val, pb = Base.invokelatest(rr, YOTA_RULE_CONFIG, f, args...)
        return val, dy -> Base.invokelatest(pb, dy)
    end
end