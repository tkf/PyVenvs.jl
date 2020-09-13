if Sys.islinux()
    @info "Do nothing in Linux; default setup should work."
else
    const Pkg =
        Base.require(Base.PkgId(Base.UUID("44cfe95a-1eb2-52ea-b672-e2afdf69b78f"), "Pkg"))

    ENV["PYTHON"] = Sys.which("python3")
    @info "Re-building PyCall..." ENV["PYTHON"]
    @time Pkg.build("PyCall")

    @info "Loading PyCall..."
    @time using PyCall
    @show pyimport("sys").executable
end
