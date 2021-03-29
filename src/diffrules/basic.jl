#######################################################################
#                        BASIC RULES                                  #
#######################################################################

@nodiff length(u)    u

@nodiff size(u)      u
@nodiff size(u,v)    u
@nodiff size(u,v)    v

@nodiff fill(u,v)    u
@nodiff fill(u,v)    v

@nodiff similar(u,v) u
@nodiff similar(u,v) v

@nodiff zeros(u)             u
@nodiff zero(u)              u
@nodiff zeros(i, j)          i
@nodiff zeros(i, j)          j
@nodiff zeros(i, j, k)       i
@nodiff zeros(i, j, k)       j
@nodiff zeros(i, j, k)       k
@nodiff zeros(i, j, k, _l)   i
@nodiff zeros(i, j, k, _l)   j
@nodiff zeros(i, j, k, _l)   k
@nodiff zeros(i, j, k, _l)   _l

@nodiff ones(u)             u
@nodiff one(u)              u
@nodiff ones(i, j)          i
@nodiff ones(i, j)          j
@nodiff ones(i, j, k)       i
@nodiff ones(i, j, k)       j
@nodiff ones(i, j, k)       k
@nodiff ones(i, j, k, _l)   i
@nodiff ones(i, j, k, _l)   j
@nodiff ones(i, j, k, _l)   k
@nodiff ones(i, j, k, _l)   _l

@nodiff sign(u)      u

# @diffrule reverse(u)   u     0.0

# tuple
@diffrule tuple(u)        u     dy[1]
@diffrule tuple(u,v)      u     dy[1]
@diffrule tuple(u,v)      v     dy[2]
@diffrule tuple(u,v,w)    u     dy[1]
@diffrule tuple(u,v,w)    v     dy[2]
@diffrule tuple(u,v,w)    w     dy[3]
@diffrule tuple(u,v,w,t)  u     dy[1]
@diffrule tuple(u,v,w,t)  v     dy[2]
@diffrule tuple(u,v,w,t)  w     dy[3]
@diffrule tuple(u,v,w,t)  t     dy[4]

# # __tuple__ (cassette tracer implemetation uses it instead of normal tuple)
# @diffrule __tuple__(u)        u     dy[1]
# @diffrule __tuple__(u,v)      u     dy[1]
# @diffrule __tuple__(u,v)      v     dy[2]
# @diffrule __tuple__(u,v,w)    u     dy[1]
# @diffrule __tuple__(u,v,w)    v     dy[2]
# @diffrule __tuple__(u,v,w)    w     dy[3]
# @diffrule __tuple__(u,v,w,t)  u     dy[1]
# @diffrule __tuple__(u,v,w,t)  v     dy[2]
# @diffrule __tuple__(u,v,w,t)  w     dy[3]
# @diffrule __tuple__(u,v,w,t)  t     dy[4]

# vcat
@diffrule vcat(u,v)      u     unvcat(dy, 1, u, v)
@diffrule vcat(u,v)      v     unvcat(dy, 2, u, v)
@diffrule vcat(u,v,w)    u     unvcat(dy, 1, u, v, w)
@diffrule vcat(u,v,w)    v     unvcat(dy, 2, u, v, w)
@diffrule vcat(u,v,w)    w     unvcat(dy, 3, u, v, w)
@diffrule vcat(u,v,w,t)  u     unvcat(dy, 1, u, v, w, t)
@diffrule vcat(u,v,w,t)  v     unvcat(dy, 2, u, v, w, t)
@diffrule vcat(u,v,w,t)  w     unvcat(dy, 3, u, v, w, t)
@diffrule vcat(u,v,w,t)  t     unvcat(dy, 4, u, v, w, t)

#  hcat
@diffrule hcat(u,v)      u     unhcat(dy, 1, u, v)
@diffrule hcat(u,v)      v     unhcat(dy, 2, u, v)
@diffrule hcat(u,v,w)    u     unhcat(dy, 1, u, v, w)
@diffrule hcat(u,v,w)    v     unhcat(dy, 2, u, v, w)
@diffrule hcat(u,v,w)    w     unhcat(dy, 3, u, v, w)
@diffrule hcat(u,v,w,t)  u     unhcat(dy, 1, u, v, w, t)
@diffrule hcat(u,v,w,t)  v     unhcat(dy, 2, u, v, w, t)
@diffrule hcat(u,v,w,t)  w     unhcat(dy, 3, u, v, w, t)
@diffrule hcat(u,v,w,t)  t     unhcat(dy, 4, u, v, w, t)

