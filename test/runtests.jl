using Test
using Trapz

@testset "Basic Tests" begin
    vx=range(0,1,length=100)
    vy=range(0,2,length=200)
    vz=range(0,3,length=300)
    M=[x^2+y^2+z^2 for x=vx,y=vy,z=vz]
    @test trapz((vx,vy,vz), M) ≈ 28.000303707970264
end
