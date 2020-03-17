module Trapz
    export trapz
    include("tupletools.jl")
    @inline function trapz_colon(k) Colon(); end
    @inline function idxlast(i,::Val{N}) where N; Base.tail((ntuple(trapz_colon,Val(N))...,i)) end

    @generated function trapz(x::T1, y::T2) where {N,N2,fT,T1<:AbstractArray{fT,N2},T2<:AbstractArray{fT,N}}
        ret=:(return r ./ 2)
        if N==1
            ret=:(return r[1]/2)
        end
        if N==0
            ret=:(return zero(fT))
        end
        quote
            n = length(x)
            s = size(y)
            @assert s[end]==n
            @assert maximum(size(x))==n
            r = similar(y,rtail(s))
            if n <= 1
                r.=zero(fT)
            else
                @inbounds begin
                @fastmath r .= (x[2] - x[1]) .* view(y,idxlast(1,Val(N))...)
                for i in 2:n-1
                   @fastmath r .+= (x[i+1] - x[i-1]) .* view(y,idxlast(i,Val(N))...)
                end
                @fastmath r .+= (x[end]-x[end-1]) .* view(y,idxlast(n,Val(N))...)
                end
            end
            $(ret)
        end
    end

    @inline function trapz(xs::T, M) where {N,T<:NTuple{N}}
        rM=trapz(last(xs),M)
        return trapz(rtail(xs),rM)
    end

    @inline function trapz(xs::T, M) where {N,T<:NTuple{0}}
        return M
    end

    @inline function trapz(x, y, axis::Int)
        trapz((x,),y,(axis,))
    end

    @inline function trapz(xs::NTuple{N}, M::CM, axes::NTuple{N,Int}) where {N, T, S, CM <: AbstractArray{T,S}}
        permutation = getpermutation(M,axes)
        trapz(xs, PermutedDimsArray(M, permutation))
    end

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
        trapz((vx,vy),z) # equivalent to trapz(vx, trapz(vy, z))
    ```
            Result ≈ 4/3

        2-D Example in reverse integration order:
    ```julia
        vx=0:0.01:1
        vy=0:0.01:2
        z=[x^2+y^2 for x=vx, y=vy]
        trapz((vy,vx),z,(2,1)) # equivalent to trapz(vy, trapz(vx, z, 1), 1)
    ```
            Result ≈ 4/3
    """
    trapz
end # module
