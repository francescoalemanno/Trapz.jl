using Test
using Trapz
@info "Started Package Testing"
vx=range(0,1,length=5)
vy=range(0,2,length=10)
vz=range(0,3,length=15)
M=[x^2+y^2+z^2 for x=vx,y=vy,z=vz]
res=28.157801083396322

@testset "Methods full integral,partial integral, 2axis, 1axis" begin
    @test trapz((vx,vy,vz), M) ≈ res

    I_xy=trapz((vx,vy,:), M)
    I_xz=trapz((vx,:,vz), M)
    I_yz=trapz((:,vy,vz), M)

    I_xy_z=trapz((vz,), I_xy)
    I_xz_y=trapz((vy,), I_xz)
    I_yz_x=trapz((vz,), I_xy)
    @test I_xy_z ≈ res
    @test I_yz_x ≈ res
    @test I_xz_y ≈ res
end

@testset "Methods only 1 axis" begin
    I_y=trapz(vy, M, Val(2))
    I_x_y=trapz(vx, I_y, Val(1))
    I_x_y_z=trapz(vz, I_x_y, Val(1))
    @test I_x_y_z ≈ res

    I_y=trapz((:,vy,:), M)
    I_x_y=trapz((vx,:), I_y)
    I_x_y_z=trapz(vz,I_x_y)
    @test I_x_y_z ≈ res
end

@testset "Method only last axis" begin
    I_z=trapz(vz, M)
    I_y=trapz(vy, I_z)
    I_x=trapz(vx, I_y)
    @test I_x ≈ res
end

@testset "Corner case of empty vector" begin
    @test trapz(zeros(Float16,()),zeros(Float16,())) == 0.0
    @test trapz(Float64[],Float64[]) == 0.0
    @test trapz(Float64[1],Float64[1]) == 0.0
end

@testset "Integrate by reshaped vector" begin
    @test trapz((1.0:10.0)',1.0:10.0)==trapz(1.0:10.0,1.0:10.0)
end

@testset "Some Inference Tests" begin
    args=((:,vy,:), M)
    @test typeof(trapz(args...))==Base.return_types(trapz,typeof.(args))[1]
    args=(vy, M, Val(2))
    @test typeof(trapz(args...))==Base.return_types(trapz,typeof.(args))[1]
    args=((vx,vy,:), M)
    @test typeof(trapz(args...))==Base.return_types(trapz,typeof.(args))[1]
end

@testset "@integrate macro" begin
    r=@integrate vx x begin
        @integrate vy y begin
            @integrate vz z begin
                x*x+y*y+z*z
            end
        end
    end
    @test r≈res
end
