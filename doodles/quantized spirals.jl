using Luxor

macro withtranslation(body,x,y)
    quote
        translate($(esc(x)),$(y))
        $(esc(body))
        translate(-1 * $(x),-1 * $(y))
    end
end
macro withrotation(body,angle)
    quote
        rotate($(angle))
        $(esc(body))
        rotate(-1 * $(angle))
    end
end
roundfrac(x,frac) = round(x/frac)*frac

function fermat(a,phi)
    mag = a*sqrt(phi)
    Point(mag*cos(phi),mag*sin(phi))
end
#rotation of fermat spiral is always the same as the unit circle for any value of 'phi'
#direction of spiral inverts if 'a' is negative

@draw begin
    angle = 3.14*pi
    vecs = [fermat(6,roundfrac(x,pi/4)) for x in range(0,angle, length = 32)]
    poly(vecs,:stroke)
    next = last(vecs)
    println(getmatrix())
    #translate(next[1],next[2])
    rotate(pi/4)
    poly([Point(0,0),Point(120,0)],:stroke)
    @withtranslation begin
        poly(1.5 .* vecs,:stroke)
    end 120 0
    @withrotation begin
        poly(vecs,:stroke)
    end pi/9

end 600 600