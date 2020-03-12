using Test
using Trapz
@info "Started Package Testing"
@testset "Basic Tests" begin
    vx=range(0,1,length=5)
    vy=range(0,2,length=5)
    vz=range(0,3,length=5)
    M=[x^2+y^2+z^2 for x=vx,y=vy,z=vz]
    @test trapz((vx,vy,vz), M) == 28.875
end
