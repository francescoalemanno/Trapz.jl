# Trapz.jl

A simple Julia package to perform trapezoidal integration over common Julia arrays. 

the package is not registered on Julia Registry, so it can only be added as follows
```julia
import Pkg; Pkg.pkg"add https://github.com/francescoalemanno/Trapz.jl"
```


## Example Usage:


```julia
vx=range(0,1,length=100)
vy=range(0,2,length=200)
vz=range(0,3,length=300)
M=[x^2+y^2+z^2 for x=vx,y=vy,z=vz]
@show trapz(vx,trapz(vy,trapz(vz,M)));

M2=ones(100,3)
@show trapz(vx,M2,1);

```

    trapz(vx, trapz(vy, trapz(vz, M))) = 28.00030370797026
    trapz(vx, M2, 1) = [1.0, 1.0, 1.0]


# Benchmarks


```julia
@benchmark trapz($vx,trapz($vy,trapz($vz,$M,$(3)),$(2)),$(1))
```
    BenchmarkTools.Trial: 
      memory estimate:  819.89 KiB
      allocs estimate:  635
      --------------
      minimum time:     6.650 ms (0.00% GC)
      median time:      6.777 ms (0.00% GC)
      mean time:        6.845 ms (0.64% GC)
      maximum time:     8.328 ms (13.97% GC)
      --------------
      samples:          730
      evals/sample:     1
```julia
@benchmark trapz($vx,trapz($vy,trapz($vz,$M)))
```
    BenchmarkTools.Trial: 
      memory estimate:  818.83 KiB
      allocs estimate:  614
      --------------
      minimum time:     6.321 ms (0.00% GC)
      median time:      6.596 ms (0.00% GC)
      mean time:        6.880 ms (0.64% GC)
      maximum time:     12.562 ms (0.00% GC)
      --------------
      samples:          726
      evals/sample:     1
```julia
@benchmark trapz($vy,$M,$(2))
```
    BenchmarkTools.Trial: 
      memory estimate:  1.16 MiB
      allocs estimate:  220
      --------------
      minimum time:     8.253 ms (0.00% GC)
      median time:      8.313 ms (0.00% GC)
      mean time:        8.491 ms (0.64% GC)
      maximum time:     15.538 ms (6.67% GC)
      --------------
      samples:          589
      evals/sample:     1

## Benchmark, when used inefficiently:

This code is optimized in order to perform the integral the fastest over the last dimension first, here instead we are performing integral in opposite order e.g. first x, then y, at last over z


```julia
@benchmark trapz($vz,trapz($vy,trapz($vx,$M,1),1),1)
```
    BenchmarkTools.Trial: 
      memory estimate:  2.33 MiB
      allocs estimate:  635
      --------------
      minimum time:     48.092 ms (0.00% GC)
      median time:      48.965 ms (0.00% GC)
      mean time:        49.400 ms (0.22% GC)
      maximum time:     57.977 ms (0.00% GC)
      --------------
      samples:          102
      evals/sample:     1
```julia

```


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
```python

```
