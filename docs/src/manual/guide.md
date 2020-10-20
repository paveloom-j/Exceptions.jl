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
