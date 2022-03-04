using Images
using LinearAlgebra



function scale(in,minA,maxA,minB,maxB)
    ((in - minA)/(maxA - minA)) *(maxB-minB)+minB
 end
 

function popcorn_iter(width::Integer, height::Integer, v::Vector{Float64}, h = 0.05, incs::Integer = 4; a= 3.0, b = 3.0)
    x = v[1]
    y = v[2]
    xscale = 4
    yscale = 4
    if incs > 0
     n = [x - h*sin(y*yscale + tan(a * y*yscale)), y - h*sin(x*xscale + tan(b * x*xscale))]
     popcorn_iter(width,height,n,h,incs-1,a=a,b=b)
    else
     [scale(x,-1.1, 1.1, 1,width), scale(y,-1.1, 1.1, 1,height)]
    end
end


function popcorn_coords(width::Integer, height::Integer, h::Float64 = 0.05,  a::Float64 = 3.0, b::Float64 = 3.0, n::Integer= 1)
    tw = width/2
    th = height/2
    indmat = [(i,j) for i= range(-1.0,1.0,length= width), j= range(-1.0,1.0,length= height)]
    map(v -> popcorn_iter(width, height, [v[1],v[2]], h, n, a=a, b=b), indmat)
end

function fract_set_coeff(v)
    x = v[1]
    y = v[2]
    truncx = trunc(x)
    truncy = trunc(y)
    fractx = x - truncx
    fracty = y - truncy
    [(1-fractx)*(1-fracty) fractx*(1 - fracty); (1-fractx)*fracty fractx*fracty]
end


function popcorn_hist(width::Integer, height::Integer, h= 0.05, n=1;  a=3.0, b=3.0)
    zmat = zeros(width,height)
    cmat = popcorn_coords(width,height,h,a,b,n)
    cimat = map(x-> map(Integer,[trunc(x[1]),trunc(x[2])]), cmat)
    cfmat = map(fract_set_coeff,cmat)
    for i = 1:width-1, j = 1:height-1
        coor = cimat[i,j]
        zmat[coor[1]:coor[1]+1, coor[2]:coor[2]+1] += cfmat[i,j]
    end
    zmat
end

            
img = map(Gray,popcorn_hist(1000,1000,0.1,1,a=3.0,b=3.0)/8)

save(string("e:/code/Julia/julia-doodles/doodles/popcorn/poopcorn",time_ns(),".png"),map(clamp01nan,img))