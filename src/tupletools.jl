@inline function buildaxes(T::X,A) where {N,X <: NTuple{N}}
    h=first(T)
    t=Base.tail(T)
    ifelse(h ∈ A,
        (buildaxes(t,A)...,h)
    ,
        (h,buildaxes(t,A)...)
    )::NTuple
end

@inline function buildaxes(T::Tuple{},A)
    A
end

@inline function getpermutation(A::AbstractArray{fT,N},axes::T) where {fT,N,S,T<:NTuple{S}}
    ID=ntuple(identity,N)
    ax=buildaxes(ID,axes)
    ntuple(i->ax[i],N)
end

@inline function rtail(T)
    Base.reverse(Base.tail(Base.reverse(T)))
end
