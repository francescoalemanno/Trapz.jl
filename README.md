# Trapz.jl
A simple Julia package to perform trapezoidal integration over common Julia arrays.

[![Docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://pkg.julialang.org/docs/Trapz)
[![Build Status](https://travis-ci.com/francescoalemanno/Trapz.jl.svg?branch=master)](https://travis-ci.com/francescoalemanno/Trapz.jl)
[![codecov](https://codecov.io/gh/francescoalemanno/Trapz.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/francescoalemanno/Trapz.jl)

the package is now registered on Julia Registry, so it can be added as follows
```julia
import Pkg; Pkg.pkg"add Trapz"
```


## Example Usage:



```julia
using BenchmarkTools,Trapz
vx=range(0,1,length=100)
vy=range(0,2,length=200)
vz=range(0,3,length=300)
M=[x^2+y^2+z^2 for x=vx,y=vy,z=vz]
@show trapz((vx,vy,vz), M) # = 28.000303707970264
```

    trapz((vx, vy, vz), M) = 28.000303707970264


# Benchmarks

```julia
@benchmark trapz(($vx,$vy,$vz),$M)
```

    BenchmarkTools.Trial:
      memory estimate:  347.31 KiB
      allocs estimate:  607
      --------------
      minimum time:     4.564 ms (0.00% GC)
      median time:      4.655 ms (0.00% GC)
      mean time:        4.697 ms (0.13% GC)
      maximum time:     7.193 ms (0.00% GC)
      --------------
      samples:          1064
      evals/sample:     1

```julia
@benchmark trapz(($vy, $vz),$M)
```

    BenchmarkTools.Trial:
      memory estimate:  342.53 KiB
      allocs estimate:  506
      --------------
      minimum time:     4.600 ms (0.00% GC)
      median time:      4.816 ms (0.00% GC)
      mean time:        4.853 ms (0.12% GC)
      maximum time:     6.019 ms (0.00% GC)
      --------------
      samples:          1030
      evals/sample:     1

```julia
@benchmark trapz($vy,$M,2)
```

    BenchmarkTools.Trial:
      memory estimate:  482.16 KiB
      allocs estimate:  220
      --------------
      minimum time:     5.754 ms (0.00% GC)
      median time:      5.943 ms (0.00% GC)
      mean time:        5.988 ms (0.10% GC)
      maximum time:     7.572 ms (0.00% GC)
      --------------
      samples:          834
      evals/sample:     1


## Benchmark, when used inefficiently:

This code is optimized in order to perform the integral the fastest over the last dimension first, here instead we are performing integral in opposite order e.g. first x, then y, at last over z

```julia
@benchmark trapz(($vz,$vy,$vx),$M,(3,2,1))
```

    BenchmarkTools.Trial:
      memory estimate:  973.13 KiB
      allocs estimate:  617
      --------------
      minimum time:     26.366 ms (0.00% GC)
      median time:      27.183 ms (0.00% GC)
      mean time:        28.271 ms (0.05% GC)
      maximum time:     43.117 ms (0.00% GC)
      --------------
      samples:          177
      evals/sample:     1
