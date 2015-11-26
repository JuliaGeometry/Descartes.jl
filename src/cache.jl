# globals
global use_cache = true

const cache_loc = joinpath(dirname(@__FILE__), "../.cache")

function cache_init()
    !isdir(cache_loc) && mkdir(cache_loc)
end

"""
Allows the caching mechanism in Descartes to be disabled (`Cache.enabled(false)`)
and enabled(`Cache.enabled(false)`).
"""
function cache_enabled(t::Bool)
    global use_cache = t
end

"""
Get the JLD cache for a primitive.
"""
function cache_location(a::AbstractPrimitive)
    hn = hash(a)
    joinpath(cache_loc, "$hn.jld")
end

"""
Load an object from the primitive cache.
"""
function cache_load(a::AbstractPrimitive, key)
    fl = cache_location(a)
    jldopen(fl, "r") do f
        read(f, key)
    end
end

"""
Add `obj` under `key` to the primitive's cache.
"""
function cache_add(a::AbstractPrimitive, key, obj)
    fl = cache_location(a)
    !isfile(fl) && touch(fl)
    jldopen(fl, "w") do f
        write(f, key, obj)
    end
end

"""
Check if the cache contains the primitive and key
"""
function cache_contains(a::AbstractPrimitive, key)
    fl = cache_location(a)
    if isfile(fl)
        # check if the key is in there
        return jldopen(fl) do f
                   key in names(f)
               end
    else
        return false
    end
end

