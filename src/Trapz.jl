module Trapz
    export trapz

    include("tupletools.jl")

    @inline function kernel_trapz(x::V, y::M) where {Tm, Nm, M <: AbstractArray{Tm,Nm},Tv,Nv,V <: AbstractArray{Tv,Nv}}
        sy=size(y)
        N=length(x)
        @boundscheck begin
            @assert sy[Nm]==N "Integration axis over `y` is incompatible with `x`. Make sure their length match!"
            @assert maximum(size(x))==N "`x` is not vector-like."
        end
        res=zeros(promote_type(Tm,Tv),rtail(sy))
        N <= 1 && return res
        @simd for ids in CartesianIndices(res)
            @inbounds res[ids]+=(x[2]-x[1])*y[Tuple(ids)...,1]
        end
        for i in 2:(N-1)
            @simd for ids in CartesianIndices(res)
                @inbounds res[ids]+=(x[i+1]-x[i-1])*y[Tuple(ids)...,i]
            end
        end
        @simd for ids in CartesianIndices(res)
            @inbounds res[ids]+=(x[end]-x[end-1])*y[Tuple(ids)...,N]
        end
        res./2
    end

    function trapz(x::AbstractArray{S}, y::AT) where {S,T,AT<:AbstractArray{T,0}}
        return zero(promote_type(T,S))
    end

    function trapz(x::AbstractArray, y::AT) where {T,AT<:AbstractVector{T}}
        kernel_trapz(x, y)[1]
    end

    function trapz(x::AbstractArray, y::AT) where {T,N,AT<:AbstractArray{T,N}}
        kernel_trapz(x, y)
    end

    @inline function trapz(xs::T, M) where {N,T<:NTuple{N}}
        return trapz(rtail(xs),@inbounds trapz(last(xs),M))
    end

    @inline function trapz(xs::T, M) where {N,T<:NTuple{0}}
        return M
    end

    @inline function trapz(x, y, axis::Int)
        trapz((x,),y,(axis,))
    end

    @inline function trapz(xs::NTuple{N}, M, axes::NTuple{N,Int}) where N
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
