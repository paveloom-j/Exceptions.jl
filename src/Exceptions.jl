__precompile__()

baremodule Exceptions

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
