

function Base.hash(a::AbstractPrimitive)
    # need special hash since primitives might not be immutable
    flds = fieldnames(a)
    h = hash(flds) # field symbols
    hash(typeof(a), h) # typename
    for i = 1:length(flds)
        h = hash(a.(i), h) # values
    end
    h
end

function Base.isequal(a::AbstractPrimitive, b::AbstractPrimitive)
    hash(a) == hash(b)
end
