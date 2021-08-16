@inline function putindex(ids::NTuple{N,T},val_axis::Val{axis},i::T) where {T,N,axis}
    @inbounds A=ntuple(i->ids[i],Val(axis-1))
    @inbounds B=ntuple(i->ids[i+axis-1],Val(N-axis+1))
    (A...,i,B...)
end

@inline function extrudeindex(ids::NTuple{N},val_axis::Val{axis}) where {N,axis}
    @inbounds A=ntuple(i->ids[i],Val(axis-1))
    @inbounds B=ntuple(i->ids[i+axis],Val(N-axis))
    (A...,B...)
end

@inline function purge(x::R) where {N,T,R<:AbstractArray{T,N}}
    x
end
@inline function purge(x::R) where {T,R<:AbstractArray{T,0}}
    x[]
end
@inline function integrate(x::V, y::M, val_axis::Val{axis}) where {axis,Tm, Nm, M <: AbstractArray{Tm,Nm},Tv,Nv,V <: AbstractArray{Tv,Nv}}
    sy=size(y)
    N=length(x)
    @boundscheck begin
        @assert sy[axis]==N "Integration axis over `y` is incompatible with `x`. Make sure their length match!"
        @assert maximum(size(x))==N "`x` is not vector-like."
    end
    out_type = typeof(oneunit(Tm) * oneunit(Tv))
    res=zeros(out_type,extrudeindex(sy,val_axis))
    @inline idx(I,j) = CartesianIndex(putindex(Tuple(I),val_axis,j))
    N <= 1 && return purge(res)
    @simd for ids in CartesianIndices(res)
        @inbounds res[ids]+=(x[2]-x[1])*y[idx(ids,1)]
    end
    for i in 2:(N-1)
        @simd for ids in CartesianIndices(res)
            @inbounds res[ids]+=(x[i+1]-x[i-1])*y[idx(ids,i)]
        end
    end
    @simd for ids in CartesianIndices(res)
        @inbounds res[ids]+=(x[end]-x[end-1])*y[idx(ids,N)]
    end
    @simd for ids in eachindex(res)
        @inbounds res[ids]/=2
    end
    purge(res)
end

@inline function integrate(x::Colon, y,a)
    y
end
function integrate(x::AbstractArray{S}, y::AT) where {S,T,AT<:AbstractArray{T,0}}
    return zero(promote_type(T,S))
end

@inline @generated function integrate(x::NTuple{N,Union{Colon,AbstractArray}}, y::M) where {Tm, N, M <: AbstractArray{Tm,N}}
    axis=ntuple(i->Val(i),Val(N))
    I=:(y)
    for i in N:-1:1
        I=:(integrate(x[$i],$I,$(axis[i])))
    end
    I
end

@inline function integrate(x::V, y::M) where {Tv, Nv, V <: AbstractArray{Tv,Nv} ,Tm, Nm, M <: AbstractArray{Tm,Nm}}
    integrate(x,y,Val(Nm))
end


"""

    @trapz range variable expression
Calculates integral of [expression] over [variable] in [range]

#### Example
julia> @trapz 0:0.01:1 x x*x

0.33335

"""
macro trapz(range,var,expr)
    quote
        let
        local r=$(esc(range))
        N=length(r)
        @assert N>=2 "null integration range"
        @inline f($(esc(var)))=$(esc(expr))
        @inbounds begin
            local t = (r[2].-r[1]).*f(r[1])
            @simd for i in 2:(N-1)
                t=t .+ f(r[i]).*(r[i+1].-r[i-1])
            end
            t = t .+ (r[end].-r[end-1]).*f(r[end])
        end
        t./2
        end
    end
end
