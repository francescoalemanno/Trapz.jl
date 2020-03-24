# Trapz.jl
A simple Julia package to perform trapezoidal integration over common Julia arrays.

[![Docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://pkg.julialang.org/docs/Trapz)
[![Build Status](https://travis-ci.com/francescoalemanno/Trapz.jl.svg?branch=master)](https://travis-ci.com/francescoalemanno/Trapz.jl)
[![codecov](https://codecov.io/gh/francescoalemanno/Trapz.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/francescoalemanno/Trapz.jl)

the package is now registered on Julia Registry, so it can be added as follows
````julia

import Pkg
Pkg.pkg"add Trapz"
````





## Example Usage:

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
result: 28.000303707970264
````





# Benchmarks

````julia
using BenchmarkTools
@btime trapz($(vx,vy,vz),$M);
````


````
2.793 ms (4 allocations: 157.30 KiB)
````



````julia
@btime trapz($(:,vy, vz),$M);
````


````
3.046 ms (3 allocations: 157.20 KiB)
````



````julia
@btime trapz($(:,vy,:),$M);
````


````
4.022 ms (2 allocations: 234.45 KiB)
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
Trapz.jl is ~ 7.2802292929009 times faster than numpy's trapz
````


