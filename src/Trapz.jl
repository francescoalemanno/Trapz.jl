module Trapz
    export trapz

    include("kernels.jl")

    function trapz(x, y)
        return integrate(x,y)
    end

    function trapz(x, y, val_i::Val{i}) where i
        return integrate(x,y,val_i)
    end

    """
# Syntax for integration over single axis
        trapz(x,y,axis=Val(End))
        Calculates ∫y[..., i (axis) ,...] dx[i]
        for performance reasons x must have the same float type as y.
        1-D Example:
```julia
    vx=0:0.01:1
    vy=(x->x^2).(vx)
    trapz(vx,vy)
```
            Result ≈ 1/3
# Multidimensional Syntax
        2-D Example:
```julia
    vx=0:0.01:1
    vy=0:0.01:2
    z=[x^2+y^2 for x=vx, y=vy]
    trapz((vx,vy),z) # equivalent to trapz(vx, trapz(vy, z))
```
            Result ≈ 4/3
## Partial integration Syntax
        2-D Example: partial integration
```julia
    vx=0:0.01:1
    vy=0:0.01:2
    z=[x^2+y^2 for x=vx, y=vy]
    trapz((vx,:),z) # equivalent to trapz(vx, z, Val(1))
```
            Result ≈ 201-element Array{Float64,1}:
                     0.33335
                     0.3334500000000001
                     0.33375000000000005
                     0.3342499999999999
                     ⋮
                     4.253749999999999
                     4.293449999999999
                     4.333350000000002

        2-D Example: partial integration
```julia
    vx=0:0.01:1
    vy=0:0.01:2
    z=[x^2+y^2 for x=vx, y=vy]
    trapz((:,vy),z) # equivalent to trapz(vy, z, Val(2))
```
            Result ≈ 101-element Array{Float64,1}:
                     2.666700000000002
                     2.6669
                     2.6674999999999995
                     2.6685000000000008
                     ⋮
                     4.587500000000002
                     4.626900000000002
                     4.6667000000000005

    """
    trapz
end # module
