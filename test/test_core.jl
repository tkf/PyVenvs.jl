module TestCore

include("preamble.jl")

using CLIVenvExample: CLI_VENV, pygmentize, rst2html
using PyVenvs
using Test

function readstd(cmd)
    io = IOBuffer()
    run(pipeline(cmd, stdout = io, stderr = io))
    return String(take!(io))
end

@testset begin
    py = PyVenvs.python(CLI_VENV)
    @test isfile(py)
    @test occursin(r"[0-9]+\.[0-9]+\.[0-9]+", read(`$py --version`, String))
    @test occursin(r"\bpip\b", readstd(PyVenvs.pip(CLI_VENV, `help`)))
    @test occursin("pygmentize", readstd(pygmentize(`-h`)))
    if Sys.iswindows()
        @test_broken occursin("rst2html", readstd(rst2html(`--help`)))
    else
        @test occursin("rst2html", readstd(rst2html(`--help`)))
    end
    @test PyVenvs.init(CLI_VENV) isa Any
end

end  # module
