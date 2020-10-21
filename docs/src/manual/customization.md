# Customization

Let's look at what the [`@exception`](@ref) macro returns. In a slightly simplistic way,
it looks like this:

```julia
@doc $(docstring)
mutable struct $(exception_name) <: Exception
    $(args...)
end

Base.showerror(io::IO, e::$(exception_name)) =
print(io, $(error_message_bits...))
```

All of that gets put in a quote, and variables / expressions with a dollar symbol get
interpolated.

What are these values equal? Well, `args` is the second and all the following arguments
passed to the main macro; `exception_name`, `docstring`, and `error_message_bits` are
arguments of an auxiliary macro created by the main macro.

Let's check it out:

```@example context
using Exceptions
@exception m
@m MyException "Docstring" "ErrorMessage"
try
    throw(MyException())
catch e
    showerror(stdout, e)
end
```

What is that headline, you might ask? For an answer, let's look a little further
behind the scenes:

```julia
args = $(args)

error_header = "$(__module__).$(exception_name):"
error_message_bits = ("\n\n$(error_header)\n", error_message_bits..., '\n')

$(context)

return esc(
    quote
        @doc $(docstring)
        mutable struct $(exception_name) <: Exception
            $(args...)
        end

        Base.showerror(io::IO, e::$(exception_name)) =
        print(io, $(error_message_bits...))
    end
)
```

As you can see, `error_message_bits` get intentionally modified before the interpolation.
That's what might be called the default context. The module in which the macro is invoked
and the exception name get specified in the row before the error message. This piece of
information gets separated by newlines on both sides.

This strange module name appears because these outputs get generated with the documentation.
If you run the snippet above in the REPL, the module name will be equal to `Main`.

What's not mentioned about this snippet yet? Ah, yes, the most important thing. See the
`$(context)` interpolation at the top level? That's your ticket to almost unlimited
customization. Any variables mentioned may be modified to obtain the desired result.

All one has to do is to pass the `context` keyword with a block of code when using the
main macro. Like this:

```@example context
@exception m context = begin
    error_message_bits = error_message_bits[2:end-1]
end
```

With this snippet, we canceled the default changes for the error message. This gives us the
following:

```@example context
@m MyException2 "Docstring" "What can I say except you're welcome"
try
    throw(MyException2())
catch e
    showerror(stdout, e)
end
```

Note that it is the code block (`begin end`) that should be passed as the context,
not the quote (`quote end`) or the expression (`:()`).

Further, it all depends only on your goals and imagination. See also the macro's
documentation string ([`@exception`](@ref)) for a full picture of what's going on behind
the scenes and what you can influence. You can also see the real use of this macro in the
code of the
[PDFHighlights.jl](https://github.com/paveloom-j/PDFHighlights.jl/blob/master/src/Exceptions/Exceptions.jl)
package.
