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
    @test occursin("pygmentize", readstd(pygmentize(`-h`)))
    @test occursin("rst2html", readstd(rst2html(`--help`)))
end

end  # module