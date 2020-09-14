if Sys.islinux()
    @info "Do nothing in Linux; default setup should work."
else
    # Don't use Conda.jl in Windows and macOS
    let python
        if Sys.iswindows()
            python = something(
                Sys.which("python3.exe"),
                Sys.which("python3"),
                Sys.which("python.exe"),
                Sys.which("python"),
            )
        else
            python = something(Sys.which("python3"), Sys.which("python"))
        end
        withenv("PYTHON" => python) do
            @info "Re-building PyCall..." ENV["PYTHON"]
            @time Pkg.build("PyCall")
        end
    end
end
