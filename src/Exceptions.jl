__precompile__()

"""
A package for the quick creation of customizable exceptions.

Links:
- Repo: https://github.com/paveloom-j/Exceptions.jl
- Docs: https://paveloom-j.github.io/Exceptions.jl
"""
baremodule Exceptions

"This module contains all inner parts of this package."
module Internal

export @exception

# Load exceptions
include("include/exceptions.jl")

# Load macros
include("include/exception.jl")

end

# Export the second-level components
using .Internal

# Export the first-level components
export @exception

end
