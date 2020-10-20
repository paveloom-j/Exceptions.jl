# This piece of code defines the main macro of this package

"""
    @exception(macro_name::Symbol, args::Expr...; context::Expr=:()) -> Expr

Create a macro to create exceptions. Optionally inject context before defining
the structure.

# Arguments
- `macro_name::Symbol`: name of the macro
- `args::Tuple{Vararg{Expr}}`: a set of fields to be defined in the exception structure

# Keywords
- `context::Expr=:()`: expression evaluated before defining the exception structure

# Returns
- `Expr`: new macro definition

# Throws
- [`OnlyOneContext`](@ref): more than one context has been passed
- [`OnlyOneEquation`](@ref): more than one equation has been passed

# Example
```jldoctest; output = false
using Exceptions
using Suppressor
using SyntaxTree

macro_name = :name
args = (:(arg1::String), :(arg2::Int))
context = :()

EXCEPTIONS = Dict{Symbol, Any}()
EXCEPTIONS[:DocstringIsNotAString] = Exceptions.Internal.DocstringIsNotAString
EXCEPTIONS[:ErrorMessageIsNotAString] = Exceptions.Internal.ErrorMessageIsNotAString

d1 = @capture_out @macroexpand(@exception(name, arg1::String, arg2::Int)) |>
     linefilter! |> dump

d2 = @capture_out quote
    macro \$(macro_name)(
        exception_name::Symbol,
        docstring::Union{Expr, String},
        error_message_bits::Union{Expr, String, Char}...,
    )
        args = \$(args)

        error_header = "\$(__module__).\$(exception_name):"
        error_message_bits = ("\\n\\n\$(error_header)\\n", error_message_bits..., '\\n')

        \$(context)

        EX = \$(EXCEPTIONS)
        error_message_bits_filtered = filter(
            e -> typeof(e) == String || e.head ≠ :(.) && e.args[1] ≠ :(e),
            error_message_bits,
        )

        return esc(
            quote
                # Checks
                if !(\$(docstring) isa String)
                    throw(\$(EX[:DocstringIsNotAString])())
                end
                if !(string(\$(error_message_bits_filtered...)) isa String)
                    throw(\$(EX[:ErrorMessageIsNotAString])())
                end

                @doc \$(docstring)
                mutable struct \$(exception_name) <: Exception
                    \$(args...)
                end

                Base.showerror(io::IO, e::\$(module_name).\$(exception_name)) =
                print(io, \$(error_message_bits...))
            end
        )
    end
end |> linefilter! |> dump

d1 == d2

# output

true
```
"""
macro exception(
    macro_name::Symbol,
    args::Expr...,
)
    context_specified = false
    context = :()

    for (index, arg) in pairs(args)
        if typeof(arg) == Expr
            if arg.head == :(=)
                if arg.args[1] == :context
                    if context_specified
                        throw(OnlyOneContext())
                    else
                        context = args[index]
                        args = args[1:end .≠ index]
                        context_specified = true
                    end
                else
                    throw(OnlyOneEquation())
                end
            elseif arg.head ≠ :(::) || length(arg.args) ≠ 2
                throw(FieldsOnly())
            end
        end
    end

    return esc(
        quote
            macro $(macro_name)(
                exception_name::Symbol,
                docstring::Union{Expr, String},
                error_message_bits::Union{Expr, String, Char}...,
            )
                args = $(args)

                error_header = "$(__module__).$(exception_name):"
                error_message_bits = ("\n\n$(error_header)\n", error_message_bits..., '\n')

                $(context)

                EX = $(EXCEPTIONS)
                error_message_bits_filtered = filter(
                    e -> e isa Union{String, Char} || e.head ≠ :(.) && e.args[1] ≠ :(e),
                    error_message_bits,
                )

                return esc(
                    quote
                        # Checks
                        if !($(docstring) isa String)
                            throw($(EX[:DocstringIsNotAString])())
                        end
                        if !(string($(error_message_bits_filtered...)) isa String)
                            throw($(EX[:ErrorMessageIsNotAString])())
                        end

                        @doc $(docstring)
                        mutable struct $(exception_name) <: Exception
                            $(args...)
                        end

                        Base.showerror(io::IO, e::$(exception_name)) =
                        print(io, $(error_message_bits...))
                    end
                )
            end
        end
    )

end
