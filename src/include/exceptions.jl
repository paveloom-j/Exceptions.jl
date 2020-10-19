# This piece of code creates a helper macro to create exceptions
# that will be thrown when the main macro is not used correctly

# Did you watch Inception?

exceptions = Dict{Symbol, Any}()

macro aux(
    exception_name::Symbol,
    docstring::Union{Expr, String},
    error_message_bits::Union{Expr, String}...,
)
    module_name = __module__
    error_header = "$(module_name).$(exception_name):"

    return esc(
        quote
            @doc $(docstring)
            mutable struct $(exception_name) <: Exception
            end

            Base.showerror(io::IO, e::$(module_name).$(exception_name)) =
            print(
                io, string(
                    '\n', '\n',
                    $(error_header), '\n',
                    $(error_message_bits...), '\n',
                )
            )

            exceptions[$(QuoteNode(exception_name))] = $(exception_name)
        end
    )
end

@aux(
    DocstringIsNotAString,
    "Exception thrown when the passed expression for docstring does not yield a string.",
    "The passed expression for docstring does not yield a string."
)

@aux(
    ErrorMessageIsNotAString,
    "Exception thrown when the passed expression(s) for error message (do)es " *
    "not yield a string.",
    "The passed expression(s) for error message (do)es not yield a string."
)

@aux(
    FieldsOnly,
    "Exception thrown when the passed argument is not a structure field.",
    "The passed argument is not a structure field (e.g. `file::String` or `file`)."
)

@aux(
    OnlyOneContext,
    "Exception thrown when more than one context has been passed.",
    "Only one `context` specification is allowed.",
)

@aux(
    OnlyOneEquation,
    "Exception thrown when non-context equation has been passed.",
    "Equation is only available for one expression with the first argument " *
    "equal to `context`.",
)
