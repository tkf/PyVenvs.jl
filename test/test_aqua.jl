module TestAqua

import Aqua
using PyVenvs

Aqua.test_all(
    PyVenvs;
    project_extras = true,
    stale_deps = true,
    deps_compat = true,
    project_toml_formatting = true,
)

end  # module
