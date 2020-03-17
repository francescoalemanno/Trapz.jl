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
      memory estimate:  347.33 KiB
      allocs estimate:  608
      --------------
      minimum time:     4.474 ms (0.00% GC)
      median time:      4.622 ms (0.00% GC)
      mean time:        4.679 ms (0.09% GC)
      maximum time:     6.431 ms (0.00% GC)
      --------------
      samples:          1068
      evals/sample:     1

```julia
@benchmark trapz(($vy, $vz),$M)
```

    BenchmarkTools.Trial:
      memory estimate:  342.53 KiB
      allocs estimate:  506
      --------------
      minimum time:     4.466 ms (0.00% GC)
      median time:      4.555 ms (0.00% GC)
      mean time:        4.589 ms (0.09% GC)
      maximum time:     5.859 ms (0.00% GC)
      --------------
      samples:          1089
      evals/sample:     1

```julia
@benchmark trapz($vy,$M,$2)
```

    BenchmarkTools.Trial:
      memory estimate:  481.98 KiB
      allocs estimate:  213
      --------------
      minimum time:     5.804 ms (0.00% GC)
      median time:      5.965 ms (0.00% GC)
      mean time:        5.977 ms (0.08% GC)
      maximum time:     7.685 ms (0.00% GC)
      --------------
      samples:          836
      evals/sample:     1


## Benchmark, when used inefficiently:

This code is optimized in order to perform the integral the fastest over the last dimension first, here instead we are performing integral in opposite order e.g. first x, then y, at last over z

```julia
@benchmark trapz(($vz,$vy,$vx),$M,(3,2,1))
```

    BenchmarkTools.Trial:
      memory estimate:  973.14 KiB
      allocs estimate:  618
      --------------
      minimum time:     25.125 ms (0.00% GC)
      median time:      26.670 ms (0.00% GC)
      mean time:        26.927 ms (0.07% GC)
      maximum time:     30.580 ms (0.00% GC)
      --------------
      samples:          186
      evals/sample:     1
