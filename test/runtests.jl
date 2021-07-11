using Test
using Yota
using Yota: gradtape, gradcheck, update_chainrules_primitives!
using Yota: trace, compile, play!
import ChainRulesCore: Tangent, ZeroTangent

# test-only dependencies
using CUDA


include("test_helpers.jl")
include("test_grad.jl")
include("test_update.jl")
include("test_examples.jl")
