# PyVenvs: Julian interface for Pythonic virtual environments

```Julia
module MyPackage

using PyVenvs

@pyvenv CLI_VENV requirements="""
Pygments ==2.*
docutils ==0.16.*
"""

function __init__()
    PyVenvs.init(CLI_VENV)
end

pygmentize(args::Cmd) = Cmd(CLI_VENV, `pygmentize $args`)
rst2html(args::Cmd) = Cmd(CLI_VENV, `rst2html.py $args`)

end # module
```

## PyCall integration

```Julia
julia> using PyVenvs

julia> PyVenvs.init_pycall()

julia> using PyCall
```

Note that `PyVenvs.init_pycall` should _not_ be called in packages.
Typically, it should be called at the beginning of a script or REPL
session as soon as possible.
