module TestPyVenvs
using Test

@testset "$file" for file in sort([
    file for file in readdir(@__DIR__) if match(r"^test_.*\.jl$", file) !== nothing
])
    if file == "test_pycall.jl"
        if lowercase(get(ENV, "CI", "false")) == "true"
            @info "Skip $file"
            continue
        end
    end
    include(file)
end

end  # module
