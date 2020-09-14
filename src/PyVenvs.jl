baremodule PyVenvs

export @pyvenv

function init end
function init_pycall end
function install end
function pip end
function python end

module Implementations
using Base: PkgId, UUID
using Pkg: TOML
using SHA: sha1
using Scratch

import ..PyVenvs: init, init_pycall, install, pip, python
using ..PyVenvs: PyVenvs

include("core.jl")
include("pycall.jl")
end  # module

using .Implementations: @pyvenv

@pyvenv PYCALL_VENV requirements = """
numpy ==1.*
"""

end
