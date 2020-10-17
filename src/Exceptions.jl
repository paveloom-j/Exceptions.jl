__precompile__()

baremodule Exceptions

module Internal

export @exception

# Load exceptions
include("exceptions.jl")

# Load macros
# include("exception.jl")

end

# Export the second-level components
using .Internal

# Export the first-level components
export @exception

end
