"""
    PyVenvs.init_pycall([venv]; check = true, quiet = false)

Import PyCall with `venv`.
"""
init_pycall

function init_pycall_impl(venv)
    pycallid = PkgId(UUID("438e738f-606a-5dbb-bf0a-cddfbfd45ab0"), "PyCall")
    if haskey(Base.loaded_modules, pycallid)
        return ErrorException("PyCall is already loaded")
    end
    # TODO: check PyCall's deps.jl
    ENV["PYCALL_JL_RUNTIME_PYTHON"] = python(init(venv))::String
    Base.require(pycallid)
    return
end

function init_pycall(venv = PyVenvs.PYCALL_VENV; check = true, quiet = false)
    err = init_pycall_impl(venv)
    err === nothing && return
    if check
        throw(err)
    else
        quiet || @warn sprint(showerror, err)
    end
end