#  cat
@diffrule_kw cat(u,v)      u     uncat(dy, 1, u, v)
@diffrule_kw cat(u,v)      v     uncat(dy, 2, u, v)
@diffrule_kw cat(u,v,w)    u     uncat(dy, 1, u, v, w)
@diffrule_kw cat(u,v,w)    v     uncat(dy, 2, u, v, w)
@diffrule_kw cat(u,v,w)    w     uncat(dy, 3, u, v, w)
@diffrule_kw cat(u,v,w,t)  u     uncat(dy, 1, u, v, w, t)
@diffrule_kw cat(u,v,w,t)  v     uncat(dy, 2, u, v, w, t)
@diffrule_kw cat(u,v,w,t)  w     uncat(dy, 3, u, v, w, t)
@diffrule_kw cat(u,v,w,t)  t     uncat(dy, 4, u, v, w, t)

# reshape
@diffrule reshape(u::AbstractArray, _a)             u    reshape(dy, size(u))
@diffrule reshape(u::AbstractArray, _a, _b)         u    reshape(dy, size(u))
@diffrule reshape(u::AbstractArray, _a, _b, _c)     u    reshape(dy, size(u))
@diffrule reshape(u::AbstractArray, _a, _b, _c, _d) u    reshape(dy, size(u))
@nodiff reshape(u::AbstractArray, _a)              _a
@nodiff reshape(u::AbstractArray, _a, _b)          _a
@nodiff reshape(u::AbstractArray, _a, _b)          _b
@nodiff reshape(u::AbstractArray, _a, _b, _c)      _a
@nodiff reshape(u::AbstractArray, _a, _b, _c)      _b
@nodiff reshape(u::AbstractArray, _a, _b, _c)      _c
@nodiff reshape(u::AbstractArray, _a, _b, _c, _d)  _a
@nodiff reshape(u::AbstractArray, _a, _b, _c, _d)  _b
@nodiff reshape(u::AbstractArray, _a, _b, _c, _d)  _c
@nodiff reshape(u::AbstractArray, _a, _b, _c, _d)  _d
@diffrule reshape(u::AbstractArray, _d::Tuple)      u    reshape(dy, size(u))
@nodiff reshape(u::AbstractArray, _d::Tuple)        _d

@diffrule vec(u::AbstractArray)    u    reshape(dy, size(u))


# getproperty, getfield, __new__

@diffrule getproperty(_s, _f) _s ∇getproperty(dy, _s, _f)
@nodiff getproperty(_s, _f) _f

@diffrule getfield(_s::Tuple, _f) _s ∇getfield(dy, _s, _f)
@nodiff getfield(_s, _f::Tuple) _f

# @diffrule __getfield__(_s::Tuple, _f) _s ∇getfield(dy, _s, _f)
# @nodiff __getfield__(_s, _f::Tuple) _f


const LONG_VAR_NAME_LIST = (:x, :u, :v, :w, :_a, :_b, :_c, :_d, :_e, :_f, :_g)
for n=1:length(LONG_VAR_NAME_LIST)
    vn = LONG_VAR_NAME_LIST[1:n]
    for i=1:length(vn)
        @eval begin
            @nodiff $(Expr(:call, __new__, :t, vn...)) t
            @diffrule $(Expr(:call, __new__, :t, vn...)) $(vn[i]) ∇__new__(dy, t, $i)
        end
    end
end

# Base.iterate

# here we explicitely stop propagation in iteration
# over ranges (e.g for i=1:3 ... end)
@nodiff Base.iterate(x::UnitRange) x
@nodiff Base.iterate(x::UnitRange, i::Int) x
@nodiff Base.iterate(x::UnitRange, i::Int) i

@diffrule Base.iterate(t::Tuple) t ∇getfield(getindex(dy, 1), t, 1)
@diffrule Base.iterate(t::Tuple, i::Int) t ∇getfield(getindex(dy, 1), t, i)
@nodiff Base.iterate(t::Tuple, i::Int) i

@diffrule Base.iterate(x::AbstractArray) x ungetindex(x, dy, 1)
@diffrule Base.iterate(x::AbstractArray, i::Int) x ungetindex(x, dy, i)
@nodiff Base.iterate(x::AbstractArray, i::Int) i


