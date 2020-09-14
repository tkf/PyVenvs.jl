module TestAqua

import Aqua
using PyVenvs

Aqua.test_all(
    PyVenvs;
    project_extras = false,  # Julia 1.0 not supported since Scratch.jl doesn't
    stale_deps = true,
    deps_compat = true,
    project_toml_formatting = true,
)

end  # module
