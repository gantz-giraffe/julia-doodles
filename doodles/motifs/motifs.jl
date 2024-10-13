using Luxor

interp(start::Point,stop::Point,t) = start*(1-t) + stop*t

function zigzag(start::Point, stop::Point,width,n)
    dist = distance(start,stop)
    stepsize = 1/n
    dif = stop-start
    angle = atan(dif.y,dif.x)
    perp = Point(cos(angle+pi/2),sin(angle+pi/2))*width
    pts = [start]
    for i in 1:(n-1)
        dir = isodd(i) ? 1 : -1
        push!(pts,interp(start,stop, stepsize*i) + perp*dir)
    end
    push!(pts,stop)
end

function circleseq(start::Point, stop::Point, maxrad, n)
end

begin
    Drawing(500,500)
        background("black")
        sethue("white")
        pts = zigzag(Point(200,50), Point(300,30), 20, 20)
        poly(pts,action = :stroke)
        finish()
        preview()
end