# Base.indexed_iterate (tuple unpacking)

@diffrule Base.indexed_iterate(t::Tuple, i::Int) t ∇getfield(getindex(dy, 1), t, i)
@nodiff Base.indexed_iterate(t::Tuple, i::Int) i
@diffrule Base.indexed_iterate(t::Tuple, i::Int, _state::Int) t ∇getfield(getindex(dy, 1), t, i)
@nodiff Base.indexed_iterate(t::Tuple, i::Int, _state::Int) i
@nodiff Base.indexed_iterate(t::Tuple, i::Int, _state::Int) _state


# getindex
@diffrule getindex(u::AbstractArray, i)         u    ungetindex(u, dy, i)
@diffrule getindex(u::AbstractArray, i, j)      u    ungetindex(u, dy, i, j)
@diffrule getindex(u::AbstractArray, i, j, k)   u    ungetindex(u, dy, i, j, k)
@nodiff getindex(u::AbstractArray, i)         i
@nodiff getindex(u::AbstractArray, i, j)      i
@nodiff getindex(u::AbstractArray, i, j)      j
@nodiff getindex(u::AbstractArray, i, j, k)   i
@nodiff getindex(u::AbstractArray, i, j, k)   j
@nodiff getindex(u::AbstractArray, i, j, k)   k

@diffrule getindex(u::Tuple, i) u ungetindex(u, dy, i)
@nodiff getindex(u::Tuple, i) i


# view - in non-mutating world behaves like getting subarrays using getindex
@diffrule view(u::AbstractArray, i)         u    ungetindex(u, dy, i)
@diffrule view(u::AbstractArray, i, j)      u    ungetindex(u, dy, i, j)
@diffrule view(u::AbstractArray, i, j, k)   u    ungetindex(u, dy, i, j, k)
@nodiff view(u::AbstractArray, i)         i
@nodiff view(u::AbstractArray, i, j)      i
@nodiff view(u::AbstractArray, i, j)      j
@nodiff view(u::AbstractArray, i, j, k)   i
@nodiff view(u::AbstractArray, i, j, k)   j
@nodiff view(u::AbstractArray, i, j, k)   k


# square root
@diffrule sqrt(u::Real)              u     one(u) / 2 * u ^ (-one(u) / 2) * dy

# addition
@diffrule +(u::Real         , v::Real )            u     dy
@diffrule +(u::AbstractArray, v::AbstractArray)    u     dy
@diffrule +(u::Real         , v::Real )            v     dy
@diffrule +(u::AbstractArray, v::AbstractArray)    v     dy

@diffrule broadcast(_fn::typeof(+), u, v) u unbroadcast(u, dy)
@diffrule broadcast(_fn::typeof(+), u, v) v unbroadcast(v, dy)

@diffrule broadcast(_fn::typeof(*), u, v) u unbroadcast_prod_x(u, v, dy)
@diffrule broadcast(_fn::typeof(*), u, v) v unbroadcast_prod_y(u, v, dy)


# unary substraction
@diffrule -(u::Real )                               u     -dy
@diffrule -(u::AbstractArray)                       u     -dy

# binary substraction
@diffrule -(u::Real, v::Real)                       u     dy
@diffrule -(u::AbstractArray, v::AbstractArray)     u     dy
@diffrule -(u::Real         , v::Real)              v     -dy
@diffrule -(u::AbstractArray, v::AbstractArray)     v     -dy


# sum() and mean()
@diffrule sum(u::AbstractArray)                     u     ∇sum(u, dy)
@diffrule Base._sum(u::AbstractArray, v::Int)             u     ∇sum(u, dy)
@diffrule Base._sum(u::AbstractArray, v::Int)             v     zero(eltype(u))
@diffrule Core.kwfunc(sum)(_dims, _, u::AbstractArray)     u     ∇sum(u, dy)
@nodiff Core.kwfunc(sum)(_dims, _, u::AbstractArray)     _dims
@nodiff Core.kwfunc(sum)(_dims, _, u::AbstractArray)     _

# special sums
@diffrule sum(_fn::typeof(log), u::AbstractArray)    u    ∇sum(u, dy) ./ u

