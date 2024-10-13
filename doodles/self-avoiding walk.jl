using Luxor

board = zeros(Int64,10,10)

mutable struct Cell
    isopen::Bool
    uprightopen::Bool
    downrightopen::Bool
    downleftopen::Bool
    upleftopen::Bool
end

Cell() = Cell(true,true,true,true,true)

test(a, x, y) = a[x,y].upleftopen = false

function getneighborstates(board::Matrix{Int64},x,y)
    boarddims = size(board)
    firstx = (x==1);firsty = (y==1)
    lastx = (x==boarddims[1]);lasty = (y==boarddims[2])
    prevx = x-1;nextx = x+1; prevy = y-1;nexty = y+1

    #in these matrices a value of 1 indicates an occupied space on the board. These are checks for the corners
    if firstx
        if firsty
            [1 1 1; 1 1 board[nextx,y]; 1 board[nextx,nexty] board[x,nexty]]
        elseif lasty
            [1 board[x,prevy] board[nextx,prevy]; 1 1 board[nextx,y]; 1 1 1]            
        else
            [1 board[x,prevy] board[nextx,prevy]; 1 1 board[nextx,y]; 1 board[x,nexty] board[nextx,nexty]]
        end
    elseif firsty
        if lastx
            [1 1 1; board[prevx,y] 1 1; board[prevx,nexty] board[x,nexty] 1]
        else
            [1 1 1; board[prevx,y] 1 board[nextx,y]; board[prevx,nexty] board[x,nexty] board[nextx, nexty]]
        end
    elseif lastx
        if lasty
            [board[prevx,prevy] board[x,prevy] 1; board[prevx,y] 1 1; 1 1 1]
        else
            [board[prevx,prevy] board[x,prevy] 1; board[prevx,y] 1 1; board[prevx,nexty] board[x,nexty] 1]
        end
    elseif lasty
        [board[prevx,prevy] board[x,prevy] board[nextx,prevy]; board[prevx,y] 1 board[nextx,y]; 1 1 1]
    else
    [board[prevx,prevy] board[x,prevy] board[nextx,prevy]; 
    board[prevx,y] 1 board[nextx,y];
    board[prevx,nexty] board[x,nexty] board[nextx,nexty]]
    end
end


function getcandidates(board::Matrix{Int64}, pos::CartesianIndex{2})
    #offset from rand 1 thru 3 to -1 thru 1
    neighbors = transpose(getneighborstates(board,pos[1],pos[2]))
    map(a-> (a - CartesianIndex(2,2) + pos),findall(iszero,neighbors))
end

getcandidates(board::Matrix{Int64}, x,y) = getcandidates(board,CartesianIndex(x,y))

function getneighborstates(board::Matrix{Cell},x,y)
    boarddims = size(board)
    firstx = (x==1);firsty = (y==1)
    lastx = (x==boarddims[1]);lasty = (y==boarddims[2])
    prevx = x-1;nextx = x+1; prevy = y-1;nexty = y+1

    upleftcell = (firstx && firsty) ? false : board[prevx,prevy].isopen && board[prevx,prevy].downrightopen
    upcell = firsty ? false : board[x,prevy].isopen
    uprightcell = (lastx && firsty) ? false : board[nextx,prevy].isopen && board[nextx,prevy].downleftopen
    leftcell = firstx ? oob : board[prevx,y].isopen
    thiscell = false
    rightcell = lastx ? false : board[nextx,y].isopen
    downleftcell = (firstx && lasty) ? false : board[prevx,nexty].isopen && board[prevx,nexty].uprightopen
    downcell = lasty ? false : board[x,nexty].isopen
    downrightcell = (lastx && lasty) ? false : board[nextx,nexty].isopen && board[nextx,nexty].upleftopen

    [upleftcell upcell uprightcell;
    leftcell thiscell rightcell;
    downleftcell downcell downrightcell]
end

getneighborstates(board::Matrix{Cell},pos::CartesianIndex{2}) = getneighborstates(board,pos[1],pos[2])

global

function getcandidates(board::Matrix{Cell}, pos::CartesianIndex{2})
    #offset from rand 1 thru 3 to -1 thru 1
    neighbors = transpose(getneighborstates(board,pos[1],pos[2]))
    map(a-> (a - CartesianIndex(2,2)),findall(a-> a,neighbors))
end


function choosecandidate(board::Matrix{Cell}, pos::CartesianIndex{2}, candidates::Vector{CartesianIndex{2}})
    choice = rand(candidates)
    x = pos[1]; y = pos[2]
    if choice == CartesianIndex(-1,-1)
        board[x, y].isopen = false
        board[x-1, y].uprightopen = false
        board[x, y-1].downleftopen = false
    elseif choice == CartesianIndex(1,-1)
        board[x, y].isopen = false
        board[x+1, y].upleftopen = false
        board[x, y-1].downrightopen = false
    elseif choice == CartesianIndex(-1,1)
        board[x, y].isopen = false
        board[x-1, y].downrightopen = false
        board[x, y+1].upleftopen = false
    elseif choice == CartesianIndex(1,1)
        board[x, y].isopen = false
        board[x+1, y].downleftopen = false
        board[x, y+1].uprightopen = false
    else
        board[x, y].isopen = false #no check to make sure direction is valid
    end
    choice + pos
end



begin
    logbrd = fill(Cell(),8,8)
    markbrd = zeros(Int64,8,8)
    pos = CartesianIndex(5,5)
    #count = 0

    for i in 1:10
        candidates = getcandidates(logbrd,pos)
        if isempty(candidates) || (markbrd[pos] > 0)
            break #stop if there's no place to move or if you're in a spot you're not supposed to be
        else
            choice = choosecandidate(logbrd,pos,candidates)
            markbrd[pos] += 1
            pos = choice
            println(pos)
            #count += 1
        end
    end
   # println("count: ", count)
    markbrd

end

begin
    brd = zeros(Int64,8,8)
    pos = CartesianIndex(5,5)
    #count = 0

    for i in 1:101
        candidates = getcandidates(brd,pos)
        if isempty(candidates) || (brd[pos] > 0)
            break #stop if there's no place to move or if you're in a spot you're not supposed to be
        else
            brd[pos] += 1
            pos = rand(candidates)
            #count += 1
        end
    end
   # println("count: ", count)
    brd

end