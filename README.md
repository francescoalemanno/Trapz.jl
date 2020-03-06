
[![Docs](https://img.shields.io/badge/docs-latest-blue.svg)](https://pkg.julialang.org/docs/Trapz)


# Trapz.jl

A simple Julia package to perform trapezoidal integration over common Julia arrays.

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
@show trapz((vx,vy,vz), M);

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
      minimum time:     7.459 ms (0.00% GC)
      median time:      7.657 ms (0.00% GC)
      mean time:        7.720 ms (0.24% GC)
      maximum time:     10.711 ms (0.00% GC)
      --------------
      samples:          647
      evals/sample:     1




```julia
@benchmark trapz(($vy, $vz),$M)
```




    BenchmarkTools.Trial:
      memory estimate:  342.53 KiB
      allocs estimate:  506
      --------------
      minimum time:     7.435 ms (0.00% GC)
      median time:      7.681 ms (0.00% GC)
      mean time:        7.743 ms (0.23% GC)
      maximum time:     13.389 ms (0.00% GC)
      --------------
      samples:          645
      evals/sample:     1




```julia
@benchmark trapz($vy,$M,2)
```




    BenchmarkTools.Trial:
      memory estimate:  482.02 KiB
      allocs estimate:  214
      --------------
      minimum time:     9.497 ms (0.00% GC)
      median time:      9.763 ms (0.00% GC)
      mean time:        9.991 ms (0.23% GC)
      maximum time:     15.369 ms (0.00% GC)
      --------------
      samples:          501
      evals/sample:     1



## Benchmark, when used inefficiently:

This code is optimized in order to perform the integral the fastest over the last dimension first, here instead we are performing integral in opposite order e.g. first x, then y, at last over z


```julia
@benchmark trapz(($vz,$vy,$vx),$M,(3,2,1))
```




    BenchmarkTools.Trial:
      memory estimate:  973.50 KiB
      allocs estimate:  628
      --------------
      minimum time:     60.976 ms (0.00% GC)
      median time:      63.567 ms (0.00% GC)
      mean time:        65.852 ms (0.07% GC)
      maximum time:     91.881 ms (0.00% GC)
      --------------
      samples:          76
      evals/sample:     1




## Comparison to Numpy trapz
At the time of writing this function when used correctly is faster than numpy's equivalent function.
Indeed the timings for Anaconda Python 3.7.3 with Numpy 1.16.2 on the same machine with same initial conditions on M,x,y,z are:
```python
%%timeit
np.trapz(np.trapz(np.trapz(M,x,axis=0),y,axis=0),z,axis=0)
```
    59.3 ms ± 1.45 ms per loop (mean ± std. dev. of 7 runs, 10 loops each)
```python
%%timeit
np.trapz(np.trapz(np.trapz(M,z,axis=2),y,axis=1),x,axis=0)
```
    74.7 ms ± 1.5 ms per loop (mean ± std. dev. of 7 runs, 10 loops each)
