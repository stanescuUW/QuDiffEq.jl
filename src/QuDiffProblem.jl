export QuLDEProblem
"""
Linear ODE Problem definition

"""
struct QuODEFunction{iip,PType}<: DiffEqBase.AbstractODEFunction{iip}
    linmatrix::Array{PType,2}
    QuODEFunction(linmatrix::Array{Complex{PType},2}) where PType = new{true,Complex{PType}}(linmatrix)
    QuODEFunction(linmatrix::Array{PType,2}) where PType = new{true,Complex{PType}}(linmatrix)
end

abstract type QuODEProblem{uType,tType,isinplace} <: DiffEqBase.AbstractODEProblem{uType,tType,isinplace} end

struct QuLDEProblem{uType,tType,isinplace, F, P} <: QuODEProblem{uType,tType,isinplace}
    A::F
    b::P
    u0::uType
    tspan::Tuple{tType,tType}
    function QuLDEProblem(A::QuODEFunction{iip,CPType},b::Array{T,1},u0::Array{G,1},tspan;kwargs...) where {iip,CPType,T,G}
        new{Array{CPType,1},typeof(tspan),iip,typeof(A.linmatrix),Array{CPType,1}}(A.linmatrix,b,u0,tspan)
    end
    function QuLDEProblem(A,b::Array{T,1},u0::Array{G,1},tspan;kwargs...,) where {T,G}
        f = QuODEFunction(A)
        CPType = eltype(f.linmatrix)
        new{Array{CPType,1},typeof(tspan[1]),isinplace(f),typeof(f.linmatrix),Array{CPType,1}}(f.linmatrix,b,u0,tspan)
    end
end
