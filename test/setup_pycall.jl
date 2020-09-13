if Sys.islinux()
    @info "Do nothing in Linux; default setup should work."
else
    withenv("PYTHON" => Sys.which("python3")) do
        @info "Re-building PyCall..." ENV["PYTHON"]
        @time Pkg.build("PyCall")
    end
end
