using Luxor

#make each iteration of makepoints create multiple points in the same vector


edgecheckx(x ::Int64, board ::BitMatrix) = (x >= size(board,2)-1)
edgecheckya(y ::Int64, board ::BitMatrix) = (y >= size(board,1)-1)
edgecheckyb(y ::Int64) = (y <= 1)

function edgedetect(x ::Integer, y ::Integer,board ::BitMatrix)
    if edgecheckx(x,board)
        [false,false,false]
    elseif edgecheckya(y,board)
        [false,board[x+1,y],board[x+1,y-1]]
    elseif edgecheckyb(y)
        [board[x+1,y+1],board[x+1,y],false]
    else
        [board[x+1,y+1],board[x+1,y],board[x+1,y-1]]
    end
end


function choice(options ::Vector{Bool}, x ::Integer, y ::Integer)
    roll = rand()
    if (roll <= 0.25) && (options[2] == true)
        [1,0] ::Vector{Int64}
    else
        nroll = rand()
        a = options[1]
        b = options[3]
        aout = [1, 1] ::Vector{Int64}
        bout = [1,-1] ::Vector{Int64}
        if nroll <= 0.5
            0
        elseif a && b
            (nroll <= 0.5) ? aout : bout
        elseif a
            aout
        elseif b
            bout
        else
            0
        end
    end
end

function vectpoints(pos ::Vector{Int64}, dir ::Vector{Int64}, board ::BitMatrix, inc = 50 ::Integer, retpos = [pos] ::Vector{Vector{Int64}})
    n = pos + dir
    if inc < 1 || board[n[1],n[2]] == false || edgecheckx(n[1],board) || edgecheckya(n[2],board) || edgecheckyb(n[2])
        retpos
    else
        push!(retpos,n)
        board[n[1],n[2]] = false
        vectpoints(n,dir,board,inc-1,retpos)
    end
end

function linepoints(pos ::Vector{Int64},accumpos ::Vector{Point},board ::BitMatrix,rem ::Dict{CartesianIndex{2}, Bool})
    x = pos[1]
    y = pos[2]
    options = edgedetect(x,y,board)
    direction = choice(options,x,y)
    if direction == 0 #gonna cause issues if accumpos is only holding on vector; fix later
        accumpos
    else
        board[x,y] = false
        vects = vectpoints(pos,direction,board)
        (i -> delete!(rem,CartesianIndex(i[1],i[2]))).(vects)
        append!(accumpos, (i -> Point(i[1],i[2])).(vects))
        linepoints(last(vects),accumpos,board,rem)
    end
end

linepoints([24,11],[Point(24,11)],trues(40,40),Dict(pairs(trues(40,40))))

function circuitpoints(xdim ::Integer,ydim ::Integer)
    board = trues(xdim,ydim)
    locs = Dict(pairs(board))
    firstpos = [rand(xdim:ydim), rand(xdim:ydim)]
    accumline = [linepoints(firstpos,[Point(firstpos[1],firstpos[2])],board,locs)]
    k = length(board)
    while k > 1
        start = rand(locs)
        sx = start[1][1]
        sy = start[1][2]
        #println(board[sx,sy])
        nextline = linepoints([sx,sy], [Point(sx,sy)], board, locs)
        push!(accumline, nextline)
        k -= length(nextline)
    end
    accumline
end

function drawcircuit(linepoints ::Vector{Point})
    if length(linepoints) < 2
        circle(linepoints[1],3)
    else
        poly(linepoints, :stroke, close = false)
    end
end

begin
    Drawing(50,50, "E:/code/Julia/julia-doodles/doodles/circuit board gen/test.svg")
    setcolor(0,0,0,1)
    setline(0.075)
    pathpoints = circuitpoints(50,50)
    [drawcircuit(x) for x = pathpoints]
    finish()
    preview()
end