using Luxor
using Images

pts = ngon(0, 0, 150, 3, pi/6, vertices=true)

offsetpoly(pts,)

bezpath = makebezierpath(pts)

un_to_bi(a ::Float64 ; min= -1.0, max = 1.0) = min *(1 - a) + max * a 

function turb(pt ::Point, amt ::Point, xf= 1.0 ::Float64, yf= 1.0 ::Float64, seed = rand() ::Float64)
    fun = (x,y) -> un_to_bi(noise(x, y, 4, 0.5))
    s = seed * 78123.0
    pt + Point(fun(pt.x*xf + s, pt.y*yf + s),fun(pt.x*xf + 389.0 + s, pt.y*yf + 389.0 + s)) * amt
end

function noisyoffset(cur ::Vector{Point},amt ::Point, camt ::Point, n ::Integer, col = [cur] ::Vector{Vector{Point}})
    if n > 1
        ncol = vcat(col,cur)
        offscur = map(x -> x + camt, cur)
        #turb = (x) -> un_to_bi(noise(x*141. + 10.))
        nxtmid ::Vector{Point} = [turb(offscur[i],amt, 10.5, 10.5) for i = 2:lastindex(offscur)-1]
        nxt = cat([offscur[1]],nxtmid,[last(offscur)],dims=1)
        noisyoffset(nxt,amt,camt,n-1,vcat(col,[nxt]))
    else
        col
    end
end




begin

    Drawing(1920,1080)#,string("E:/code/Julia/julia-doodles/doodles/line noise prog/lnp_",time_ns(),".svg"))
        background("white")
        setcolor(0,0,0,0.1)
        setdash([10,0.5,16,1])
        inipoints = noisyoffset([Point(0,i) for i = range(0,stop= 1080,length=10)],Point(15.,15.),Point(2000 / 1200,0.),4000)
        (x -> drawbezierpath(x,:stroke,close=false)).(map(makebezierpath,inipoints))
        img = image_as_matrix()
        finish()
        #preview
        save(string("E:/code/Julia/julia-doodles/doodles/line noise prog/lnp_",time_ns(),".png"),map(clamp01nan,img))
        img
        
    end
end