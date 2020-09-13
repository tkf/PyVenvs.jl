module CLIVenvExample

using PyVenvs

@pyvenv CLI_VENV requirements = """
  Pygments ==2.*
  docutils ==0.16.*
  """

function __init__()
    PyVenvs.init(CLI_VENV)
end

pygmentize(args::Cmd) = Cmd(CLI_VENV, `pygmentize $args`)
rst2html(args::Cmd) = Cmd(CLI_VENV, `rst2html.py $args`)

end # module
