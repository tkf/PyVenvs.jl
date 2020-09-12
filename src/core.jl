macro pyvenv(envname, options...)
    quote
        const $envname = $PyVenv($__module__, $(String(envname)); $(options...))
    end |> esc
end

struct PyVenv
    pkg::Union{Nothing,Module}
    version::Union{Nothing,VersionNumber}
    name::String
    requirements::Union{Nothing,String}
end

function PyVenv(pkg, name; requirements = nothing)
    if pkg isa Module
        version = _pkgversion(pkg)
    else
        version = nothing
    end
    return PyVenv(pkg, version, name, requirements)
end

function Base.show(io::IO, venv::PyVenv)
    if venv.pkg === nothing
        invoked(show, Tuple{IO,Any}, io, venv)
        return
    end
    show(io, venv.pkg)
    print(io, '.', venv.name)
    return
end

function rootmodule(m::Module)
    p = parentmodule(m)
    p === m && return m
    return rootmodule(p)
end

function _pkgversion(pkg::Module)
    p = pathof(rootmodule(pkg))
    p === nothing && return p
    return _pkgversion(joinpath(dirname(dirname(p)), "Project.toml"))
end

function _pkgversion(project::AbstractString)
    return VersionNumber(TOML.parsefile(project)["version"])
end

basepython() = get(ENV, "PYVENVS_JL_PYTHON", "python3")
# TODO: Use `Preferences` when released

mkvenv(venv::PyVenv) = mkvenv(venvpath(venv))
mkvenv(path) = run(`$(basepython()) -m venv $path`)
# TODO: support virtualenv?

function scratchkey(venv::PyVenv)
    raw = "pyvenv-$(venv.name)-$(venv.version)"
    name = replace(raw, r"[^-.a-zA-Z0-9]" => "-")
    slug = bytes2hex(sha1(raw))
    return "$name-$slug"
end

scratchpath(venv::PyVenv) = get_scratch!(@__MODULE__, scratchkey(venv), venv.pkg)

venvpath(venv::PyVenv) = joinpath(scratchpath(venv), "venv")

function binpath(venv::PyVenv)
    path = venvpath(venv)
    if Sys.iswindows()
        return joinpath(path, "Scripts")
    else
        return joinpath(path, "bin")
    end
end

function python(venv::PyVenv)
    if Sys.iswindows()
        return joinpath(binpath(venv), "python.exe")
    else
        return joinpath(binpath(venv), "python")
    end
end

Base.Cmd(venv::PyVenv, cmd::Cmd) = Cmd(venv, cmd.exec)
Base.Cmd(venv::PyVenv, exe::AbstractString) = Cmd(venv, [exe])
function Base.Cmd(venv::PyVenv, argv::AbstractVector{<:AbstractString})
    exe = joinpath(binpath(venv), argv[1])
    return `$exe $(argv[2:end])`
end

pip(venv, args) = `$(python(venv)) -m pip $args`

function needs_init(venv::PyVenv)
    isfile(python(venv)) || return true
    # TODO: compare python version?
    # TODO: check dependencies
    return false
end

_with_python(f, ::Nothing) = f()
function _with_python(f, py::AbstractString)
    # TODO: don't use `withenv`
    withenv("PYVENVS_JL_PYTHON" => py) do
        f()
    end
end

function init(venv::PyVenv; python = nothing)::PyVenv
    _with_python(python) do
        needs_init(venv) || return venv
        install(venv)
        return venv
    end
end

function _run(cmd)
    @info "Run: $cmd"
    return run(cmd)
end

function install(venv::PyVenv; upgrade::Bool = false)::PyVenv
    isfile(python(venv)) || mkvenv(venv)
    if venv.requirements !== nothing
        @info "Installing requirements for $venv"
        _run(pip(venv, `install --upgrade pip`))
        mktemp() do path, io
            write(io, venv.requirements)
            close(io)
            opts = upgrade ? `` : `--upgrade`
            _run(pip(venv, `install $opts --requirement $path`))
        end
    end
    return venv
end

function Base.rm(venv::PyVenv)
    delete_scratch!(@__MODULE__, scratchkey(venv))
end
