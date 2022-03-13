using Images
using LinearAlgebra



function scale(in,minA,maxA,minB,maxB)
    ((in - minA)/(maxA - minA)) *(maxB-minB)+minB
 end
 

function popcorn_iter(width::Integer, height::Integer, v::Vector{Float64}, h = 0.05, a= 3.0, b = 3.0)
    x = v[1]
    y = v[2]
    xscale = 17.0*x #try changing xscale or yscale to 1/xscale or 1/yscale in different parts
    yscale = 11.9*y #or squaring xscale or yscale
    xn = x - h*sin(1/yscale + tan(a^2 * yscale)) 
    yn = y - h*sin(1/xscale + tan(b * xscale^2))
    [scale(xn,-1.1, 1.1, 1,width), scale(yn,-1.1, 1.1, 1,height)]
end


function popcorn_coords(width::Integer, height::Integer, h::Float64 = 0.05, a::Float64 = 3.0, b::Float64 = 3.0)
    tw = width/2
    th = height/2
    indmat = [(i,j) for i= range(-1.0,1.0,length= width), j= range(-1.0,1.0,length= height)]
    map(v -> popcorn_iter(width, height, [v[1],v[2]], h, a, b), indmat)
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


function popcorn_hist(width::Integer, height::Integer, h= 0.05, a=3.0, b=3.0)
    zmat = zeros(width,height)
    cmat = popcorn_coords(width,height,h,a,b)
    cimat = map(x-> map(Integer,[trunc(x[1]),trunc(x[2])]), cmat)
    cfmat = map(fract_set_coeff,cmat)
    for i = 1:width-1, j = 1:height-1
        coor = cimat[i,j]
        zmat[coor[1]:coor[1]+1, coor[2]:coor[2]+1] += cfmat[i,j]
    end
    zmat
end

img = imresize(map(Gray,popcorn_hist(5000,5000,0.08,0.4,0.09)/9),ratio=0.2)

save(string("e:/code/Julia/julia-doodles/doodles/popcorn/poopcorn",time_ns(),".png"),map(clamp01nan,img))