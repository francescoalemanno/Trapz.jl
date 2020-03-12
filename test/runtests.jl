using Test
using Trapz
@info "Started Package Testing"
@testset "Basic Tests" begin
    vx=range(0,1,length=5)
    vy=range(0,2,length=10)
    vz=range(0,3,length=15)
    M=[x^2+y^2+z^2 for x=vx,y=vy,z=vz]
    res=28.157801083396322
    @test trapz((vx,vy,vz), M) ≈ res
    @test trapz((vz,vy,vx), M, (3,2,1)) ≈ res
    @test trapz((vy,vx,vz), M, (2,1,3)) ≈ res
end
