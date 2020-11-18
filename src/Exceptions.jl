__precompile__()

"""
A package for the quick creation of customizable exceptions.

Links:
- Repo: https://github.com/paveloom-j/Exceptions.jl
- Docs: https://paveloom-j.github.io/Exceptions.jl
"""
baremodule Exceptions

"This module contains all inner parts of this package."
baremodule Internal

export @exception

using Base

# Load exceptions
Base.include(Internal, "include/exceptions.jl")

# Load macros
Base.include(Internal, "include/exception.jl")

end

# Export the second-level components
using .Internal

# Export the first-level components
export @exception

end
