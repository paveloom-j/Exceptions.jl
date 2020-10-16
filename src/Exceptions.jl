__precompile__()

baremodule Exceptions

module Internal

export @exception

# Load macros
include("exception.jl")

# Load exceptions
include("exceptions.jl")

end

# Export the second-level components
using .Internal

# Export the first-level components
export @exception

end
