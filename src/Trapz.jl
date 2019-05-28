module Trapz

export trapz
@inline function bringlast(T::Tuple,el)
    ifelse(el==T[1],
        (bringlast(Base.tail(T),el)...,T[1]) ,
        (T[1],bringlast(Base.tail(T),el)...)
    )
end
@inline function bringlast(T::Tuple{},el); T; end
"""
    trapz(x,y,axis=End)
    Calculates ∫y[..., i (axis) ,...] dx[i]
    for performance reasons x must have the same float type as y.
    1-D Example:
```julia
    vx=0:0.01:1
    vy=(x->x^2).(vx)
    trapz(vx,vy)
```
        Result ≈ 1/3

    2-D Example:
```julia
    vx=0:0.01:1
    vy=0:0.01:2
    z=[x^2+y^2 for x=vx, y=vy]
    trapz(trapz(vy,z),vx)
```
        Result ≈ 4/3
"""
function trapz(x::T1, y::T2) where {N,fT,T1<:AbstractVector{fT},T2<:AbstractArray{fT,N}}
    n = length(x)
    s = size(y)
    @assert s[end]==n
    @inbounds begin
        r =  zeros(fT,Base.reverse(Base.tail(Base.reverse(s))))
        id(i) = (ntuple(k->:,N-1)...,i)
        if n == 1; return r; end
        for i in 2:n-1
           @fastmath r .+= (x[i+1] - x[i-1]) .* view(y,id(i)...)
        end
        r .+= (x[end]-x[end-1]) .* view(y,id(n)...) + (x[2] - x[1]).* view(y,id(1)...)
        return r./2
    end
end

function trapz(x::T1, y::T2, axis::T3) where {N,fT,T1<:AbstractVector{fT},T2<:AbstractArray{fT,N},T3<:Integer}
    @assert 1<=axis<=N
    trapz(x,PermutedDimsArray(y,bringlast(ntuple(identity,N),axis)))
end


end # module
