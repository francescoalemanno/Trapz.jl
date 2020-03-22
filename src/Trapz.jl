module Trapz
    export trapz


    include("tupletools.jl")
    @inline function kernel_trapz(x::V,y::M) where {Tm,Nm,M <: AbstractArray{Tm,Nm},Tv,Nv,V <: AbstractArray{Tv,Nv}}
        kernel_trapz(x, y, IndexStyle(y))
    end

    @inline function kernel_trapz(x::T1, y::T2, ::IndexCartesian) where {N,N2,fT<:Real,T1<:AbstractArray{fT,N2},T2<:AbstractArray{fT,N}}
        n = length(x)
        s = size(y)
        @boundscheck begin
            @assert s[end]==n "Integration axis over `y` is incompatible with `x`. Make sure their length match!"
            @assert maximum(size(x))==n "`x` is not vector-like."
        end
        r = similar(y,rtail(s))
        if n <= 1
            r.=zero(fT)
            return r./2
        end
        @inbounds begin
            @fastmath r .= (x[2] - x[1]) .* view(y,idxlast(1,Val(N))...)
            for i in 2:n-1
               @fastmath r .+= (x[i+1] - x[i-1]) .* view(y,idxlast(i,Val(N))...)
            end
            @fastmath r .+= (x[end]-x[end-1]) .* view(y,idxlast(n,Val(N))...)
        end
        r./2
    end

    import Base.strides
    @inline function strides(x::T) where {T<:AbstractVector}
        (1,)
    end
    function kernel_trapz(x::V,y::M, ::IndexLinear) where {Tm,Nm,M <: AbstractArray{Tm,Nm},Tv,Nv,V <: AbstractArray{Tv,Nv}}
        sy=size(y)
        Tf=promote_type(Tm,Tv)
        N=length(x)
        @boundscheck begin
            @assert sy[Nm]==N "Integration axis over `y` is incompatible with `x`. Make sure their length match!"
            @assert maximum(size(x))==N "`x` is not vector-like."
        end
        d_idx=stride(y,Nm)
        res_size=Base.reverse(Base.tail(Base.reverse(sy)))
        res=zeros(Tf,res_size)
        @boundscheck N <= 1 && return res
        for i in 2:(N-1)
            @simd for ids in eachindex(res)
                @inbounds res[ids]+=(x[i+1]-x[i-1])*y[ids+d_idx*(i-1)]
            end
        end
        @simd for ids in eachindex(res)
            @inbounds res[ids]+=(x[2]-x[1])*y[ids+d_idx*(1-1)]+(x[end]-x[end-1])*y[ids+d_idx*(N-1)]
        end
        res./2
    end

    function trapz(x::AbstractArray{T}, y::AT) where {T,AT<:AbstractArray{T,0}}
        return zero(T)
    end

    function trapz(x::AbstractArray{T}, y::AT) where {T,AT<:AbstractVector{T}}
        kernel_trapz(x, y)[1]
    end

    function trapz(x::AbstractArray{T}, y::AT) where {T,N,AT<:AbstractArray{T,N}}
        kernel_trapz(x, y)
    end

    @inline function trapz(xs::T, M) where {N,T<:NTuple{N}}
        return trapz(rtail(xs),trapz(last(xs),M))
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
