using BenchmarkTools,Trapz

vx=range(0,1,length=100)
vy=range(0,2,length=200)
vz=range(0,3,length=300)
M=[x^2+y^2+z^2 for x=vx,y=vy,z=vz]

@benchmark trapz($(vx,vy,vz),$M)

@benchmark trapz($(vy, vz),$M)

@benchmark trapz($vy,$M,$2)

@benchmark trapz($(vz,vy,vx),$M,$(3,2,1))

using PyCall

@pyimport numpy as np

timenumpy = @belapsed np.trapz(np.trapz(np.trapz($M,$vz),$vy),$vx)

timejulia = @belapsed trapz($(vx,vy,vz),$M)

how_faster=timenumpy/timejulia

print("Trapz.jl is ~ ",how_faster," times faster than numpy's trapz") # 7.31 times 22 march 2020
