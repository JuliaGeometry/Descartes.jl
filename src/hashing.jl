

function Base.hash(a::AbstractPrimitive)
    # hash(a.(2), hash(a.(1)) )
    flds = fieldnames(a)
    h = hash(a.(1))
    for i = 2:length(flds)-1
        hash(a.(i), h)
    end
    h
end

function Base.isequal(a::AbstractPrimitive, b::AbstractPrimitive)
    hash(a) == hash(b)
end
