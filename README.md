# Trapz.jl
A simple Julia package to perform trapezoidal integration over common Julia arrays.

[![Docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://juliahub.com/docs/Trapz/ze2sm/)
[![CI](https://github.com/francescoalemanno/Trapz.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/francescoalemanno/Trapz.jl/actions/workflows/ci.yml)

the package is now registered on Julia Registry, so it can be added as follows
````julia

import Pkg
Pkg.pkg"add Trapz"
````





## Main Usage Example:

````julia
using Trapz

vx=range(0,1,length=100)
vy=range(0,2,length=200)
vz=range(0,3,length=300)
M=[x^2+y^2+z^2 for x=vx,y=vy,z=vz]
I=trapz((vx,vy,vz),M)
print("result: ",I)
````


````
result: 28.00030
````





## Example Usage of `@trapz` macro:

````julia
using Trapz
using Printf
Base.show(io::IO, f::Float64) = @printf(io, "%1.5f", f)
function test(λ)
    R=@trapz 0:0.0001:π x (sin(λ*x)/2, cos(λ*x)/2, cos(λ*x)^2/π)
    print("λ = ",λ," result of integrals: ",R)
end

test(0.5)
````


````
λ = 0.50000 result of integrals: (0.99995, 1.00000, 0.50000)
````



````julia
test(1.0)
````


````
λ = 1.00000 result of integrals: (1.00000, 0.00005, 0.49997)
````



````julia
test(2.0)
````


````
λ = 2.00000 result of integrals: (0.00000, -0.00005, 0.49997)
````





# Benchmarks

````julia
using BenchmarkTools
@btime trapz($(vx,vy,vz),$M);
````


````
3.131 ms (4 allocations: 157.30 KiB)
````



````julia
@btime trapz($(:,vy, vz),$M);
````


````
3.084 ms (3 allocations: 157.20 KiB)
````



````julia
@btime trapz($(:,vy,:),$M);
````


````
4.090 ms (2 allocations: 234.45 KiB)
````





# Benchmarks & example for `@trapz` macro
in this example we are calculating 3 multidimensional integrals simultaneously, in other words we are calculating a multidimensional (3D) integral of a vector function

````julia
using BenchmarkTools
vx=range(0,1,length=100)
vy=range(0,2,length=200)
vz=range(0,3,length=300)

function integr(vx,vy,vz)
    @trapz vx x @trapz vy y @trapz vz z (x*x+y*y+z*z, x*y*z, cos(x*y)+cos(x*z)+cos(y*z))
end

@btime integr($vx,$vy,$vz)
````


````
129.633 ms (0 allocations: 0 bytes)
(28.00030, 4.50000, 9.93814)
````





# Comparison to Numpy

````julia
using PyCall
np=pyimport("numpy")

timenumpy = @belapsed np.trapz(np.trapz(np.trapz($M,$vz),$vy),$vx)
timejulia = @belapsed trapz($(vx,vy,vz),$M)

how_faster=timenumpy/timejulia

print("Trapz.jl is ~ ",how_faster," times faster than numpy's trapz")
````


````
Trapz.jl is ~ 7.34493 times faster than numpy's trapz
````
