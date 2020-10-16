# This piece of code creates a helper macro to create exceptions
# that will be thrown when the main macro is not used correctly

# Did you watch Inception?

@exception aux

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
