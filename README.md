# Trapz.jl
A simple Julia package to perform trapezoidal integration over common Julia arrays.

[![Docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://juliahub.com/docs/Trapz/ze2sm/)
[![CI](https://github.com/francescoalemanno/Trapz.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/francescoalemanno/Trapz.jl/actions/workflows/ci.yml)

the package is now registered on Julia Registry, so it can be added as follows
````julia-repl

julia> import Pkg
julia> Pkg.add("Trapz")
````



## Main Usage Example:

````julia-repl
julia> using Trapz

julia> vx = range(0, 1, length=100);
julia> vy = range(0, 2, length=200);
julia> vz = range(0, 3, length=300);

julia> M = [x^2+y^2+z^2 for x=vx, y=vy, z=vz];

julia> trapz((vx,vy,vz), M)
28.000303707970264

````



## Example Usage of `@trapz` macro:

````julia-repl
julia> using Trapz

julia> using Printf

julia> Base.show(io::IO, f::Float64) = @printf(io, "%1.5f", f)

julia> function test(λ)
           R = @trapz 0:0.0001:π x (sin(λ*x)/2, cos(λ*x)/2, cos(λ*x)^2/π)
           println("λ = ", λ, " result of integrals: ", R)
       end

julia> test(0.5)
λ = 0.50000 result of integrals: (0.99995, 1.00000, 0.50000)

julia> test(1.0)
λ = 1.00000 result of integrals: (1.00000, 0.00005, 0.49997)

julia> test(2.0)
λ = 2.00000 result of integrals: (0.00000, -0.00005, 0.49997)
````



# Benchmarks

````julia-repl
julia> using BenchmarkTools, Trapz

julia> vx = range(0, 1, length=100);
julia> vy = range(0, 2, length=200);
julia> vz = range(0, 3, length=300);
julia> M = [x^2+y^2+z^2 for x=vx, y=vy, z=vz];

julia> @btime trapz($(vx,vy,vz),$M);
  3.131 ms (4 allocations: 157.30 KiB)

julia> @btime trapz($(:,vy, vz),$M);
  3.084 ms (3 allocations: 157.20 KiB)

julia> @btime trapz($(:,vy,:),$M);
  4.090 ms (2 allocations: 234.45 KiB)
````



# Benchmarks & example for `@trapz` macro
In this example we are calculating 3 multidimensional integrals simultaneously.
In other words, we are calculating a multidimensional (3D) integral of a vector function.

````julia
julia> using BenchmarkTools, Trapz

julia> vx = range(0, 1, length=100);
julia> vy = range(0, 2, length=200);
julia> vz = range(0, 3, length=300);

julia> function integr(vx,vy,vz)
           @trapz vx x @trapz vy y @trapz vz z (x*x+y*y+z*z, x*y*z, cos(x*y)+cos(x*z)+cos(y*z))
       end
integr (generic function with 1 method)

julia> @btime integr($vx,$vy,$vz)
129.633 ms (0 allocations: 0 bytes)
(28.00030, 4.50000, 9.93814)
````



# Comparison to Numpy

````julia-repl
julia> using PyCall, BenchmarkTools, Trapz, Printf
julia> np = pyimport("numpy")

julia> vx = range(0, 1, length=100);
julia> vy = range(0, 2, length=200);
julia> vz = range(0, 3, length=300);
julia> M = [x^2+y^2+z^2 for x=vx, y=vy, z=vz];

julia> timenumpy = @belapsed np.trapz(np.trapz(np.trapz($M,$vz),$vy),$vx)
0.034568359

julia> timejulia = @belapsed trapz($(vx,vy,vz),$M)
0.005257729

julia> speedup = timenumpy/timejulia;
julia> @printf("Trapz.jl is ~%1.5f times faster than numpy's trapz", speedup)
Trapz.jl is ~6.57477 times faster than numpy's trapz
````
