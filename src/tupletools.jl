@inline function trapz_colon(k)
    Colon();
end

@inline function idxlast(i,::Val{N}) where N;
    Base.tail((ntuple(trapz_colon,Val(N))...,i))
end

@inline function buildaxes(T::X,A) where {N,X <: NTuple{N}}
    h=first(T)
    t=Base.tail(T)
    ifelse(h ∈ A,
        (buildaxes(t,A)...,h)
    ,
        (h,buildaxes(t,A)...)
    )
end

@inline function buildaxes(T::Tuple{},A)
    A
end

@inline function getpermutation(A::AbstractArray{fT,N},axes::T) where {fT,N,S,T<:NTuple{S}}
    ID=ntuple(identity,Val(N))
    ax=buildaxes(ID,axes)
    ntuple(i->@inbounds(ax[i]),Val(N))
end

@inline function rtail(T)
    Base.reverse(Base.tail(Base.reverse(T)))
end
