using Luxor

arcspiral(t,r,a) = Point(a*t*cos(t*r), a*t*sin(t*r))

r = 1.8
smoothcoeff = 1.6666

@draw begin
    vecs = [arcspiral(t,r,10) for t in range(0,pi*10, step= pi/8)]
    drawbezierpath(makebezierpath(vecs,smoothing=smoothcoeff),:stroke,close=false)
    #map(p-> circle(p,4,:stroke),vecs)
    prettypoly(vecs, ()-> (),
    vertexlabels = (a,b)->((a%3 == 0) ? 
    begin
        setcolor(1,1,1)
        circle(O,a/b*50,:fill)
        setcolor(0,0,0,0.5 + a/b*0.5)
        circle(O,a/b*40,:fill)
        setcolor(1,1,1)
        circle(O,a/b*10,:fill)
    end
     : begin
        setcolor(1,1,1)
        ngon(O,a/b*50,3,action=:fill)
        setcolor(0,0,0,0.5 + a/b*0.5)
        setopacity(1 - a/b*0.25)
        ngon(O,a/b*30,3,action=:fill)
        setcolor(1,1,1)
        circle(O,a/b*5,:fill)
        end))


end 1000 1000