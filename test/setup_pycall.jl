if Sys.islinux()
    @info "Do nothing in Linux; default setup should work."
else
    # Don't use Conda.jl in Windows and macOS
    withenv("PYTHON" => PyVenvs.Implementations.basepython()) do
        @info "Re-building PyCall..." ENV["PYTHON"]
        @time Pkg.build("PyCall")
    end
end
