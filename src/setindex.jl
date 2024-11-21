### Inputs: row scalar, column scalar; output: 
# Basic single value assignment
function Base.setindex!(ts::TSFrame, v::Any, i::Int, j::Int)
    ts.coredata[i, j+1] = v
    return ts
end

function Base.setindex!(ts::TSFrame, v::Any, i::Int, j::Union{Symbol,String})
    ts.coredata[i, j] = v
    return ts
end

# For time based indexing
function Base.setindex!(ts::TSFrame, v::Any, dt::T, j::Int) where {T<:TimeType}
    idx = findfirst(x -> x == dt, index(ts))
    ts.coredata[idx, j+1] = v
    return ts

end

function Base.setindex!(ts::TSFrame, v::Any, dt::T, j::Union{Symbol,String}) where {T<:TimeType}
    idx = findfirst(x -> x == dt, index(ts))
    ts.coredata[idx, j] = v
    return ts
end

# multiple rows, single column
function Base.setindex!(ts::TSFrame, v::AbstractVector, i::AbstractVector{Int}, j::Int)
    ts.coredata[i, j+1] = v
    return ts
end

function Base.setindex!(ts::TSFrame, v::AbstractVector, i::AbstractVector{Int}, j::Union{Symbol,String})
    ts.coredata[i, j] = v
    return ts
end

# Single row, multiple columns
function Base.setindex!(ts::TSFrame, v::Union{AbstractVector,Tuple}, i::Int, j::AbstractVector{Int})
    if length(v) != length(j)
        throw(DimensionMismatch("$(length(j)) columns selected but assigned $(length(v)) values"))
    end
    for (idx, val) in zip(j, v)
        ts.coredata[i, idx+1] = val
    end
    return ts
end

function Base.setindex!(ts::TSFrame, v::Union{AbstractVector,Tuple}, i::Int, j::AbstractVector{T}) where {T<:Union{Symbol,String}}
    if length(v) != length(j)
        throw(DimensionMismatch("$(length(j)) columns selected but assigned $(length(v)) values"))
    end
    for (col, val) in zip(j, v)
        ts.coredata[i, col] = val
    end
    return ts
end

# Range based indexing with Union types
function Base.setindex!(ts::TSFrame, v::Union{AbstractVector,AbstractRange,Tuple}, i::UnitRange, j::Int)
    ts.coredata[i, j+1] = v
    return ts
end

function Base.setindex!(ts::TSFrame, v::Union{AbstractVector,AbstractRange,Tuple}, i::UnitRange, j::Union{Symbol,String})
    ts.coredata[i, j] = v
    return ts
end

# Colon operator with Union types
function Base.setindex!(ts::TSFrame, v::Union{AbstractVector,AbstractRange,Tuple}, ::Colon, j::Int)
    ts.coredata[:, j+1] = v
    return ts
end

function Base.setindex!(ts::TSFrame, v::Union{AbstractVector,AbstractRange,Tuple}, ::Colon, j::Union{Symbol,String})
    ts.coredata[:, j] = v
    return ts
end

# Matrix assignment for multiple rows and columns

function Base.setindex!(ts::TSFrame, v::AbstractMatrix,
    i::Union{AbstractVector{Int},UnitRange,Colon},
    j::AbstractVector{Int})
    if size(v, 2) != length(j)
        throw(DimensionMismatch("Column dimensions don't match"))
    end
    for (col_idx, col) in enumerate(j)
        ts.coredata[i, col+1] = v[:, col_idx]
    end
    return ts
end