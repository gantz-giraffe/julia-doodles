using Luxor
using Images

interp(x,y,a) = x*(1-a) + y*a

function matinterp(mat,x,y)
    rx = Int(round(x)); ry = Int(round(y))
    fx = x-rx;  fy = y-ry
    interpa = interp(mat[rx,ry],mat[rx+1,ry],fx)
    interpb = interp(mat[rx,ry+1],mat[rx+1,ry+1],fx)
    interp(interpa,interpb,fy)
end
matinterp(mat,pos) = matinterp(mat,pos[1],pos[2])

coin(probability = 0.5) = rand() < probability


function pickdirection(board, pos, tries = 10000; dist = 1.0)
    phi = rand()*2pi
    dir = [cos(phi),sin(phi)]
    samplepos = dir*dist + pos
    sample = matinterp(board, samplepos)
    
    if (tries <= 0)
        [10,10] #flag vector used to tell system to stop
    elseif coin(red(sample))
        dir
    else
        pickdirection(board, pos, tries - 1, dist = dist)
    end
end

function pickdirection(board, pos::Point, tries = 10000; dist = 1.0)
    pickdirection(board,[pos[1],pos[2]])
end

function checkahead(board, pos, dir, dimensions, tries = 1000; dist = 1.0, prob = 0.01)
    newpos = pos + dir*dist

    if (newpos[1] > (dimensions[1] - 1)) || (newpos[2]  > (dimensions[2] -1)) || (newpos[1] <= 1) || (newpos[2] <= 1) #prevent escaping array bounds
        #= because we're using the mat interp which always indexes plus or minus 1, we need to max sure
        that we dont index above (dimension-length -1) or below 2=#
        pos
    else
        sample = matinterp(board,newpos)
        if (tries <= 0) || (coin(red(sample)*prob)) #if run out of tries or coin w sample probability returns true
            pos #return pos
        else
            checkahead(board,newpos,dir, dimensions, tries-1;dist = dist, prob = prob) #else keep going forward
        end
    end
end

function checkahead(board, pos::Point,dir,dimensions, tries = 1000; dist = 1.0, prob = 0.01)
    ini = checkahead(board,[pos[1],pos[2]],dir, dimensions, tries, dist = dist, prob = prob)
    Point(ini[1],ini[2])
end
dim = (1000,1000)

@draw begin
    board = fill(ARGB32(1.0),dim)
    origin(0,0)
    background("white")
    sethue("black")
    start = Point(rand()*dim[1], rand()*dim[2])
    #println(start)
    startdir = pickdirection(board,start)
    n = checkahead(board,start,startdir, dim, 100, dist= 10, prob= 0.01)
    #println(n)
    line(start,n)
    l = storepath()
    drawpath(l,action = :stroke)
    board = image_as_matrix()
    #imfilter(board,Kernel.gaussian(40))
    finish()
end 1000 1000
