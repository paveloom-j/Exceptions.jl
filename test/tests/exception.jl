# This file contains tests for the `@exception` macro

module TestException

using Exceptions
using SyntaxTree
using Test

# Print the header
println("\e[1;32mRUNNING\e[0m: exception.jl")

macro test_throws(exception::Expr, expr::Expr)
    return esc(
        quote
            try
                eval($(expr) |> linefilter!)
            catch e
                if e isa LoadError
                    @test sprint(showerror, e) == """
                    LoadError: $(sprint(showerror, $(exception)()))
                    in expression starting at <macrocall>:0"""
                elseif !(e isa $(exception))
                    rethrow()
                end
            end
        end
    )
end

@testset "@exception" begin

    @test_nowarn eval(quote @exception m0 end)
    @test_nowarn eval(quote @exception m1 file::String end)
    @test_nowarn eval(quote
        @exception m2 file::String s::Symbol context = begin
            docstring = "Doc" * docstring
        end
    end)
    @test_nowarn eval(quote @exception m3 file s::Symbol end)

    @test_throws(
        Exceptions.Internal.OnlyOneEquation,
        quote @exception(m, var=v1) end,
    )

    @test_throws(
        Exceptions.Internal.FieldsOnly,
        quote @exception(m, 1+1) end,
    )

end

# No arguments (macro)
@testset "@m0" begin

    @test_nowarn eval(quote @m0 e0 "Docstring" "ErrorMessage" end)

    @test_throws(
        Exceptions.Internal.DocstringIsNotAString,
        quote @m0 e 1+1 "ErrorMessage" end
    )

    @test_throws(
        Exceptions.Internal.ErrorMessageIsNotAString,
        quote @m0 e "ErrorMessage" 2+2 end
    )

end

# No arguments (exception)
@testset "e0" begin

    @test fieldnames(e0) == ()
    @test "$(@doc(e0))" == "Docstring\n"
    @test sprint(showerror, e0()) == "\n\nMain.TestException.e0:\nErrorMessage\n"

end

# One argument
@testset "@m1" begin

    @test_nowarn eval(quote @m1 e1 "Docstring" "ErrorMessage" end)

end

# One arguments
@testset "e1" begin

    @test fieldnames(e1) == (:file,)

end

# Two arguments and a context
@testset "@m2" begin

    @test_nowarn eval(quote @m2 e2 "string" "ErrorMessage" end)

end

# Two arguments and a context
@testset "e2" begin

    @test fieldnames(e2) == (:file, :s)
    @test "$(@doc(e2))" == "Docstring\n"

end

# Arguments with type `Any`
@testset "@m3" begin

    @test_nowarn eval(quote @m3 e3 "Docstring" "ErrorMessage" end)
    @test e3.types[1] == Any
    @test e3.types[2] == Symbol

end

end
