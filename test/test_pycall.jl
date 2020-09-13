module TestPyCall

using PyVenvs
using PyVenvs: PYCALL_VENV
using Test

PyVenvs.init_pycall()
using PyCall

@testset "PyCall" begin
    @test dirname(realpath(pyimport("sys").executable)) ==
          dirname(realpath(PyVenvs.python(PYCALL_VENV)))
end

end  # module
