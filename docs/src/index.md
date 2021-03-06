# Exceptions.jl

_Easy exception creation._

```@raw html

<table style="width: fit-content; border-collapse: collapse;">
  <tbody>
    <tr>
      <th style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Code Coverage
      </th>

      <th style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Repository & License
      </th>

      <th style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        Playground
      </th>
    </tr>
    <tr>
      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        <a href="https://codecov.io/gh/paveloom-j/Exceptions.jl" style="position: relative; bottom: -2px;">
          <img src="https://codecov.io/gh/paveloom-j/Exceptions.jl/branch/master/graph/badge.svg" />
        </a>
      </td>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        <a href="https://github.com/paveloom-j/Exceptions.jl" style="position: relative; bottom: -2px;">
          <img src="https://img.shields.io/badge/GitHub-paveloom--j%2FExceptions.jl-5DA399.svg">
        </a>
        <a href="https://github.com/paveloom-j/Exceptions.jl/blob/master/LICENSE.md" style="position: relative; bottom: -2px;">
          <img src="https://img.shields.io/badge/license-MIT-5DA399.svg">
        </a>
      </td>

      <td style="text-align: center; border: 1px solid lightgray; padding: 6px 12px;">
        <a href="https://mybinder.org/v2/gh/paveloom-j/Exceptions.jl/master?urlpath=lab/tree/playground.ipynb" style="position: relative; bottom: -2px;">
          <img src="https://mybinder.org/badge_logo.svg">
        </a>
      </td>
    </tr>
  </tbody>
</table>

```

A package for the quick creation of customizable exceptions.

## Package Features

- [Create](@ref UsingMacro) exceptions with simple macro calls
- [Customize](@ref Customization) any bits of exceptions to your liking

## Manual Outline

```@contents
Pages = map(
    s -> "manual/$(s)",
    ["guide.md", "customization.md"],
)
```

## Library Outline

```@contents
Pages = map(
    s -> "lib/$(s)",
    ["index.md", "public.md", "internals.md"],
)
```

Logo from [icons8.com](https://icons8.com).