@diffrule Statistics.mean(u::AbstractArray)                u     ∇mean(u, dy)
@diffrule Statistics._mean(u::AbstractArray, v::Int)       u     ∇mean(u, dy)
@diffrule Statistics._mean(u::AbstractArray, v::Int)       v     zero(eltype(u))
@diffrule Core.kwfunc(Statistics.mean)(_dims, _, u::AbstractArray) u ∇mean(u, dy, _dims)
@nodiff Core.kwfunc(Statistics.mean)(_dims, _, u::AbstractArray) _dims
@nodiff Core.kwfunc(Statistics.mean)(_dims, _, u::AbstractArray) _

# diag
@diffrule diag(u::AbstractMatrix)    u    Diagonal(dy)

# dot()
@diffrule dot(u::Real, v::Real)                     u     v * dy
@diffrule dot(u::Real, v::Real)                     v     u * dy

# @diffrule dot(u::AbstractArray, v::AbstractArray)   u     v.*dy
# @diffrule dot(u::AbstractArray, v::AbstractArray)   v     u.*dy

# log() and exp()
@diffrule log(u::Real )                            u     dy / u
@diffrule exp(u::Real )                            u     exp(u) * dy
@diffrule log1p(u::Real)                           u     dy  / (one(u) + u)
@diffrule expm1(u::Real)                           u     (one(u) + expm1(u))  * dy
# @diffrule expm1(u::AbstractArray)                  u     (one(u) + expm1(u)) .* dy
# note : derivative uses expm1() and not exp() to reuse the
#   already calculated expm1()

# trig functions
@diffrule sin(u::Real )                            u     cos(u) * dy
@diffrule cos(u::Real )                            u     -sin(u) * dy
@diffrule tan(u::Real )                            u     (one(u) + tan(u)  * tan(u))  * dy
@diffrule sinh(u::Real )                           u     cosh(u) * dy
@diffrule cosh(u::Real )                           u     sinh(u) * dy
@diffrule tanh(u::Real )                           u     (one(u) - tanh(u)  * tanh(u))  * dy
@diffrule asin(u::Real )                           u     dy  / sqrt(one(u) - u*u)
@diffrule acos(u::Real )                           u     -dy  / sqrt(one(u) - u*u)
@diffrule atan(u::Real )                           u     dy  / (one(u) + u *u)


# round, floor, ceil, trunc, mod2pi
@diffrule round(u::Real)                           u     zero(u)

@diffrule floor(u::Real)                           u     zero(u)

@diffrule ceil(u::Real)                            u     zero(u)

@diffrule trunc(u::Real)                           u     zero(u)

@diffrule mod2pi(u::Real)                          u     dy


# abs, max(), min()
@diffrule abs(u::Real)                             u     sign(u) * dy
@diffrule abs2(u::Real)                            u     2 * u * dy


# @diffrule max(u::Real         , v::Real)           u     (u > v) * dy
# @diffrule max(u::Real         , v::AbstractArray)  u     sum((u .> v) .* dy)
# @diffrule max(u::AbstractArray, v::Real)           u     (u .> v) .* dy
# @diffrule max(u::AbstractArray, v::AbstractArray)  u     (u .> v) .* dy

# @diffrule max(u::Real         , v::Real)           v     (u < v) * dy
# @diffrule max(u::Real         , v::AbstractArray)  v     (u .< v) .* dy
# @diffrule max(u::AbstractArray, v::Real)           v     sum((u .< v) .* dy)
# @diffrule max(u::AbstractArray, v::AbstractArray)  v     (u .< v) .* dy

# @diffrule min(u::Real         , v::Real)           u     (u < v) * dy
# @diffrule min(u::Real         , v::AbstractArray)  u     sum((u .< v) .* dy)
# @diffrule min(u::AbstractArray, v::Real)           u     (u .< v) .* dy
# @diffrule min(u::AbstractArray, v::AbstractArray)  u     (u .< v) .* dy

# @diffrule min(u::Real         , v::Real)           v     (u > v) * dy
# @diffrule min(u::Real         , v::AbstractArray)  v     (u .> v) .* dy
# @diffrule min(u::AbstractArray, v::Real)           v     sum((u .> v) .* dy)
# @diffrule min(u::AbstractArray, v::AbstractArray)  v     (u .> v) .* dy

# maximum, minimum
# @diffrule maximum(u::Real         )     u     dy
# @diffrule maximum(u::AbstractArray)     u     (u .== maximum(u)) .* dy

