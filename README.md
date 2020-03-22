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
      memory estimate:  314.52 KiB
      allocs estimate:  8
      --------------
      minimum time:     3.092 ms (0.00% GC)
      median time:      3.325 ms (0.00% GC)
      mean time:        3.361 ms (0.13% GC)
      maximum time:     5.472 ms (26.43% GC)
      --------------
      samples:          1487
      evals/sample:     1

```julia
@benchmark trapz(($vy, $vz),$M)
```

    BenchmarkTools.Trial:
      memory estimate:  314.41 KiB
      allocs estimate:  6
      --------------
      minimum time:     3.141 ms (0.00% GC)
      median time:      3.308 ms (0.00% GC)
      mean time:        3.323 ms (0.07% GC)
      maximum time:     3.848 ms (0.00% GC)
      --------------
      samples:          1504
      evals/sample:     1

```julia
@benchmark trapz($vy,$M,$2)
```

    BenchmarkTools.Trial:
      memory estimate:  481.98 KiB
      allocs estimate:  213
      --------------
      minimum time:     5.725 ms (0.00% GC)
      median time:      5.862 ms (0.00% GC)
      mean time:        5.891 ms (0.09% GC)
      maximum time:     8.389 ms (0.00% GC)
      --------------
      samples:          848
      evals/sample:     1


## Benchmark, when used inefficiently:

This code is optimized in order to perform the integral the fastest over the last dimension first, here instead we are performing integral in opposite order e.g. first x, then y, at last over z

```julia
@benchmark trapz(($vz,$vy,$vx),$M,$(3,2,1))
```

    BenchmarkTools.Trial:
      memory estimate:  949.70 KiB
      allocs estimate:  118
      --------------
      minimum time:     25.426 ms (0.00% GC)
      median time:      27.222 ms (0.00% GC)
      mean time:        27.381 ms (0.03% GC)
      maximum time:     29.378 ms (0.00% GC)
      --------------
      samples:          183
      evals/sample:     1
