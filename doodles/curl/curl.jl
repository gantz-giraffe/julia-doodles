using Luxor, Images

function curl(func, pos::Point, step = 0.000001)
    x1 = (func(pos.x,pos.y+step) - func(pos.x,pos.y-step))/2step
    y1 = (func(pos.x+step,pos.y) - func(pos.x-step,pos.y))/2step
    Point(x1,-y1)
end

img = fill(RGB(1.0,1.0,1.0),(500,500))

for j in 1:500
    for k in 1:500
        n = noise(j/100,k/100)
        c = curl(noise,Point(j/100,k/100))
        img[j,k] = n
    end
end
img

function flowline(func, pos::Point,iterations;step = 5)
    pts = fill(Point(0,0), iterations)
    curpos = pos
    for i in 1:iterations
        pts[i] = curpos
        curpos = curl(func,curpos)*5 + curpos
    end
    pts
end

begin
    Drawing(500,500)
    background("white")
    setline(1)
        for i in 1:2500
            p = randompoint(Point(0,0),Point(500,500))
            poly(flowline((a,b)->noise(a*0.01,b*0.01),p,rand(2000:3000),step = 100),action = :stroke)
        end
        finish()
        preview()
end