using Luxor

function makeGrid(x,y, rows, cols, radius)
    xspacing = sin(pi/6) * radius * 3
    yspacing =  cos(pi/6) * radius * 2    
    for j in 0:rows-1, k in 0:rows-1
        shift = ((j+1) % 2) * yspacing/2 #shift odd numbered rows
        ngon(x + j*xspacing, y + k*yspacing + shift, radius, 6, action=:stroke)
    end
end

@draw begin
    makeGrid(-200,-200,5,5,40)
end 800 800