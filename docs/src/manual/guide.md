# Package Guide

This package is designed for both beginners who are not sure how to create an exception and
Julia power users who are tired of copying snippets of code containing structure definition
and overloading the `showerror` function.

It is assumed to be used by developers inside their packages, but the proposed macro should
be usable everywhere.

## Installation

The package is available in the [General](https://github.com/JuliaRegistries/General)
registry, so the installation process is quite simple: from the Julia REPL, type `]`
to enter the Pkg REPL mode and run:

```
pkg> add Exceptions
```

## Creating an exception

To create a new exception means to create a new data type that is a subtype of `Exception`.
In the simple case, it looks like this:

```@example Name
mutable struct Name <: Exception
end
```

You can throw such an exception immediately after creation, but the error message will not
be very informative:

```@example Name
try
  throw(Name())
catch e
  showerror(stdout, e)
end
```

However, it's pretty easy to fix. As shown in the example, the error message is displayed
by the `showerror` function, which means we can overload this function for our type:

```@example Name
Base.showerror(io::IO, e::Name) = print(io, "I'm gonna thrill you tonight")
```

Now let's check it out:

```@example Name
try
  throw(Name())
catch e
  showerror(stdout, e)
end
```

Okay, it's better. But what if we want to pass arguments to an exception when thrown? Not
a problem, additional arguments can be specified inside the type definition. The
corresponding constructor is created automatically:

```@example Name2
mutable struct Name <: Exception
    name::String
end

Base.showerror(io::IO, e::Name) = print(io, "I'm gonna thrill you tonight, ", e.name)

try
  throw(Name("Michael"))
catch e
  showerror(stdout, e)
end
```

Okay, it's not that hard. But wait, what if you need to create twenty such exceptions?
What if each of them should have a docstring with the same header and a description of
fields depending on the number of arguments the exception has? That's where the macro
provided by this package may be useful.

## [Using macro](@id UsingMacro)

When creating an exception set, you may encounter the fact that you need to define several
similar exceptions that have the same number of arguments but differ only by names.

For example, imagine the situation that you need to create five exceptions that don't
accept any arguments. For starters, we will create an auxiliary macro:

```@example exception
using Exceptions
@exception no_args
```

What's happened now? You have now created a helper macro that accepts as arguments
a name, a documentation string, and a set of chars, strings, and expressions for the error
message.

You can now create an exception like this:

```@example exception
@no_args e1 "Docstring" "ErrorMessage"
```

Yes, one line for the simplest case. Actually, let's do a few more.

```@example exception
@no_args e2 "Doc" * "string" "And though " "you fight " "to stay alive"
@no_args e3 string("Doc", "string") string("Your body ", "starts to shiver")
@no_args e4 sprint(print, "Docstring") join(["For no mere mortal", "can resist"], ' ')
@no_args e5 replace("Doc", "Doc" => "Docstring") ("The evil ", "of the thriller")...
```

As you can see, the second argument can be both a string and an exception. In doing so,
both it and the third argument must yield a string. The first argument can only be a string.

Let's look at this stanza:

```@example exception
for e in [e2, e3, e4, e5]
    try
        throw(e())
    catch e
        showerror(stdout, e)
    end
end
```

Okay, how about some arguments?

```@example exception
@exception one_arg name::String
@exception two_args name number::Int

@one_arg e6 "Docstring" "Gimme the cash, " e.name "!"
@two_args e7 "Docstring" "Is that a " e.name "-" e.number "? A very dangerous gun."

for e in [e6 => ("Korben",), e7 => ("Z", 140)]
    try
        throw(e.first(e.second...))
    catch e
        showerror(stdout, e)
    end
end
```

By this point, you're probably already interested in these headlines before the error
messages (perhaps, in how to get rid of them). See more about this on the
[Customization](@ref) page.
