using Documenter # A package to manage documentation
using Exceptions # A package to create the documentation for

# Create documentation
makedocs(
    # Specify modules being used
    modules = [Exceptions],

    # Specify a name for the site
    sitename = "Exceptions.jl",

    # Specify the author
    authors = "Pavel Sobolev",

    # Specify the pages on the left side
    pages = [
        "Home" => "index.md",

        "Library" => [
            "Index" => "lib/index.md",
            "Public" => "lib/public.md",
            "lib/internals.md",
        ],
    ],

    # Specify a format
    format = Documenter.HTML(
            # Custom assets
            assets = ["assets/custom.css"],
            # A fallback for creating docs locally
            prettyurls = get(ENV, "CI", nothing) == "true",
        ),

    # Fail if any error occurred
    strict = true,
)

# Deploy documentation
deploydocs(
    # Specify a repository
    repo = "github.com/paveloom-j/Exceptions.jl.git",

    # Specify a development branch
    devbranch = "develop",
)
