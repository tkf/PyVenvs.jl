let path = joinpath(dirname(@__DIR__), "examples")
    if !(path in LOAD_PATH)
        push!(LOAD_PATH, path)
    end
end