# @diffrule minimum(u::Real         )     u     dy
# @diffrule minimum(u::AbstractArray)     u     (u .== minimum(u)) .* dy


# multiplication
@diffrule *(u::Real         , v::Real )            u     v * dy
@diffrule *(u::Real         , v::AbstractArray)    u     sum(v .* dy)
@diffrule *(u::AbstractArray, v::Real )            u     v .* dy
@diffrule *(u::AbstractArray, v::AbstractArray)    u     dy * transpose(v)

@diffrule *(u::Real         , v::Real )            v     u * dy
@diffrule *(u::Real         , v::AbstractArray)    v     u .* dy
@diffrule *(u::AbstractArray, v::Real )            v     sum(u .* dy)
@diffrule *(u::AbstractArray, v::AbstractArray)    v     transpose(u) * dy


# power  (both args reals)
@diffrule ^(u::Real, v::Real)                      u     v * u ^ (v-(one(u))) * dy
@diffrule ^(u::Real, v::Real)                      v     log(u) * u ^ v * dy

get_val_param(::Val{v}) where v = v
@diffrule Base.literal_pow(_, u::Real, v)         u      get_val_param(v) * u ^ (get_val_param(v)-(one(u))) * dy
@nodiff Base.literal_pow(_, u::Real, v)           _
@nodiff Base.literal_pow(_, u::Real, v)           v


# # division
@diffrule /(u::Real          , v::Real )           u     dy / v
@diffrule /(u::Real          , v::Real )           v     -u * dy / (v * v)

# transpose
@diffrule transpose(u::AbstractVector)             u     untranspose_vec(dy)
@diffrule transpose(u::AbstractArray)              u     transpose(dy)
@diffrule adjoint(u::AbstractVector)             u     untranspose_vec(dy)
@diffrule adjoint(u::AbstractArray)              u     adjoint(dy)

# permutedims
@diffrule permutedims(x, _perm) x ∇permutedims(dy, _perm)
@nodiff permutedims(x, _perm) _perm

# # erf, erfc, gamma, beta, lbeta, lgamma
# @diffrule erf(u::Real)                       u     2.0/sqrt(π) * exp(-u  * u)  * dy
# @diffrule erf(u::AbstractArray)              u     2.0/sqrt(π) .* exp(-u .* u) .* dy

# @diffrule erfc(u::Real)                      u     -2.0/sqrt(π) * exp(-u  * u)  * dy
# @diffrule erfc(u::AbstractArray)             u     -2.0/sqrt(π) .* exp(-u .* u) .* dy

# @diffrule gamma(u::Real)                     u     polygamma(0,u)  * gamma(u)  * dy
# @diffrule gamma(u::AbstractArray)            u     polygamma(0,u) .* gamma(u) .* dy

# @diffrule lgamma(u::Real)                    u     polygamma(0,u)  * dy
# @diffrule lgamma(u::AbstractArray)           u     polygamma(0,u) .* dy

# @diffrule beta(u::Real         , v::Real)            u   beta(u,v)  * (digamma(u)-digamma(u+v))  * dy
# @diffrule beta(u::AbstractArray, v::AbstractArray)   u   beta(u,v) .* (digamma(u)-digamma(u+v)) .* dy
# @diffrule beta(u::Real         , v::Real)            v   beta(u,v)  * (digamma(v)-digamma(u+v))  * dy
# @diffrule beta(u::AbstractArray, v::AbstractArray)   v   beta(u,v) .* (digamma(v)-digamma(u+v)) .* dy

# @diffrule lbeta(u::Real         , v::Real)            u   (polygamma(0,u)-polygamma(0,u+v))  * dy
# @diffrule lbeta(u::AbstractArray, v::AbstractArray)   u   (polygamma(0,u)-polygamma(0,u+v)) .* dy
# @diffrule lbeta(u::Real         , v::Real)            v   (polygamma(0,v)-polygamma(0,u+v))  * dy
# @diffrule lbeta(u::AbstractArray, v::AbstractArray)   v   (polygamma(0,v)-polygamma(0,u+v)) .* dy

@nodiff rand(u) u

@nodiff convert(u, v) u
@diffrule convert(u, v) v dy

@nodiff to_device(_d, u)      _d
@diffrule to_device(_d, u)    u    dy
