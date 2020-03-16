using Test
using Trapz
@info "Started Package Testing"
vx=range(0,1,length=5)
vy=range(0,2,length=10)
vz=range(0,3,length=15)
M=[x^2+y^2+z^2 for x=vx,y=vy,z=vz]
res=28.157801083396322
@testset "Methods full integral" begin
    @test trapz((vx,vy,vz), M) ≈ res
    @test trapz((vz,vy,vx), M, (3,2,1)) ≈ res
    @test trapz((vy,vx,vz), M, (2,1,3)) ≈ res
    @test trapz((vx,vy,vz), M, (1,2,3)) ≈ res
end
@testset "Methods partial integral, 2axis, 1axis" begin
    I_xy=trapz((vx,vy), M, (1,2))
    I_xz=trapz((vx,vz), M, (1,3))
    I_zx=trapz((vz,vx), M, (3,1))
    @test all(I_xz.≈I_zx)
    I_yz=trapz((vy,vz), M, (2,3))
    I_xy_z=trapz((vz,), I_xy, (1,))
    I_xz_y=trapz((vy,), I_xz, (1,))
    I_yz_x=trapz((vx,), I_yz, (1,))
    @test I_xy_z ≈ res
    @test I_yz_x ≈ res
    @test I_xz_y ≈ res
end
@testset "Methods only 1 axis" begin
    I_y=trapz(vy, M, 2)
    I_x=trapz(vx, I_y, 1)
    I_z=trapz(vz, I_x, 1)
    @test I_z ≈ res
end
@testset "Method only last axis" begin
    I_z=trapz(vz, M)
    I_y=trapz(vy, I_z)
    I_x=trapz(vx, I_y)
    @test I_x ≈ res
end
@testset "Corner case of empty vector" begin
    @test trapz(Float64[],Float64[]) == 0.0
    @test trapz(Float64[1],Float64[1]) == 0.0
end
@testset "Integrate by reshaped vector" begin
    @test trapz((1:10)',1:10)==trapz(1:10,1:10)
end
