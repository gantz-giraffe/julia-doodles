using Images
using Luxor

begin

Drawing(500,500,:png,"E:/code/Julia/doodle-rule.png")
    origin()
    background("darkblue")
    setline(1)
    for x in range(-250,stop=250,length=500)
        (x%13 < 4) ? setcolor(x/250,0,0.3-(x/150),0.5) : setcolor("grey")
        r= (abs(x%3) > 0.3) ? (2 * x / 250) : 1
        #print(r)
        rule(Point(x,0),(-pi/2) * r)
    end
   finish()
   preview()
end