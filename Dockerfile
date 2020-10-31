# Base image
FROM paveloom/binder-julia:0.1.2

# Meta information
LABEL maintainer="Pavel Sobolev (https://github.com/Paveloom)"
LABEL version="0.1.2"
LABEL description="A playground for the `Exceptions.jl` package."
LABEL github-repository="https://github.com/paveloom-j/Exceptions.jl"
LABEL docker-repository="https://github.com/orgs/paveloom-j/packages/container/exceptions/"

# Install the package
RUN julia -e 'using Pkg; Pkg.add("Exceptions"); using Exceptions'

# Get the notebook
RUN wget https://raw.githubusercontent.com/paveloom-j/Exceptions.jl/master/binder/playground.ipynb >/dev/null 2>&1