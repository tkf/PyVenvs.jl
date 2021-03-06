module TestPyCall

using PyVenvs
using PyVenvs: PYCALL_VENV
using Test
using Pkg

if lowercase(get(ENV, "CI", "false")) == "true"
    include("setup_pycall.jl")
end

PyVenvs.init_pycall()
using PyCall

@testset "PyCall" begin
    if Sys.iswindows()
        @test_broken dirname(realpath(pyimport("sys").executable)) ==
                     dirname(realpath(PyVenvs.python(PYCALL_VENV)))
    else
        @test dirname(realpath(pyimport("sys").executable)) ==
              dirname(realpath(PyVenvs.python(PYCALL_VENV)))
    end
end

end  # module
