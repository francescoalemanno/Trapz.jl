module Trapz
export trapz, @trapz

include("kernels.jl")

trapz(x, y) = integrate(x,y)
trapz(x, y, val_i::Val{i}) where i = integrate(x,y,val_i)

"""
# Syntax for integration over single axis
    trapz(x, y, axis=Val(End))
Calculates ∫y[..., i (axis) ,...] dx[i].
For performance reasons x must have the same float type as y.

1-D Example:
```jldoctest
julia> vx = 0:0.01:1;

julia> vy = vx.^2;

julia> trapz(vx, vy)
0.33335
```

# Multidimensional Syntax
2-D Example:
```jldoctest
julia> vx = 0:0.01:1;

julia> vy = 0:0.01:2;

julia> z = [x^2+y^2 for x in vx, y in vy];

julia> # the integral should be ≈ 10/3

julia> trapz((vx,vy), z) # equivalent to trapz(vx, trapz(vy, z))
3.3334000000000006
```

## Partial integration Syntax
2-D Example: partial integration
```jldoctest
julia> vx = 0:0.01:1;

julia> vy = 0:0.01:2;

julia> z = [x^2+y^2 for x in vx, y in vy];

julia> trapz((vx,:),z) # equivalent to trapz(vx, z, Val(1))
201-element Vector{Float64}:
 0.33335
 0.3334500000000001
 0.33375000000000005
 0.3342499999999999
 0.3349500000000001
 0.33585000000000004
 0.3369499999999999
 0.3382500000000001
 0.33975
 0.34145000000000003
 ⋮
 4.019749999999999
 4.058250000000001
 4.09695
 4.1358500000000005
 4.174949999999999
 4.214250000000002
 4.253749999999999
 4.293449999999999
 4.333350000000002
```

2-D Example: partial integration
```jldoctest
julia> vx = 0:0.01:1;

julia> vy = 0:0.01:2;

julia> z = [x^2+y^2 for x in vx, y in vy];

julia> trapz((:,vy),z) # equivalent to trapz(vy, z, Val(2))
101-element Vector{Float64}:
 2.666700000000002
 2.6669
 2.6674999999999995
 2.6685000000000008
 2.6699000000000006
 2.671700000000001
 2.673899999999999
 2.6764999999999994
 2.679499999999999
 2.6829
 ⋮
 4.359499999999999
 4.3965
 4.433899999999999
 4.471700000000001
 4.509900000000001
 4.548500000000001
 4.587500000000002
 4.626900000000002
 4.6667000000000005
```
"""
function trapz end
end # module
