using Luxor, Images

function curl(func, pos::Point, step = 0.000001)
    x1 = (func(pos.x,pos.y+step) - func(pos.x,pos.y-step))/2step
    y1 = (func(pos.x+step,pos.y) - func(pos.x-step,pos.y))/2step
    Point(x1,-y1)
end

img = fill(RGB(1.0,1.0,1.0),(500,500))

for j in 1:500
    for k in 1:500
        #n = noise(j/10,k/10)
        c = curl(funnyfunc,Point(j/1,k/1))
        img[j,k] = RGB(c.x,c.y,0)
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

funnyfunc(x,y) = ((x + sin(x)*cos(y)*2)*0.01+(y+cos(x*y/2))*0.01)

begin
    w = 1500; h = 1500
    Drawing(w,h)
    background("white")
    setcolor(0,0,0,0.6666)
    setline(1)
        for i in 1:2000
            p = randompoint(Point(0,0),Point(w,h))
            poly(flowline((a,b)->funnyfunc(a/15+500,b/1.9+251),p,rand(2000:3000),step = 250),action = :stroke)
        end
        pic = image_as_matrix()
        finish()
        #preview()
        save(string("E:/code/Julia/julia-doodles-out/curl_out/curl_",time_ns(),".png"),map(clamp01nan,pic))
        pic
end